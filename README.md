# error codes

any response that doesn not end with `0x9000` is an error.
Some errors are standard errors from the APDU (Application Protocol Data Unit)

http://techmeonline.com/apdu-status-error-codes/

All errors on ONT 1.0 start with 0x6D (because I read the spec wrong).

- `0x6D00` unknown command. (this is to spec, the rest are enoded as 'unknown command' `0x6D` but should be 'unknown parameter' `0x6B`)
- `0x6D01` error, unknown user interface screen, up button was pressed.
- `0x6D02` error, unknown user interface screen, down button was pressed.
- `0x6D03` buffer underflow in transaction parsing while skipping over bytes.
- `0x6D04` variable length byte array decoding error.
- `0x6D05` buffer underflow in transaction parsing while reading bytes.
- `0x6D06` transaction type decoding error.
- `0x6D07` transaction attribute usage type decoding error.
- `0x6D08` signing message too short, bip44 path unreadable.
- `0x6D09` public key message too short, bip44 path unreadable.
- `0x6D10` signed public key message too short, bip44 path unreadable.
- `0x6D11` base_x encoded string is too long for available encoding memory.
- `0x6D12` base_x encoded string is too long for available decoding memory.
- `0x6D14` base_x encoding error.

# blue-app-ont CE

This is the community edition of the Ledger Nano S app for the ONT Cryptocoin.

Run `make load` to build and load the application onto the device.

RUn 'make delete' to delete the application onto the device.

Each transaction should display correctly in the UI.
Use the buttons individually to scroll up and down to view the transaction details.
Either Sign or Deny the transaction by clicking both top buttons on the 'Sign Tx Now', and 'Deny Tx' screens.

See [Ledger's documentation](http://ledger.readthedocs.io) to get started.


