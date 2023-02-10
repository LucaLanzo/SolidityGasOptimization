object "TransferFundsSA" {
    code {
        let ds := datasize("runtime")
        codecopy(0, dataoffset("runtime"), ds)
        return(0, ds)
    }

    object "runtime" {
        code {
            /* ----- dispatcher: calldata to function call ----- */
            switch selector()
                case 0xaa5e7a7f {
                    transferFundsYulTransfer()
                }
                case 0xd1c8cf6d {
                    transferFundsYulSend()
                }
                case 0x99bfdea2 {
                    transferFundsYulCall()
                }
                default {
                    revert(0, 0)
                }


            /* ----- transfer functions ----- */
            function transferFundsYulTransfer() {
                if iszero(call(0, calldataload(0x04), callvalue(), 0, 0, 0, 0)) {
                    // revert with custom error if returned boolean is zero (0x08c379a0 -> function sig Error(string))
                    mstore(0x80, 0x08c379a0)
                    mstore(0x84, 32)
                    mstore(0xA4, 11)
                    mstore(0xC4, "Send failed")
                
                    revert(0x80, 100)
                }

                return(0, 0)      
            }

            function transferFundsYulSend() {
                if iszero(call(0, calldataload(0x04), callvalue(), 0, 0, 0, 0)) {
                    // revert with custom error if returned boolean is zero (0x08c379a0 -> function sig Error(string))
                    mstore(0x80, 0x08c379a0)
                    mstore(0x84, 32)
                    mstore(0xA4, 11)
                    mstore(0xC4, "Send failed")
                
                    revert(0x80, 100)
                }

                return(0, 0)        
            }

            function transferFundsYulCall() {
                // as in Solidity, forward all gas
                if iszero(call(gas(), calldataload(0x04), callvalue(), 0, 0, 0, 0)) {
                    // revert with custom error if returned boolean is zero (0x08c379a0 -> function sig Error(string))
                    mstore(0x80, 0x08c379a0)
                    mstore(0x84, 32)
                    mstore(0xA4, 11)
                    mstore(0xC4, "Send failed")
                
                    revert(0x80, 100)
                }

                return(0, 0)
            }

            
            /* ----- calldata decoding function ----- */
            function selector() -> s {
                // same as shift right 32-4=28 bytes (256 - 32 = 224) -> gets only the first 4 bytes (8 hex chars) for the function signature
                s := div(calldataload(0), 0x100000000000000000000000000000000000000000000000000000000)
            }
        }
    }
}