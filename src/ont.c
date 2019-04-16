/*
 * MIT License, see root folder for full license.
 */
#include "ont.h"

/** if true, show a screen with the transaction type. */
#define SHOW_TX_TYPE false

/** if true, show a screen with the transaction length. */
#define SHOW_TX_LEN false

/** if true, show a screen with the transaction version. */
#define SHOW_VERSION false

/** if true, show the tx-type exclusive data, such as coin claims for a Claim Tx */
#define SHOW_EXCLUSIVE_DATA false

/** if true, show number of attributes. */
#define SHOW_NUM_ATTRIBUTES false

/** if true, show number of tx-in coin references. */
#define SHOW_NUM_COIN_REFERENCES false

/** if true, show number of output transactions. */
#define SHOW_NUM_TX_OUTS false

/** if true, show tx-out values in hex as well as decimal. */
#define SHOW_VALUE_HEX false

/** if true, show script hash screen as well as address screen */
#define SHOW_SCRIPT_HASH false

/**
 * each CoinReference has two fields:
 *  UInt256 PrevHash = 32 bytes.
 *  ushort PrevIndex = 2 bytes.
 */
#define COIN_REFERENCES_LEN (32 + 2)

/** length of tx.output.value */
#define VALUE_LEN 8

/** length of tx.output.asset_id */
#define ASSET_ID_LEN 32

/** length of tx.output.script_hash */
#define SCRIPT_HASH_LEN 20

/** length of the checksum used to convert a tx.output.script_hash into an Address. */
#define SCRIPT_HASH_CHECKSUM_LEN 4

/** length of a tx.output Address, after Base58 encoding. */
#define ADDRESS_BASE58_LEN 34

/** length of a tx.output Address before encoding, which is the length of <address_version>+<script_hash>+<checksum> */
#define ADDRESS_LEN (1 + SCRIPT_HASH_LEN + SCRIPT_HASH_CHECKSUM_LEN)

/** the current version of the address field */
#define ADDRESS_VERSION 23

/** the length of a SHA256 hash */
#define SHA256_HASH_LEN 32

/** the position of the decimal point, 8 characters in from the right side */
#define DECIMAL_PLACE_OFFSET 8

/**
 * transaction types.
 *
 * Currently only Claim and Contract are tested, as they are the only ones supported by the current wallets.
 */
enum TX_TYPE {
    TX_MINER = 0x00,
    TX_ISSUE = 0x01,
    TX_CLAIM = 0x02,
    TX_ENROLL = 0x20,
    TX_REGISTER = 0x40,
    TX_CONTRACT = 0x80,
    TX_PUBLISH = 0xD0,
    TX_INVOKE = 0xD1
};

/**
 * transaction attributes.
 *
 * currently there's no support in wallets for adding attributes to a contract, but the types are as listed below.
 */
enum TransactionAttributeUsage {
    CONTRACT_HASH = 0x00,

    ECDH02 = 0x02,
    ECDH03 = 0x03,

    SCRIPT = 0x20,

    VOTE = 0x30,

    DESCRIPTION_URL = 0x81,
    DESCRIPTION = 0x90,

    HASH1 = 0xa1,
    HASH2 = 0xa2,
    HASH3 = 0xa3,
    HASH4 = 0xa4,
    HASH5 = 0xa5,
    HASH6 = 0xa6,
    HASH7 = 0xa7,
    HASH8 = 0xa8,
    HASH9 = 0xa9,
    HASH10 = 0xaa,
    HASH11 = 0xab,
    HASH12 = 0xac,
    HASH13 = 0xad,
    HASH14 = 0xae,
    HASH15 = 0xaf,

    REMARK = 0xf0,
    REMARK1 = 0xf1,
    REMARK2 = 0xf2,
    REMARK3 = 0xf3,
    REMARK4 = 0xf4,
    REMARK5 = 0xf5,
    REMARK6 = 0xf6,
    REMARK7 = 0xf7,
    REMARK8 = 0xf8,
    REMARK9 = 0xf9,
    REMARK10 = 0xfa,
    REMARK11 = 0xfb,
    REMARK12 = 0xfc,
    REMARK13 = 0xfd,
    REMARK14 = 0xfe,
    REMARK15 = 0xff
};

/** MAX_TX_TEXT_WIDTH in blanks, used for clearing a line of text */
static const char TXT_BLANK[] = "                 ";
static const char ONT_TRANSFER[] = "ONT Transfer: ";
static const char ONG_TRANSFER[] = "ONG Transfer: ";
static const char ONG_CLAIM[] = "ONG Claim: ";
/** #### Asset IDs #### */
/** currently only ONT and ONG are supported, alll others show up as UNKNOWN */

/** ONT's asset id. */
static const char ONT_ASSET_ID[] = "C56F33FC6ECFCD0C225C4AB356FEE59390AF8560BE0E930FAEBE74A6DAFF7C9B";

/** ONG's asset id. */
static const char ONG_ASSET_ID[] = "602C79718B16E442DE58778E148D0B1084E3B2DFFD5DE6B7B16CEE7969282DE7";

/** #### End Of Asset IDs #### */

/** ONT asset's label. */
static const char TXT_ASSET_ONT[] = "ONT";

/** ONG asset's label. */
static const char TXT_ASSET_ONG[] = "ONG";

/** default asset label.*/
static const char TXT_ASSET_UNKNOWN[] = "UNKNOWN";

/** text to display if an asset's base-10 encoded value is too low to display */
static const char TXT_LOW_VALUE[] = "Low Value";

/** a period, for displaying the decimal point. */
static const char TXT_PERIOD[] = ".";

/** Version label */
static const char TXT_VERSION[] = "Version";

/** Label when displaying the number of claims. */
static const char TXT_CLAIMS[] = "Num Claims";

/** Label when displaying the number of attributes. */
static const char TXT_NUM_ATTR[] = "Num Attr";

/** Label when displaying the number of transaction inputs. */
static const char TXT_NUM_TXIN[] = "Num Tx In";

/** Label when displaying the number of transaction outputs. */
static const char TXT_NUM_TXOUT[] = "Num Tx Out";

/** Label when displaying a Miner transaction */
static const char TX_MINER_NM[] = "Miner Tx";

/** Label when displaying a Issue transaction */
static const char TX_ISSUE_NM[] = "Issue Tx";

/** Label when displaying a Claim transaction */
static const char TX_CLAIM_NM[] = "Claim Tx";

/** Label when displaying a Enroll transaction */
static const char TX_ENROLL_NM[] = "Enroll Tx";

/** Label when displaying a Register transaction */
static const char TX_REGISTER_NM[] = "Register Tx";

/** Label when displaying a Contract transaction */
static const char TX_CONTRACT_NM[] = "Contract Tx";

/** Label when displaying a Publish transaction */
static const char TX_PUBLISH_NM[] = "Publish Tx";

/** Label when displaying a Invoke transaction */
static const char TX_INVOKE_NM[] = "Invoke Tx";

/** Label when a public key has not been set yet */
static const char NO_PUBLIC_KEY_0[] = "No Public Key";
static const char NO_PUBLIC_KEY_1[] = "Requested Yet";

/** array of capital letter hex values */
static const char HEX_CAP[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',};

/** array of base58 aplhabet letters */
static const char BASE_58_ALPHABET[] = {'1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
                                        'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q',
                                        'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g',
                                        'h', 'i', 'j', 'k', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
                                        'w', 'x', 'y', 'z'};

/** array of base10 aplhabet letters */
static const char BASE_10_ALPHABET[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};

/** skips the given number of bytes in the transaction */
static void skip_raw_tx(const unsigned int tx_skip);

/** returns the number of bytes in the next variable byte record, called prior to reading a variable byte record to know how many bytes to read. */
static unsigned char next_raw_tx_varbytes_num();

/** reads a set of bytes into the array pointed to by the arr parameter, reads as many bytes as the length parameter specifies. */
static void next_raw_tx_arr(unsigned char *arr, const unsigned int length);

/** reads the next byte out of the transaction, or throws an error if there are no more bytes left. */
static unsigned char next_raw_tx();

/** returns the minimum of i0 and i1 */
static unsigned int min(const unsigned int i0, const unsigned int i1);

/** reads bytes out of src, converts each byte into two hex characters, and writes the hex characters into dest. Only converts enough characters to fill dest_len. */
static void to_hex(char *dest, const unsigned char *src, const unsigned int dest_len);

/** encodes in_length bytes from in into the given base, using the given alphabet. writes the converted bytes to out, stopping when it converts out_length bytes. */
static unsigned int
encode_base_x(const char *alphabet, const unsigned int alphabet_len, const void *in, const unsigned int in_length,
              char *out,
              const unsigned int out_length);

/** encodes in_length bytes from in into base-10, writes the converted bytes to out, stopping when it converts out_length bytes.  */
static unsigned int
encode_base_10(const void *in, const unsigned int in_length, char *out, const unsigned int out_length) {
    return encode_base_x(BASE_10_ALPHABET, sizeof(BASE_10_ALPHABET), in, in_length, out, out_length);
}

/** encodes in_length bytes from in into base-58, writes the converted bytes to out, stopping when it converts out_length bytes.  */
static unsigned int encode_base_58(const void *in, const unsigned int in_len, char *out, const unsigned int out_len) {
    return encode_base_x(BASE_58_ALPHABET, sizeof(BASE_58_ALPHABET), in, in_len, out, out_len);
}

/** encodes in_length bytes from in into the given base, using the given alphabet. writes the converted bytes to out, stopping when it converts out_length bytes. */
static unsigned int
encode_base_x(const char *alphabet, const unsigned int alphabet_len, const void *in, const unsigned int in_length,
              char *out,
              const unsigned int out_length) {
    char tmp[64];
    char buffer[128];
    unsigned char buffer_ix;
    unsigned char startAt;
    unsigned char zeroCount = 0;
    if (in_length > sizeof(tmp)) {
        hashTainted = 1;
        THROW(0x6D11);
    }
    os_memmove(tmp, in, in_length);
    while ((zeroCount < in_length) && (tmp[zeroCount] == 0)) {
        ++zeroCount;
    }
    buffer_ix = 2 * in_length;
    if (buffer_ix > sizeof(buffer)) {
        hashTainted = 1;
        THROW(0x6D12);
    }

    startAt = zeroCount;
    while (startAt < in_length) {
        unsigned short remainder = 0;
        unsigned char divLoop;
        for (divLoop = startAt; divLoop < in_length; divLoop++) {
            unsigned short digit256 = (unsigned short) (tmp[divLoop] & 0xff);
            unsigned short tmpDiv = remainder * 256 + digit256;
            tmp[divLoop] = (unsigned char) (tmpDiv / alphabet_len);
            remainder = (tmpDiv % alphabet_len);
        }
        if (tmp[startAt] == 0) {
            ++startAt;
        }
        buffer[--buffer_ix] = *(alphabet + remainder);
    }
    while ((buffer_ix < (2 * in_length)) && (buffer[buffer_ix] == *(alphabet + 0))) {
        ++buffer_ix;
    }
    while (zeroCount-- > 0) {
        buffer[--buffer_ix] = *(alphabet + 0);
    }
    const unsigned int true_out_length = (2 * in_length) - buffer_ix;
    if (true_out_length > out_length) {
        THROW(0x6D14);
    }
    os_memmove(out, (buffer + buffer_ix), true_out_length);
    return true_out_length;
}

/** converts a value to base10 with a decimal point at DECIMAL_PLACE_OFFSET, which should be 100,000,000 or 100 million, thus the suffix 100m */
static void to_base10_100m(char *dest, const unsigned char *value, const unsigned int dest_len) {
    // reverse the array
    unsigned char reverse_value[VALUE_LEN];
    for (int ix = 0; ix < VALUE_LEN; ix++) {
        reverse_value[ix] = *(value + ((VALUE_LEN - 1) - ix));
    }

    // encode in base10
    char base10_buffer[MAX_TX_TEXT_WIDTH];
    unsigned int buffer_len = encode_base_10(reverse_value, VALUE_LEN, base10_buffer, MAX_TX_TEXT_WIDTH);

    // place the decimal place.
    unsigned int dec_place_ix = buffer_len - DECIMAL_PLACE_OFFSET;
    if (buffer_len < DECIMAL_PLACE_OFFSET) {
        os_memmove(dest, TXT_LOW_VALUE, sizeof(TXT_LOW_VALUE));
    } else {
        os_memmove(dest + dec_place_ix, TXT_PERIOD, sizeof(TXT_PERIOD));
        os_memmove(dest, base10_buffer, dec_place_ix);
        os_memmove(dest + dec_place_ix + 1, base10_buffer + dec_place_ix, buffer_len - dec_place_ix);
    }
}

/** converts a ONT scripthas to a ONT address by adding a checksum and encoding in base58 */
static void to_address(char *dest, unsigned int dest_len, const unsigned char *script_hash) {
    static cx_sha256_t address_hash;
    unsigned char address_hash_result_0[SHA256_HASH_LEN];
    unsigned char address_hash_result_1[SHA256_HASH_LEN];

    // concatenate the ADDRESS_VERSION and the address.
    unsigned char address[ADDRESS_LEN];
    address[0] = ADDRESS_VERSION;
    os_memmove(address + 1, script_hash, SCRIPT_HASH_LEN);

    // do a sha256 hash of the address twice.
    cx_sha256_init(&address_hash);
    cx_hash(&address_hash.header, CX_LAST, address, SCRIPT_HASH_LEN + 1, address_hash_result_0, 32);
    cx_sha256_init(&address_hash);
    cx_hash(&address_hash.header, CX_LAST, address_hash_result_0, SHA256_HASH_LEN, address_hash_result_1, 32);

    // add the first bytes of the hash as a checksum at the end of the address.
    os_memmove(address + 1 + SCRIPT_HASH_LEN, address_hash_result_1, SCRIPT_HASH_CHECKSUM_LEN);

    // encode the version + address + checksum in base58
    encode_base_58(address, ADDRESS_LEN, dest, dest_len);
}

/** converts a byte array in src to a hex array in dest, using only dest_len bytes of dest before stopping. */
static void to_hex(char *dest, const unsigned char *src, const unsigned int dest_len) {
    for (unsigned int src_ix = 0, dest_ix = 0; dest_ix < dest_len; src_ix++, dest_ix += 2) {
        unsigned char src_c = *(src + src_ix);
        unsigned char nibble0 = (src_c >> 4) & 0xF;
        unsigned char nibble1 = src_c & 0xF;

        *(dest + dest_ix + 0) = HEX_CAP[nibble0];
        *(dest + dest_ix + 1) = HEX_CAP[nibble1];
    }
}

/** returns true if the byte array in asset_id matches the hex in asset_id_hex. */
static bool is_asset_id(const unsigned char *asset_id, const char *asset_id_hex) {
    for (int asset_id_ix = ASSET_ID_LEN - 1, asset_id_hex_ix = 0;
         asset_id_ix >= 0; asset_id_ix--, asset_id_hex_ix += 2) {
        unsigned char asset_id_c = *(asset_id + asset_id_ix);
        unsigned char nibble0 = (asset_id_c >> 4) & 0xF;
        unsigned char nibble1 = asset_id_c & 0xF;

        if (*(asset_id_hex + asset_id_hex_ix + 0) != HEX_CAP[nibble0]) {
            return false;
        }
        if (*(asset_id_hex + asset_id_hex_ix + 1) != HEX_CAP[nibble1]) {
            return false;
        }
    }
    return true;
}

/** returns the minimum of two ints. */
static unsigned int min(unsigned int i0, unsigned int i1) {
    if (i0 < i1) {
        return i0;
    } else {
        return i1;
    }
}

/** skips the given number of bytes in the raw_tx buffer. If this goes off the end of the buffer, throw an error. */
static void skip_raw_tx(unsigned int tx_skip) {
    raw_tx_ix += tx_skip;
    if (raw_tx_ix >= raw_tx_len) {
        hashTainted = 1;
        THROW(0x6D03);
    }
}

/** returns the number of bytes to read for the next varbytes array.
 *  Currently throws an error if the encoded value should be over 253,
 *   which should never happen in this use case of a varbyte array
 */
static unsigned char next_raw_tx_varbytes_num() {
    unsigned char num = next_raw_tx();
    switch (num) {
        case 0xFD:
        case 0xFE:
        case 0xFF:
            hashTainted = 1;
            THROW(0x6D04);
            break;
        default:
            break;
    }
    return num;
}

/** fills the array in arr with the given number of bytes from raw_tx. */
static void next_raw_tx_arr(unsigned char *arr, unsigned int length) {
    for (unsigned int ix = 0; ix < length; ix++) {
        *(arr + ix) = next_raw_tx();
    }
}

/** returns the next byte in raw_tx and increments raw_tx_ix. If this would increment raw_tx_ix over the end of the buffer, throw an error. */
static unsigned char next_raw_tx() {
    if (raw_tx_ix < raw_tx_len) {
        unsigned char retval = raw_tx[raw_tx_ix];
        raw_tx_ix += 1;
        return retval;
    } else {
        hashTainted = 1;
        THROW(0x6D05);
        return 0;
    }
}


void display_tx_desc() 
{
    char amount_buf[MAX_TX_TEXT_WIDTH];
    os_memmove(curr_tx_desc[0], TXT_BLANK, sizeof(TXT_BLANK));
    os_memmove(curr_tx_desc[1], TXT_BLANK, sizeof(TXT_BLANK));
    os_memmove(curr_tx_desc[2], TXT_BLANK, sizeof(TXT_BLANK));
    os_memmove(curr_tx_desc[3], TXT_BLANK, sizeof(TXT_BLANK));
    os_memmove(curr_tx_desc[4], TXT_BLANK, sizeof(TXT_BLANK));

    to_hex(amount_buf, &raw_tx[94], 18);

    char amountChar[MAX_TX_TEXT_WIDTH];
    char is_claim=0;

    // numbers < 16, ont or ong transfer
    if (amount_buf[0] == '5') 
    {
        if (amount_buf[1] >= 'A') 
        {
            amountChar[0] = '1';
            amountChar[1] = amount_buf[1] - 'A' + '0';
            os_memmove(curr_tx_desc[1], amountChar, 2);
        } 
        else 
        {
            amountChar[0] = amount_buf[1];
            os_memmove(curr_tx_desc[1], amountChar, 1);
        }
        if(raw_tx[94 + 36] == 0x02){
        	strcpy(curr_tx_desc[0], ONG_TRANSFER);
        } else if(raw_tx[94 + 36] == 0x01){
        	strcpy(curr_tx_desc[0], ONT_TRANSFER);
        }
    }
    // Numbers >= 16: first byte indicates length of amount (LE encoded)
    else if (amount_buf[1] == '8' || (amount_buf[0] == '1' && amount_buf[1] == '4')) 
    {
        // if 0x14, it's a claim transaction
        if (amount_buf[0] == '1' && amount_buf[1] == '4') 
        {
            is_claim = 1;
            to_hex(amount_buf, &raw_tx[94 + 24], 18);
            if(amount_buf[0] == '5'){ //1-15,byte to long
                unsigned char tmp = amount_buf[1];
                strcpy(amount_buf, "080000000000000000");
                amount_buf[3] = tmp;
            }
        }
        for (int i = 0; i < 16; i = i + 2) 
        {
            amountChar[i] = amount_buf[2 + 16 - i - 2];
            amountChar[i + 1] = amount_buf[2 + 16 - i - 1];
        }

        long long amount = 0; //fix ong display bug
        for (int i = 0; i < 16; i = i + 2) 
        {
            long long  high = '0';
            long long  low = '0';

            high = amountChar[i] >= 'A' ? amountChar[i] - 'A' + 10 : amountChar[i] - '0';
            low = amountChar[i + 1] >= 'A' ? amountChar[i + 1] - 'A' + 10 : amountChar[i + 1] - '0';
            amount += (high * 16 + low) << ((7 - i / 2) * 8);
        }
        amountChar[15] = amount % 10 + '0';
        amount = amount / 10;
        int index = 0;

        for (int i = 14; i >= 0; i--) 
        {
            if (amount < 10) 
            {
                amountChar[i] = amount + '0';
                amount = amount / 10;
                index = i;
                break;
            }
            amountChar[i] = amount % 10 + '0';
            amount = amount / 10;
        }
        if( (amount_buf[1] == '8' && raw_tx[94 + 44] == 0x02) || is_claim == 1) {  //transfer ong or claim
            if(index < 7 && index > 0){
                for(int i = index; i < 7;i++){
                        amountChar[i - 1] = amountChar[i];
                }
                amountChar[6] = '.';
                index = index - 1;
            }else if(index == 0){// do nothing

            }else if(index == 7){
                amountChar[5] = '0';
                amountChar[6] = '.';
                index = index - 2;
            }else{
                for(int i = 7; i < index;i++){
                    amountChar[i] = '0';
                }
                amountChar[5] = '0';
                amountChar[6] = '.';
                index = 5;
           }	
	    }
	    if(is_claim == 1){
	        strcpy(curr_tx_desc[0], ONG_CLAIM);
	    }else if(raw_tx[94 + 44] == 0x02){
	        strcpy(curr_tx_desc[0], ONG_TRANSFER);
	    } else if(raw_tx[94 + 44] == 0x01){
	        strcpy(curr_tx_desc[0], ONT_TRANSFER);
	    }
        os_memmove(curr_tx_desc[1], &amountChar[index], 16 - index);
    } 


    unsigned char script_hash_buf[SCRIPT_HASH_LEN * 2];
    if(is_claim == 1){
        to_hex(script_hash_buf, &raw_tx[95], SCRIPT_HASH_LEN * 2);
    }else{
        to_hex(script_hash_buf, &raw_tx[71], SCRIPT_HASH_LEN * 2);
    }
    unsigned char script_hash[SCRIPT_HASH_LEN];

    for (int i = 0; i < SCRIPT_HASH_LEN; i++) {
        unsigned char high = '0';
        unsigned char low = '0';
        high = script_hash_buf[i * 2] >= 'A' ? script_hash_buf[i * 2] - 'A' + 10 : script_hash_buf[i * 2] - '0';
        low = script_hash_buf[i * 2 + 1] >= 'A' ? script_hash_buf[i * 2 + 1] - 'A' + 10 : script_hash_buf[i * 2 + 1] -
                                                                                          '0';
        script_hash[i] = high * 16 + low;
    }
    char address_base58[ADDRESS_BASE58_LEN];
    unsigned int address_base58_len_0 = 11;
    unsigned int address_base58_len_1 = 11;
    unsigned int address_base58_len_2 = 12;
    char *address_base58_0 = address_base58;
    char *address_base58_1 = address_base58 + address_base58_len_0;
    char *address_base58_2 = address_base58 + address_base58_len_0 + address_base58_len_1;
    to_address(address_base58, ADDRESS_BASE58_LEN, script_hash);

    os_memmove(curr_tx_desc[2], address_base58_0, address_base58_len_0);
    os_memmove(curr_tx_desc[3], address_base58_1, address_base58_len_1);
    os_memmove(curr_tx_desc[4], address_base58_2, address_base58_len_2);


}


void display_no_public_key() {
    os_memmove(current_public_key[0], TXT_BLANK, sizeof(TXT_BLANK));
    os_memmove(current_public_key[1], TXT_BLANK, sizeof(TXT_BLANK));
    os_memmove(current_public_key[2], TXT_BLANK, sizeof(TXT_BLANK));
    os_memmove(current_public_key[0], NO_PUBLIC_KEY_0, sizeof(NO_PUBLIC_KEY_0));
    os_memmove(current_public_key[1], NO_PUBLIC_KEY_1, sizeof(NO_PUBLIC_KEY_1));
    publicKeyNeedsRefresh = 0;
}

void public_key_hash160(unsigned char *in, unsigned short inlen, unsigned char *out) {
    union {
        cx_sha256_t shasha;
        cx_ripemd160_t riprip;
    } u;
    unsigned char buffer[32];

    cx_sha256_init(&u.shasha);
    cx_hash(&u.shasha.header, CX_LAST, in, inlen, buffer, 32);
    cx_ripemd160_init(&u.riprip);
    cx_hash(&u.riprip.header, CX_LAST, buffer, 32, out, 20);
}

void display_public_key(const unsigned char *public_key) {
    os_memmove(current_public_key[0], TXT_BLANK, sizeof(TXT_BLANK));
    os_memmove(current_public_key[1], TXT_BLANK, sizeof(TXT_BLANK));
    os_memmove(current_public_key[2], TXT_BLANK, sizeof(TXT_BLANK));

    unsigned char public_key_encoded[33];
    public_key_encoded[0] = ((public_key[64] & 1) ? 0x03 : 0x02);
    os_memmove(public_key_encoded + 1, public_key + 1, 32);

    unsigned char verification_script[35];
    verification_script[0] = 0x21;
    os_memmove(verification_script + 1, public_key_encoded, sizeof(public_key_encoded));
    verification_script[sizeof(verification_script) - 1] = 0xAC;

    unsigned char script_hash[SCRIPT_HASH_LEN];
    for (int i = 0; i < SCRIPT_HASH_LEN; i++) {
        script_hash[i] = 0x00;
    }

    public_key_hash160(verification_script, sizeof(verification_script), script_hash);
    unsigned char script_hash_rev[SCRIPT_HASH_LEN];
    for (int i = 0; i < SCRIPT_HASH_LEN; i++) {
        script_hash_rev[i] = script_hash[SCRIPT_HASH_LEN - (i + 1)];
    }

    char address_base58[ADDRESS_BASE58_LEN];
    unsigned int address_base58_len_0 = 11;
    unsigned int address_base58_len_1 = 11;
    unsigned int address_base58_len_2 = 12;
    char *address_base58_0 = address_base58;
    char *address_base58_1 = address_base58 + address_base58_len_0;
    char *address_base58_2 = address_base58 + address_base58_len_0 + address_base58_len_1;
    to_address(address_base58, ADDRESS_BASE58_LEN, script_hash);

    os_memmove(current_public_key[0], address_base58_0, address_base58_len_0);
    os_memmove(current_public_key[1], address_base58_1, address_base58_len_1);
    os_memmove(current_public_key[2], address_base58_2, address_base58_len_2);
}
