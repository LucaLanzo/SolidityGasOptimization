object "ArithmeticsSA" {
    /* ----- constructor ----- */

    /* ----- contract deployment ----- */
    code {
        // Deploy the contract
        datacopy(0, dataoffset("runtime"), datasize("runtime"))
        return(0, datasize("runtime"))
    }

    object "runtime" {
        code {
            /* ----- dispatcher: calldata to function call ----- */
            switch selector()
                case 0x993d0375 /* add(uint256,uint256) */ {
                    addYul(calldataload(0x04), calldataload(0x24))
                }
                case 0x4017c1e4 {
                    subYul(calldataload(0x04), calldataload(0x24))
                }
                case 0xef84dd44 {
                    mulYul(calldataload(0x04), calldataload(0x24))
                }
                case 0xe4e7f88b {
                    divYul(calldataload(0x04), calldataload(0x24))
                }
                case 0x41f9c19b {
                    expYul(calldataload(0x04), calldataload(0x24))
                }
                default {
                    revert(0, 0)
                }


            /* ----- arithmetic functions ----- */
            function addYul(x, y) {
                mstore(0x80, add(x, y))
                return(0x80, 0x20)
            }

            function subYul(x, y) {
                mstore(0x80, sub(x, y))
                return(0x80, 0x20)
            }

            function mulYul(x, y) {
                mstore(0x80, mul(x, y))
                return(0x80, 0x20)            
            }

            function divYul(x, y) {
                mstore(0x80, div(x, y))
                return(0x80, 0x20)
            }

            function expYul(x, y) {
                mstore(0x80, exp(x, y))
                return(0x80, 0x20)
            }

            
            /* ----- calldata decoding function ----- */
            function selector() -> s {
                // same as shift right 32-4=28 bytes (256 - 32 = 224) -> gets only the first 4 bytes (8 hex chars) for the function signature
                s := div(calldataload(0), 0x100000000000000000000000000000000000000000000000000000000)
            }
        }
    }
  }