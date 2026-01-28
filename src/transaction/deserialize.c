/*****************************************************************************
 *   Ontology Ledger App
 *   (c) 2025 Ontology
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *****************************************************************************/

/* the Ontology transaction format is as follows:
tx:
| Header     | payload size| payload code|   \x00   |
|--42 bytes--|--any bytes--|--any bytes--|-- 1byte--|

A. tx header
|  Version |  tx-type |    nonce  |  gasprice |  gaslimit |    payer   |
|--1 byte--|--1 byte--|--4 bytes--|--8 bytes--|--8 bytes--|--20 bytes--|

1. Version:
Currently, the `version` of the transaction supported by the Ontology Network is 0x00.

2. tx-type:
The valid `tx-type` of the transaction include two values:
- 0xd1: the transaction is a native transaction or a neovm contract transaction.
- 0xd2: the transaction is a wasmvm contract transaction.

3. nonce:
The `nonce` is a 4-byte unsigned integer.

4. gasPrice:
The `gasPrice` is a 8-byte unsigned integer, which has a minimum value of 500.

5. gasLimit:
The `gasLimit` is a 8-byte unsigned integer, which has a minimum value of 20000.

6. payer:
The `payer` is a 20-byte script hash and pays the gas for the transaction.
It can be encoded in the `base58` format to get the payer `address`. We do not show it in the UI.


B. payload size
If the first byte is less than 0xfd, it indicates the length of the payload.

If the first byte equals 0xfd, the next two bytes are interpreted as a uint16_t in little-endian
order to represent the payload length.

If the first byte equals 0xfe, the next four bytes are interpreted as a uint32_t in little-endian
order to represent the payload length.

If the first byte equals 0xff, the next eight bytes are interpreted as a uint64_t in little-endian
order to represent the payload length.

C. tx payload code:
Native contract
|    Params   |Method-w-Length|Contract-w-Length|\x00 + SYSCALL|len + "Ontology.Native.Invoke"|
|--any bytes--| --any bytes-- |  --21 bytes--   |  --2 bytes-- |         --23 byte--          |

NEOVM contract
|    Params   | Params-Count |    0xC1  |Method-w-Length|  APPCALL | Contract-wo-Length |
|--any bytes--| --any bytes--|--1 byte--| --any bytes-- |--1 byte--|     --20 byte--    |

WASM contract
| Contract-wo-Length | Remaining-Length |Method-w-Length|    Params   |
|    --20 bytes--    |   --any bytes--  |--any bytes--  |--any bytes--|

1. The parameters of the Native Token（ONG/ONT）'s `transfer` and `TransferV2` functions consist of
multiple `transferstate` structures, followed by the count of `transferstate` structures and a
single byte `opcode_pack`.

Specifically: `transferstate transferstate ... transferstate amount c1`

2. The bytecode for parameters in other functions of the Native contract is as follows:
`00c66b param1 6a7cc8 param2 6a7cc8 param3 6a7cc8 ... paramn 6a7cc8 6c`
Here, `param` could be an `addr`, an `amount`, a `transferstate`, a `pk`, a `pk_num_pair`,
etc.

3. The bytecode for each `transferstate` is as follows:
`00c66b addr-w-length 6a7cc8 addr-w-length 6a7cc8 amount 6c`
Here, `6a7cc8` indicates the end of each parameter. The first two address parameters represent the
from address and to address of the transfer, and the third amount parameter represents the transfer
amount.

4. Address Parameter
The length of an address is 20 bytes. The `address` in params in Native and Neovm contracts has a
length as prefix (0x20), while address in params in Wasm contract has NO length as prefix.

5. Amount Parameter
The  `amount` in params in Native and Neovm contracts has an one-byte prefix.
If the first byte, namely the prefix, of the amount is between 0x51 and 0x60, i.e., the opcode is
PUSHN, it indicates that the value of this number is N. For example, if the first byte is 0x51, the
amount is 1.

When the value N of the first byte of the amount is less than or equal to 16, it means the next N
bytes are interpreted as a uint64_t integer in little-endian order as the value of the amount.

Other cases are considered invalid bytecode.

In WASM contracts, the amount is 16 bytes, which is parsed as a uint128_t in little-endian order.
Similarly, there is no prefix indicating the length.

*/

#include <stdint.h>
#include <string.h>

#include "buffer.h"
#include "macros.h"

#include "deserialize.h"
#include "utils.h"
#include "types.h"
#include "parse.h"
#include "contract.h"
#include "address.h"

#if defined(TEST) || defined(FUZZ)
#include "assert.h"
#define LEDGER_ASSERT(x, y) assert(x)
#else
#include "ledger_assert.h"
#endif

// Deserialize and check the header of the transaction (the first 42 bytes of the transaction)
// The parameters and outputs of this function are same as the `transaction_deserialize` function.
static parser_status_e transaction_deserialize_header(buffer_t *buf, transaction_t *tx) {
    LEDGER_ASSERT(buf != NULL, "NULL buf");
    LEDGER_ASSERT(tx != NULL, "NULL tx");

    if (buf->size > MAX_TRANSACTION_LEN) {
        return PARSING_LENGTH_WRONG;
    }

    // version
    if (!buffer_read_u8(buf, &tx->header.version) || tx->header.version != 0x00) {
        return PARSING_BYTECODE_WRONG;
    }

    // tx_type, check later if it's valid or not
    if (!buffer_read_u8(buf, &tx->header.tx_type)) {
        return PARSING_BYTECODE_WRONG;
    }

    // nonce
    if (!buffer_read_u32(buf, &tx->header.nonce, LE)) {
        return PARSING_BYTECODE_WRONG;
    }

    // gasPrice
    if (!buffer_read_u64(buf, &tx->header.gas_price, LE) || tx->header.gas_price < GAS_PRICE_MIN) {
        return PARSING_BYTECODE_WRONG;
    }

    // gasLimit
    if (!buffer_read_u64(buf, &tx->header.gas_limit, LE) || tx->header.gas_limit < GAS_LIMIT_MIN ||
        tx->header.gas_limit > TOKEN_AMOUNT / tx->header.gas_price) {
        return PARSING_BYTECODE_WRONG;
    }

    // payer
    tx->header.payer = (uint8_t *) (buf->ptr + buf->offset);
    if (!buffer_seek_cur(buf, ADDRESS_SCRIPT_HASH_LEN)) {
        return PARSING_BYTECODE_WRONG;
    }

    return PARSING_OK;
}

// Deserialize the payload size of the transaction, and check if the payload size is valid.
// The parameters and outputs of this function are same as the `transaction_deserialize` function.
static parser_status_e transaction_deserialize_payload_size(buffer_t *buf, transaction_t *tx) {
    LEDGER_ASSERT(buf != NULL, "NULL buf");
    LEDGER_ASSERT(tx != NULL, "NULL tx");

    uint8_t first_byte = 0;
    size_t payload_size = 0;
    if (!buffer_read_u8(buf, &first_byte) || first_byte == 0) {
        return PARSING_BYTECODE_WRONG;
    }

    switch (first_byte) {
        case 0xfd: {
            uint16_t payload_size_16 = 0;
            if (!buffer_read_u16(buf, &payload_size_16, LE)) {
                return PARSING_BYTECODE_WRONG;
            }
            payload_size = payload_size_16;
            break;
        }
        case 0xfe: {
            uint32_t payload_size_32 = 0;
            if (!buffer_read_u32(buf, &payload_size_32, LE)) {
                return PARSING_BYTECODE_WRONG;
            }
            payload_size = payload_size_32;
            break;
        }
        case 0xff: {
            uint64_t payload_size_64 = 0;
            if (!buffer_read_u64(buf, &payload_size_64, LE)) {
                return PARSING_BYTECODE_WRONG;
            }
            payload_size = payload_size_64;
            break;
        }
        default:
            payload_size = first_byte;
            break;
    }

    bool is_valid = (buf->offset + payload_size + ARRAY_LENGTH(OPCODE_END) != buf->size);

    return is_valid ? PARSING_LENGTH_WRONG : PARSING_OK;
}

// Deserialize the contract of the transaction and get the contract type and address.
// It also check the following fiexd bytes of the native and neovm contracts.
// The parameters and outputs of this function are same as the `transaction_deserialize` function.
static parser_status_e transaction_deserialize_contract(buffer_t *buf, transaction_t *tx) {
    LEDGER_ASSERT(buf != NULL, "NULL buf");
    LEDGER_ASSERT(tx != NULL, "NULL tx");

    size_t os = buf->offset;
    switch (tx->header.tx_type) {
        case 0xd1: {
            if(!buffer_can_read(buf, ARRAY_LENGTH(OPCODE_END) + ADDRESS_SCRIPT_HASH_LEN + 1)) {
                return PARSING_BYTECODE_WRONG;
            }
            if (buf->ptr[buf->size - ARRAY_LENGTH(OPCODE_END) - ADDRESS_SCRIPT_HASH_LEN - 1] !=
                OPCODE_APPCALL[0]) {  //'n' for the native contract
                tx->contract.type = NATIVE_CONTRACT;
                if (!buffer_can_read(buf, NATIVE_CONTRACT_CONSTANT_LENGTH) ||
                    !buffer_seek_set(buf, buf->size - NATIVE_CONTRACT_CONSTANT_LENGTH) ||
                    !parse_address(buf, true, &(tx->contract.addr)) ||
                    !parse_check_constant(buf, OPCODE_SYSCALL, ARRAY_LENGTH(OPCODE_SYSCALL)) ||
                    !parse_check_constant(buf, NATIVE_INVOKE, ARRAY_LENGTH(NATIVE_INVOKE)) ||
                    !parse_check_constant(buf, OPCODE_END, ARRAY_LENGTH(OPCODE_END)) ||
                    buf->offset != buf->size || !buffer_seek_set(buf, os)) {
                    return PARSING_BYTECODE_WRONG;
                }
            } else {  // 0x67 for the neovm contract
                tx->contract.type = NEOVM_CONTRACT;
                if (!buffer_can_read(buf, NEOVM_CONTRACT_CONSTANT_LENGTH) ||
                    !buffer_seek_set(buf, buf->size - NEOVM_CONTRACT_CONSTANT_LENGTH) ||
                    !parse_check_constant(buf, OPCODE_APPCALL, ARRAY_LENGTH(OPCODE_APPCALL)) ||
                    !parse_address(buf, false, &(tx->contract.addr)) ||
                    !parse_check_constant(buf, OPCODE_END, ARRAY_LENGTH(OPCODE_END)) ||
                    buf->offset != buf->size || !buffer_seek_set(buf, os)) {
                    return PARSING_BYTECODE_WRONG;
                }
            }
            break;
        }
        case 0xd2:
            tx->contract.type = WASMVM_CONTRACT;
            if (!parse_address(buf, false, &(tx->contract.addr))) {
                return PARSING_BYTECODE_WRONG;
            }
            break;
        default:
            return PARSING_BYTECODE_WRONG;
    }
    return PARSING_OK;
}

// Deserialize the method of the transaction and get the method name.
// For native contracts and neovm contracts, since the trailing bytes are fixed, parse backwards
// until encountering either 0xc1 (for NEOVM contract transactions and native token
// transfer/transferV2 transactions) or 0x6a7cc86c (for other native transactions). The method name
// follows these bytes.
// For wasm contracts, the method name is the first parameter in the payload section.
// The parameters and outputs of this function are same as the `transaction_deserialize` function.
static parser_status_e transaction_deserialize_method(buffer_t *buf, transaction_t *tx) {
    LEDGER_ASSERT(buf != NULL, "NULL buf");
    LEDGER_ASSERT(tx != NULL, "NULL tx");

    size_t sBegin = buf->offset;
    size_t sEnd = 0;
    switch (tx->contract.type) {
        case NATIVE_CONTRACT:
            sEnd = buf->size - NATIVE_CONTRACT_CONSTANT_LENGTH;
            break;
        case NEOVM_CONTRACT:
            sEnd = buf->size - NEOVM_CONTRACT_CONSTANT_LENGTH;
            break;
        case WASMVM_CONTRACT: {
            uint8_t remaining_size = 0;
            if (!buffer_read_u8(buf, &remaining_size) || remaining_size == 0 ||
                remaining_size != buf->size - buf->offset - ARRAY_LENGTH(OPCODE_END) ||
                !parse_method_name(buf, &(tx->method.name))) {
                return PARSING_BYTECODE_WRONG;
            }
            return PARSING_OK;
        }
        default:
            return PARSING_BYTECODE_WRONG;
    }

    // Validate sEnd to prevent underflow
    if (sEnd < sBegin || sEnd > buf->size || sEnd < sBegin + (ARRAY_LENGTH(OPCODE_PACK) - 2)) {
        return PARSING_BYTECODE_WRONG;
    }

    size_t method_intent_length = 0;
    size_t cur = 0;
    for (size_t i = sEnd - (ARRAY_LENGTH(OPCODE_PACK) - 2); i >= sBegin; i--) {
        if (tx->contract.type == NATIVE_CONTRACT &&
            i <= sEnd - (ARRAY_LENGTH(OPCODE_PARAM_ST_END) - 2) &&
            memcmp(buf->ptr + i, OPCODE_PARAM_ST_END, ARRAY_LENGTH(OPCODE_PARAM_ST_END)) == 0) {
            cur = i + ARRAY_LENGTH(OPCODE_PARAM_ST_END);
            break;
        }
        if (memcmp(buf->ptr + i, OPCODE_PACK, ARRAY_LENGTH(OPCODE_PACK)) == 0) {
            cur = i + ARRAY_LENGTH(OPCODE_PACK);
            break;
        }
    }
    method_intent_length = sEnd - 1 - cur;

    if (!buffer_seek_set(buf, cur) || method_intent_length == 0 ||
        !parse_method_name(buf, &(tx->method.name)) || tx->method.name.len != method_intent_length ||
        !buffer_seek_set(buf, sBegin)) {
        return PARSING_BYTECODE_WRONG;
    }
    return PARSING_OK;
}

// Deserialize the parameters of the native token's transfer and transferV2 functions.
// Called by `transaction_deserialize_params` function.
// The parameters and outputs of this function are same as the `transaction_deserialize` function.
static parser_status_e native_transfer_deserialize_params(buffer_t *buf, transaction_t *tx) {
    LEDGER_ASSERT(buf != NULL, "NULL buf");
    LEDGER_ASSERT(tx != NULL, "NULL tx");

    size_t num = 0;
    size_t cur = 0;
    while (buf->ptr[buf->offset] == OPCODE_ST_BEGIN[0]) {
        if (!parse_trasfer_state(buf, &(tx->method.parameters[cur]), &cur)) {
            return PARSING_BYTECODE_WRONG;
        }
        num++;
    }

    return parse_check_amount(buf, num) &&
                   parse_check_constant(buf, OPCODE_PACK, ARRAY_LENGTH(OPCODE_PACK))
               ? PARSING_OK
               : PARSING_BYTECODE_WRONG;
}

// Deserialize the parameters of the transaction.
// Besides getting the parameters, also set the token ticker and token decimals.
// The original decimals of ONT and ONG are 0 and 9, respectively.
// If the transaction is a transferV2, approveV2, or transferFromV2 transaction, the decimals of ONT
// and ONG are 9 and 18, respectively. The parameters and outputs of this function are same as the
// `transaction_deserialize` function.
// Here we also check if the transaction is a blind signed transaction, namely the method is not
// found in the registered payload array.
static parser_status_e transaction_deserialize_params(buffer_t *buf, transaction_t *tx) {
    LEDGER_ASSERT(buf != NULL, "NULL buf");
    LEDGER_ASSERT(tx != NULL, "NULL tx");

    if (tx->contract.type == NATIVE_CONTRACT) {
        tx->contract.token_decimals = ONT_DECIMALS;
        bool is_ont = memcmp(tx->contract.addr.data, ONT_ADDR, ADDRESS_SCRIPT_HASH_LEN) == 0;
        bool is_ong = memcmp(tx->contract.addr.data, ONG_ADDR, ADDRESS_SCRIPT_HASH_LEN) == 0;
        if (is_ont || is_ong) {
            bool is_transfer = methodcmp(&tx->method.name, METHOD_TRANSFER);
            bool is_transfer_v2 = methodcmp(&tx->method.name, METHOD_TRANSFER_V2);
            bool is_transfer_from_v2 = methodcmp(&tx->method.name, METHOD_TRANSFER_FROM_V2);
            bool is_approve_v2 = methodcmp(&tx->method.name, METHOD_APPROVE_V2);

            tx->contract.token_decimals = is_ong ? ONG_DECIMALS : ONT_DECIMALS;
            if (is_transfer_v2 || is_transfer_from_v2 || is_approve_v2) {
                tx->contract.token_decimals += 9;
            }

            if (is_transfer || is_transfer_v2) {
                tx->contract.ticker = is_ont ? ONT_TICKER : ONG_TICKER;
                return native_transfer_deserialize_params(buf, tx);
            }
        }

        if (!parse_check_constant(buf, OPCODE_ST_BEGIN, ARRAY_LENGTH(OPCODE_ST_BEGIN))) {
            return PARSING_BYTECODE_WRONG;
        }
    }

    payload_t payload[PREDEFINED_CONTRACT_NUM];
    get_tx_payload(payload);

    //count the number of parameters
    //it is only used to check when the transaction is a neovm contract transaction
    //It is NOT right to use it to get the number of parameters for other types of transactions.
    //The parameters of a neovm contract transaction are simple types, not composite types
    size_t params_num = 0; 

    for (size_t i = 0; i < PREDEFINED_CONTRACT_NUM; i++) {
        if (memcmp(tx->contract.addr.data, payload[i].contract_addr, ADDRESS_SCRIPT_HASH_LEN) == 0) {
            tx->contract.ticker = payload[i].ticker;
            if (tx->contract.type != NATIVE_CONTRACT) {
                tx->contract.token_decimals = payload[i].token_decimals;
            }
            const tx_method_signature_t *methods = payload[i].methods;
            while (methods->name != NULL) {
                if (methodcmp(&tx->method.name, methods->name)) {
                    if (!parse_method_params(buf, tx, methods->parameters, &params_num)) {
                        return PARSING_BYTECODE_WRONG;
                    }
                    break;
                }
                ++methods;
            }
            if (methods->name == NULL) {
                return PARSING_TX_NOT_DEFINED;  // blind signed transaction
            }
            break;
        }
        if (i == PREDEFINED_CONTRACT_NUM - 1) {
            return PARSING_TX_NOT_DEFINED;  // blind signed transaction
        }
    }

    if (tx->contract.type == NATIVE_CONTRACT &&
        !parse_check_constant(buf, OPCODE_ST_END, ARRAY_LENGTH(OPCODE_ST_END))) {
        return PARSING_BYTECODE_WRONG;
    }
    if (tx->contract.type == NEOVM_CONTRACT &&
        (!parse_check_amount(buf, params_num) ||
         !parse_check_constant(buf, OPCODE_PACK, ARRAY_LENGTH(OPCODE_PACK)))) {
        return PARSING_BYTECODE_WRONG;
    }
    if (tx->contract.type == WASMVM_CONTRACT &&
        !parse_check_constant(buf, OPCODE_END, ARRAY_LENGTH(OPCODE_END))) {
        return PARSING_BYTECODE_WRONG;
    }

    return PARSING_OK;
}

// Deserialize the transaction.
// Parse the transaction header, payload size, contract, method, and parameters sequentially.
parser_status_e transaction_deserialize(buffer_t *buf, transaction_t *tx) {
    LEDGER_ASSERT(buf != NULL, "NULL buf");
    LEDGER_ASSERT(tx != NULL, "NULL tx");

    parser_status_e status = transaction_deserialize_header(buf, tx);
    if (status != PARSING_OK) {
        return status;
    }

    status = transaction_deserialize_payload_size(buf, tx);
    if (status != PARSING_OK) {
        return status;
    }

    status = transaction_deserialize_contract(buf, tx);
    if (status != PARSING_OK) {
        return status;
    }

    status = transaction_deserialize_method(buf, tx);
    if (status != PARSING_OK) {
        return status;
    }

    status = transaction_deserialize_params(buf, tx);
    if (status != PARSING_OK) {
        return status;
    }

    size_t len = 0;
    switch (tx->contract.type) {
        case NATIVE_CONTRACT:
            len = tx->method.name.len + 1 + NATIVE_CONTRACT_CONSTANT_LENGTH;
            break;
        case NEOVM_CONTRACT:
            len = tx->method.name.len + 1 + NEOVM_CONTRACT_CONSTANT_LENGTH;
            break;
        case WASMVM_CONTRACT:
            len = 0;
            break;
        default:
            return PARSING_BYTECODE_WRONG;
    }

    return (buf->offset + len == buf->size) ? PARSING_OK : PARSING_LENGTH_WRONG;
}
