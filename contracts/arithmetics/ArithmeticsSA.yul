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
                case 0x616d5b9d /* add(uint256,uint256) */ {
                    addY(calldataload(0x04), calldataload(0x24))
                }
                case 0xb46bc106 {
                    subY(calldataload(0x04), calldataload(0x24))
                }
                case 0x75990598 {
                    mulY(calldataload(0x04), calldataload(0x24))
                }
                case 0x8cfd3f23 {
                    divY(calldataload(0x04), calldataload(0x24))
                }
                case 0x43af3536 {
                    expY(calldataload(0x04), calldataload(0x24))
                }
                default {
                    revert(0, 0)
                }


            /* ----- arithmetic functions ----- */
            function addY(x, y) {
                mstore(0x80, add(x, y))
                return(0x80, 0x20)
            }

            function subY(x, y) {
                mstore(0x80, sub(x, y))
                return(0x80, 0x20)
            }

            function mulY(x, y) {
                mstore(0x80, mul(x, y))
                return(0x80, 0x20)            
            }

            function divY(x, y) {
                mstore(0x80, div(x, y))
                return(0x80, 0x20)
            }

            function expY(x, y) {
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