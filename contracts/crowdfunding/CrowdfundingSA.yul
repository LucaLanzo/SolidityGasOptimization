object "CrowdfundingSA" {
    code {  
        {       
            // calculate the size of the constructor arguments
            let programSize := datasize("CrowdfundingSA")
            let argSize := sub(codesize(), programSize)

            // get a new free memory pointer pointed to after the arguments
            let newFreePtr := add(128, and(add(argSize, 31), not(31)))

            // security check? -> newFreePtr > 0 or newFreePtr < 128
            if or(gt(newFreePtr, sub(shl(64, 1), 1)), lt(newFreePtr, 128)) {
                mstore(0, shl(224, 0x4e487b71))
                mstore(4, 0x41)
                revert(0, 0x24)
            }

            // store the new free pointer at 0x40 (where the free memory pointer normally points to)
            mstore(0x40, newFreePtr)
            // copy the arguments to memory starting after the unassignable 0x60
            codecopy(0x80, programSize, argSize)

            // if less than two 32 byte arguments are set, revert
            if slt(argSize, 64) {
                revert(0, 0)
            }
            
            // load amountToRaise stored at 128 to 160
            let amountToRaise := mload(128)
            // load numberOfDaysUntilDeadline stored at 160 to 192
            let numberOfDaysUntilDeadline := mload(160)

            
            // save the arguments to storage
            saveToStorage(amountToRaise, numberOfDaysUntilDeadline)
            
            // deploy the contract and save it to memory, but not at 0 like normally
            // but rather at free memory pointer stored at 0x40 which is 0x80 + argumentSize
            let fmp := mload(0x40)
            let datasizeRT := datasize("runtime")
            codecopy(fmp, dataoffset("runtime"), datasizeRT)
            return(fmp, datasizeRT)
        }
        
        function saveToStorage(amountToRaise, numberOfDaysUntilDeadline) {
            // same as in the inline assembly
            if iszero(amountToRaise) {
                mstore(0x80, 0x08c379a0)
                mstore(0x84, 32)
                mstore(0xA4, 30)
                mstore(0xC4, "Amount to raise smaller than 0")
            
                revert(0x80, 100)
            }

            sstore(0, caller())
            sstore(1, shl(128, amountToRaise))
            sstore(2, add(timestamp(), mul(numberOfDaysUntilDeadline, 86400)))
            sstore(3, timestamp())
        }
    }

    object "runtime" {
        code {
            /* ----- dispatcher: calldata to function call ----- */
            switch selector()
                case 0xb60d4288 { /* fund() */ fund() }
                case 0xc2052403 { /* payOut() */ payOut() }
                case 0x590e1ae3 { /* refund() */ refund() }
                case 0xca3c23c1 { /* viewProject() */ viewProject() }
                default { revert(0, 0) }


            /* ----- logic functions ----- */
            function fund() {

                /* --- security checks --- */
                if iszero(callvalue()) {
                    mstore(0x80, 0x08c379a0)
                    mstore(0x84, 32)
                    mstore(0xA4, 24)
                    mstore(0xC4, "Specify a funding amount")
                
                    revert(0x80, 100)
                }
                
                let funder := caller()
                if eq(funder, sload(0)) {
                    mstore(0x80, 0x08c379a0)
                    mstore(0x84, 32)
                    mstore(0xA4, 27)
                    mstore(0xC4, "Project creators can't fund")
                
                    revert(0x80, 100)
                }

                // check for expiration()
                let amountAndState := sload(1)
                if and(gt(timestamp(), sload(2)), lt(selfbalance(), shr(128, and(amountAndState, not(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))))) {
                    // if the deadline and the funding goal hasn't been met, set the state to EXPIRED = 2
                    // but only if it hasn't been set before!
                    if iszero(eq(and(amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 2)) {
                        // as the project has been expired, set the amountAndState with the new value for the next function
                        amountAndState := add(amountAndState, 2)
                    }
                }

                // if state is not RAISING = 0, revert
                if xor(and(amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0) {
                    let fmp := mload(0x40)
                    mstore(fmp, 0x08c379a0)
                    mstore(add(fmp, 0x04), 32)
                    mstore(add(fmp, 0x24), 32)
                    mstore(add(fmp, 0x44), "The project is no longer raising")
                    revert(fmp, 0x64)
                }

                /* --- funding logic --- */

                // get the funders previous funds
                mstore(0x00, funder)
                mstore(0x20, 4) // fundings.slot = 4, fixed. Depends on the order of storage variables
                let helper := keccak256(0x00, 0x40)

                // add the new fund to the previous funds
                sstore(helper, add(sload(helper), callvalue()))

                /* --- post fund state checking --- */

                helper := selfbalance() // reuse old variables to save gas
                amountAndState := sload(1)

                // if (balance >= amount) -> no greaterthanequals in Sol -> if (balance > amount-1)
                if gt(helper, sub(shr(128, and(amountAndState, not(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))), 1)) {
                    // if the goal has been met, set the state to RAISED = 1
                    sstore(1, add(amountAndState, 1))
                }

                return(0, 0)
                
            }

            function payOut() {

                /* --- security checks --- */
                let owner := sload(0)
                if xor(caller(), owner) {
                    mstore(0x80, 0x08c379a0)
                    mstore(0x84, 32)
                    mstore(0xA4, 32)
                    mstore(0xC4, "Only project creator can pay out")
                
                    revert(0x80, 100)
                }

                let amountAndState := sload(1)
                if xor(and(amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 1) {
                    // only pay out if it is in state RAISED = 1
                    mstore(0x80, 0x08c379a0)
                    mstore(0x84, 32)
                    mstore(0xA4, 29)
                    mstore(0xC4, "Not raised or project expired")
                
                    revert(0x80, 100)
                }

                /* --- send funds --- */

                // no reentrancy protection needed as the whole funds are sent anyway
                if iszero(call(0, owner, selfbalance(), 0, 0, 0, 0)) {
                    // revert if the transaction failed
                    mstore(0x80, 0x08c379a0)
                    mstore(0x84, 32)
                    mstore(0xA4, 29)
                    mstore(0xC4, "Can't transfer funds to owner")
                
                    revert(0x80, 100)
                }

                /* --- successful transfer --- */
                // if the funds have been paid out, set the state to PAID = 4 (as it is in state 1, adding 3 will suffice)
                sstore(1, add(amountAndState, 3))

                return(0, 0)

            }

            function refund() {

                /* --- security checks --- */
                let funder := caller()
                
                // check if the caller has even funded (includes an owner entrancy prevention as well)
                mstore(0x00, funder)
                mstore(0x20, 4) // fundings.slot = 4, fixed. Depends on the order of storage variables
                let helper := keccak256(0x00, 0x40) // get the slot where the callers fundings are stored
                let amount := sload(helper)

                if iszero(amount) {
                    mstore(0x80, 0x08c379a0)
                    mstore(0x84, 32)
                    mstore(0xA4, 32)
                    mstore(0xC4, "Can't pay out you haven't funded")
                
                    revert(0x80, 100)
                }

                // check for expiration
                let amountAndState := sload(1)
                if and(gt(timestamp(), sload(2)), lt(selfbalance(), shr(128, and(amountAndState, not(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))))) {
                    // if the deadline and the funding goal hasn't been met, set the state to EXPIRED = 2
                    // but only if it hasn't been set before!
                    if xor(and(amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 2) {
                        // as the project has been expired, set the amountAndState with the new value for the next function
                        amountAndState := add(amountAndState, 2)
                        // update to storage
                        sstore(1, amountAndState)
                    }
                }

                // If state is not EXPIRED = 2
                if xor(and(amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 2) {
                    mstore(0x80, 0x08c379a0)
                    mstore(0x84, 32)
                    mstore(0xA4, 30)
                    mstore(0xC4, "The project hasn't expired yet")
                
                    revert(0x80, 100)
                }

                /* --- send funds, reentrancy prevention and check success --- */
                sstore(helper, 0) // set the funds to zero

                if iszero(call(0, funder, amount, 0, 0, 0, 0)) {
                    // revert if the transaction failed
                    sstore(helper, amount)
                }

                if iszero(selfbalance()) {
                    // if all the funds have been refunded, set the state to REFUNDED = 3
                    sstore(1, add(amountAndState, 1))
                }

                return(0, 0)

            }

            function viewProject() { 
            
                let amountAndState := sload(1)

                let fmp := mload(64)
                mstore(fmp, sload(0))
                mstore(add(fmp, 32), shr(128, amountAndState))
                mstore(add(fmp, 64), and(amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
                mstore(add(fmp, 96), sload(2))
                return(fmp, 128)
            
            }

            function fundings() {
                let fmp := mload(0x40)
                
                mstore(0x0, and(calldataload(4), sub(shl(160, 1), 1))) // store the address and the fundings map slot in memory to keccak
                mstore(0x40, 4) // slot 4 is the fundings map

                mstore(fmp, sload(keccak256(0, 0x40))) // keccak(address, fundingsSlot) is the slot where the value is stored
                return(fmp, 0x20)
            }
            
            /* ----- calldata decoding helper function ----- */
            function selector() -> s {
                // same as shift right 32-4=28 bytes (256 - 32 = 224) -> gets only the first 4 bytes (8 hex chars) for the function signature
                s := shr(224, calldataload(0))
            }
        }
    }
  }