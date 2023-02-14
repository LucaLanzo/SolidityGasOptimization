object "TransferTokenSA" {
    code {
        {
            // calculate the size of the constructor arguments
            let programSize := datasize("TransferTokenSA")
            let argSize := sub(codesize(), programSize)

            // get a new free memory pointer pointed to after the arguments
            let newFreePtr := add(0x80, and(add(argSize, 31), not(31)))

            // security check -> newFreePtr > 0 or newFreePtr < 128
            if or(gt(newFreePtr, sub(shl(64, 1), 1)), lt(newFreePtr, 0x80)) {
                mstore(0, shl(224, 0x4e487b71)) // Panic(uint256)
                mstore(4, 0x41)
                revert(0, 0x24)
            }

            // store the new free pointer at 0x40 (where the free memory pointer normally points to)
            mstore(0x40, newFreePtr)
            // copy the arguments to memory starting after the unassignable 0x60
            codecopy(0x80, programSize, argSize)

            // if less than one 32 byte arguments are set, revert
            if lt(argSize, 32) {
                revert(0, 0)
            }
            
            // load totalSupply stored at 128 to 160
            let totalSupply := mload(0x80)

            
            // save the arguments to storage
            saveToStorage(totalSupply)
            
            // deploy the contract and save it to memory, but not at 0 like normally
            // but rather at free memory pointer stored at 0x40 which is 0x80 + argumentSize
            let fmp := mload(0x40)
            let datasizeRT := datasize("TransferTokenSAruntime")
            codecopy(fmp, dataoffset("TransferTokenSAruntime"), datasizeRT)
            return(fmp, datasizeRT)
        }

        function saveToStorage(totalSupply) {
            // constructor from ASM
            sstore(0, totalSupply)

            // create hash(address, slot)
            mstore(0x00, caller())
            mstore(0x20, 1) // balanceMappingSlot

            // put balance at slot of hash(address, balanceMappingSlot)
            // basically mint as deployer gets everything
            sstore(keccak256(0x00, 0x40), totalSupply)
        }
    }

    // x string public constant name = "transferToken"; -> returned in view
    // x string public constant symbol = "TFT";         -> returned in view
    // x uint8 public constant decimals = 18;           -> returned in view
    // 0 uint256 totalSupply_;

    // 1 mapping(address => uint256) balances;
    // 2 mapping(address => mapping (address => uint256)) allowances;

    object "TransferTokenSAruntime" {
        code {
            switch shr(224, calldataload(0)) 
                case 0x23b872dd {   /* transferFrom(address,address,uint256) */
                    transferFrom(calldataload(0x04), calldataload(0x24), calldataload(0x44))
                }
                case 0xa9059cbb {   /* transfer(address,uint256) */
                    transfer(calldataload(0x04), calldataload(0x24))
                }
                case 0x095ea7b3 {   /* approve(address,uint256) */
                    approve(calldataload(0x04), calldataload(0x24))
                }
                case 0xdd62ed3e {   /* view: allowance(address,address) */
                    allowance(calldataload(0x04), calldataload(0x24))
                }
                case 0x70a08231 {   /* view: balanceOf(address) */
                    balanceOf(calldataload(0x04))
                }
                case 0x18160ddd {   /* view: totalSupply() */
                    totalSupply()
                }
                case 0x313ce567 {   /* view: decimals() */
                    decimals()
                }
                case 0x95d89b41 {   /* view: symbol() */
                    symbol()
                }
                case 0x06fdde03 {   /* view: name() */
                    name()
                }
                default {
                    revert(0, 0)
                }
            

            function transferFrom(from, to, value) {
                // get balance of 'from', and check if enough tokens
                mstore(0x00, from)
                mstore(0x20, 1)
                let balanceSlot := keccak256(0x00, 0x40) // from balanceSlot
                let balanceSender := sload(balanceSlot)  // from balance

                if gt(value, balanceSender) {
                    // not enough tokens to spend
                    mstore(0x80, shl(229, 4594637))
                    mstore(0x84, 32)
                    mstore(0xA4, 28)
                    mstore(0xC4, "Not enough tokens available!")
                    
                    revert(0x80, 100)
                }

                // check if caller has enough allowance from 'from'
                // mstore(0x00, from) <- already done
                mstore(0x20, 2)
                let allowanceSlotFromFrom := keccak256(0x00, 0x40)

                let callerVar := caller()
                mstore(0x00, callerVar)
                mstore(0x20, allowanceSlotFromFrom)
                let allowanceSlotForCaller := keccak256(0x00, 0x40)         // save for later
                let allowanceForCaller := sload(allowanceSlotForCaller)     // save for later

                if gt(value, allowanceForCaller) {
                    // allowance granted from 'from' to caller not enough
                    mstore(0x80, shl(229, 4594637))
                    mstore(0x84, 32)
                    mstore(0xA4, 29)
                    mstore(0xC4, "Not enough allowance granted!")
                    
                    revert(0x80, 100)
                }

                // remove tokens from sender
                sstore(balanceSlot, sub(balanceSender, value))              // overflow!

                // remove allowance
                sstore(allowanceSlotForCaller, sub(allowanceForCaller, value))         // overflow!

                // add tokens to receiver
                mstore(0x00, to)
                mstore(0x20, 1)
                balanceSlot := keccak256(0x00, 0x40)
                sstore(balanceSlot, add(sload(balanceSlot), value))         // overflow!

                // store the value in memory for the log function
                mstore(0x00, value)
                log3(0x00, 0x20, 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef, callerVar, to)

                mstore(0x00, 1)
                return(0x00, 0x20)
            }

            function transfer(to, value) {
                // get balance of caller
                let callerVar := caller()
                mstore(0x00, callerVar)
                mstore(0x20, 1)
                let balanceSlot := keccak256(0x00, 0x40)
                let balanceSender := sload(balanceSlot)

                if gt(value, balanceSender) {
                    // not enough tokens to spend
                    mstore(0x80, shl(229, 4594637))
                    mstore(0x84, 32)
                    mstore(0xA4, 28)
                    mstore(0xC4, "Not enough tokens available!")
                    
                    revert(0x80, 100)
                }

                // remove tokens from sender
                sstore(balanceSlot, sub(balanceSender, value))

                // add tokens to receiver
                mstore(0x00, to)
                mstore(0x20, 1)
                balanceSlot := keccak256(0x00, 0x40)
                sstore(balanceSlot, add(sload(balanceSlot), value))

                // store the value in memory for the log function
                mstore(0x00, value)
                log3(0x00, 0x20, 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef, callerVar, to)

                mstore(0x00, 1)
                return(0x00, 0x20)
            }

            function approve(spender, value) {
                let callerVar := caller()
                mstore(0x00, callerVar)
                mstore(0x20, 2)
                
                let slotForSpender := keccak256(0x00, 0x40)
                mstore(0x00, spender)
                mstore(0x20, slotForSpender)

                // load allowance from slot of owner -> spender
                sstore(keccak256(0x00, 0x40), value)
                
                // store the value in memory for the log function
                mstore(0x00, value)
                log3(0x00, 0x20, 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925, callerVar, spender)

                mstore(0x00, 1)         // boolean 1
                return(0x00, 0x20)
            }

            function allowance(owner, spender) {
                mstore(0x00, owner)
                mstore(0x20, 2)
                
                let slotForSpender := keccak256(0x00, 0x40)
                mstore(0x00, spender)
                mstore(0x20, slotForSpender)

                // load allowance from slot of owner -> spender
                mstore(0x00, sload(keccak256(0x00, 0x40)))

                return(0x00, 0x20)
            }

            function balanceOf(owner) {
                // save owner and balanceMappingSlot to memory for hash
                mstore(0x00, owner)
                mstore(0x20, 1)
                // overwrite memory with balance
                mstore(0x00, sload(keccak256(0x00, 0x40)))

                return(0x00, 0x20)
            }

            function totalSupply() {
                // load the totalSupply from storage to memory and return from memory
                mstore(0x00, sload(0))
                return(0x00, 0x20)
            }

            function decimals() {
                mstore(0x00, 18)
                return(0x00, 0x20)
            }

            function symbol() {
                mstore(0x80, 32)                // offset (points to 0xC0)
                mstore(0xA0, 3)                 // length
                mstore(0xC0, "TFT")             // string itself
                return(0x80, 0x60)
            }

            function name() {
                mstore(0x80, 32)                // offset (points to 0xC0)
                mstore(0xA0, 13)                // length
                mstore(0xC0, "transferToken")   // string itself
                return(0x80, 0x60)
            }

        }
    }   
}