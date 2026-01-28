#pragma once

#include <stddef.h>  // size_t
#include <stdint.h>  // uint*_t

// Number of supported simple type parameters
#if defined(TARGET_STAX) || defined(TARGET_FLEX)
#define PARAMETERS_MAX_NUM 150
#else
#define PARAMETERS_MAX_NUM 90
#endif

enum {
    GAS_PRICE_MIN = 500,
    GAS_LIMIT_MIN = 20000,
};

// The number of fixed-length bytes at the contract end
enum {
    NATIVE_CONTRACT_CONSTANT_LENGTH = 47,   //native contract
    NEOVM_CONTRACT_CONSTANT_LENGTH = 22,    //neovm contract
};

enum {
    OPCODE_PUSHBYTES21 = 0x21,
    OPCODE_PUSH_NUMBER = 0x50, // PUSHN = OPCODE_PUSH_NUMBER + N, 1<=N<=16
    OPCODE_CHECKSIG = 0xac,
};

static const uint8_t OPCODE_SYSCALL[] = {0x00, 0x68};
static const uint8_t OPCODE_APPCALL[] = {0x67};
static const uint8_t OPCODE_PACK[] = {0xc1};
static const uint8_t OPCODE_END[] = {0x00};
static const uint8_t OPCODE_ST_BEGIN[] = {0x00, 0xc6, 0x6b};
static const uint8_t OPCODE_ST_END[] = {0x6c};
static const uint8_t OPCODE_PARAM_END[] = {0x6a, 0x7c, 0xc8};
static const uint8_t OPCODE_PARAM_ST_END[] = {0x6a, 0x7c, 0xc8, 0x6c};
static const uint8_t NATIVE_INVOKE[] = {0x16, 'O', 'n', 't', 'o', 'l', 'o', 'g', 'y', '.', 'N', 'a',
                                        't',  'i', 'v', 'e', '.', 'I', 'n', 'v', 'o', 'k', 'e'};

/**
 * Enumeration with parsing status.
 */
typedef enum {
    PARSING_OK = 1,
    PARSING_TX_NOT_DEFINED = -2, //not found in the pre-defined contract and method list.
    PARSING_LENGTH_WRONG = -3,
    PARSING_BYTECODE_WRONG = -4,
} parser_status_e;

/**
 * Enumeration with transaction contract type.
 */
typedef enum {
    UNKNOWN_CONTRACT,
    NATIVE_CONTRACT,
    NEOVM_CONTRACT,
    WASMVM_CONTRACT,
} tx_contract_type_e;

/**
 * Enumeration with transaction parameter type.
 */
typedef enum {
    PARAM_END,       // Marks the end of parameters, not an actual parameter
    PARAM_ADDR,      // Simple type: uint8_t[20], represents an address
    PARAM_PUBKEY,    // Simple type: uint8_t[66], represents a public key
    PARAM_AMOUNT,    // Simple type, represents an amount
    PARAM_UINT128,   // Simple type: uint8_t[16], represents a 128-bit unsigned integer
    PARAM_ONTID,     // Simple type, represents an ONT ID
    PARAM_PK_AMOUNT_PAIRS,      // Composite type: PARAM_PUBKEY, PARAM_AMOUNT
    PARAM_TRANSFER_STATE,       // Composite type: PARAM_ADDR, PARAM_ADDR, PARAM_AMOUNT
    PARAM_TRANSFER_STATE_LIST,  // Composite type: PARAM_TRANSFER_STATE * n
} tx_parameter_type_e;

/**
 * Structure for transaction header.
 */
typedef struct {
    uint8_t version;
    uint8_t tx_type;
    uint8_t *payer;
    uint32_t nonce; 
    uint64_t gas_price;
    uint64_t gas_limit;
} tx_header_t;

/**
 * Structure for transaction parameter.
 */
typedef struct {
    uint8_t *data;
    tx_parameter_type_e type;
    uint8_t len;
} tx_parameter_t;

/**
 * Structure for transaction contract.
 */
typedef struct {
    tx_contract_type_e type;
    tx_parameter_t addr;
    const char *ticker;
    uint8_t token_decimals;
} tx_contract_t;

/**
 * Structure for transaction method.
 */
typedef struct {
    tx_parameter_t name;
    tx_parameter_t parameters[PARAMETERS_MAX_NUM];  //only store simple type parameters
} tx_method_t;

/**
 * Structure for transaction.
 */
typedef struct {
    tx_header_t header;
    tx_contract_t contract;
    tx_method_t method;
} transaction_t;
