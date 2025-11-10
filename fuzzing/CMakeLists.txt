cmake_minimum_required(VERSION 3.10)
project(OntFuzzer VERSION 2.0.0 LANGUAGES C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_COMPILER clang) # Ensure Clang is used

# BOLOS SDK path from environment
set(BOLOS_SDK $ENV{BOLOS_SDK})

# Compile-time definitions
add_compile_definitions(
    IO_HID_EP_LENGTH=64
    HAVE_ECC
    HAVE_HASH
    HAVE_SHA256
    HAVE_RIPEMD160
    HAVE_AES
)

# Include directories
include_directories(
    .
    ../src/lib
    "${BOLOS_SDK}/include"
    "${BOLOS_SDK}/lib_standard_app"
    "${BOLOS_SDK}/target/flex/include"
    "${BOLOS_SDK}/target/stax/include"
    "${BOLOS_SDK}/target/nanox/include"
    "${BOLOS_SDK}/target/nanos2/include"
    "${BOLOS_SDK}/target/nanos/include"
    "${BOLOS_SDK}/target/apex/include"
    "${BOLOS_SDK}/lib_cxng/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../src"
    "${CMAKE_CURRENT_SOURCE_DIR}/../src/transaction"
)

# Optimization and debug flags
add_compile_options(-g -ggdb2 -O3)

# Fuzz source files
set(APP_SRC_DIR "../src")

set(APP_SOURCES
    ${BOLOS_SDK}/lib_standard_app/read.c
    ${BOLOS_SDK}/lib_standard_app/varint.c
    ${BOLOS_SDK}/lib_standard_app/write.c
    ${BOLOS_SDK}/lib_standard_app/bip32.c
    ${BOLOS_SDK}/lib_standard_app/buffer.c
    ${BOLOS_SDK}/lib_standard_app/format.c
    ${BOLOS_SDK}/src/ledger_assert.c
    ${APP_SRC_DIR}/transaction/deserialize.c
    ${APP_SRC_DIR}/transaction/contract.c
    ${APP_SRC_DIR}/transaction/parse.c
    ${APP_SRC_DIR}/transaction/utils.c
    mock_syscalls.c
)

# Fuzzer target
add_executable(fuzz_tx_parser
    ${CMAKE_CURRENT_SOURCE_DIR}/fuzz_tx_parser.c
    ${APP_SOURCES}
)

# Add sanitizer flags
if(NOT DEFINED ENV{CIFUZZ})
    message(STATUS "Local build: enabling -fsanitize=fuzzer,address")
    target_compile_options(fuzz_tx_parser PUBLIC -fsanitize=fuzzer,address)
    target_link_options(fuzz_tx_parser PUBLIC -fsanitize=fuzzer,address)
else()
    message(STATUS "CI fuzzing build: enabling -fsanitize=fuzzer")
    target_compile_options(fuzz_tx_parser PUBLIC -fsanitize=fuzzer)
    target_link_options(fuzz_tx_parser PUBLIC -fsanitize=fuzzer)
endif()

# Include project headers
target_include_directories(fuzz_tx_parser PUBLIC ../src)

# Enable verbose output for debugging
set(CMAKE_VERBOSE_MAKEFILE ON)