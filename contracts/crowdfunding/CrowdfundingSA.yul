object "CrowdfundingSA" {
    code {
        /* ----- constructor ----- */
        /* --- security checks --- */
        /*
        ################
        ### REMINDER ###
        ################
        
        calldata is handled on external functions:

            CALLDATA
            offsetFromSig  offset      value
            0x00 (0)       0x04 (4)    offset title = 128
            0x20 (32)      0x24 (36)   offset descr = 192
            0x40 (64)      0x44 (68)   uint128 amountToRaise
            0x60 (96)      0x64 (100)  uint256 numberOfDaysUntilDeadline
            0x80 (128)     0x84 (132)  length title
            0xa0 (160)     0xa4 (164)  title string
            0xc0 (192)     0xc4 (196)  length descr
            0xe0 (224)     0xe4 (228)  descr string
        
        let lengthOfTitle := calldataload(add(4, calldataload(4)))  // cdl(0) + 4 sig
        let lengthOfDescr := calldataload(add(4, calldataload(36))) // cdl(32) + 4 sig
        let title := calldataload(add(add(4, calldataload(4))), 32)
        let descr := calldataload(add(add(4, calldataload(36))), 32)
        let _amountToRaise := calldataload(68)
        let _numberOfDaysUntilDeadline := calldataload(100)

        Whereas memory

            MEMORY
            offsetFromSig  value
            0x00 (0)       scratch
            0x20 (32)      scratch
            0x40 (64)      free memory pointer => value = 0x140 (320)
            0x60 (96)      zero slot for initial values of dynamic memory arrays
            0x80 (128)     length title
            0xa0 (160)     title string
            0xc0 (192)     length descr
            0xe0 (224)     descr string
            0x100 (256)    uint128 amountToRaise
            0x120 (288)    uint256 numberOfDaysUntilDeadline
            0x140 (320)    free memory
            
        */
        
        {
            // revert if any ethereum is sent over in the constructor
            // if callvalue() { revert(0, 0) }
            
            // calculate the size of the constructor arguments and programs
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

            // if amountToRaise = 0
            // if iszero(eq(amountToRaise, and(amountToRaise, sub(shl(128, 1), 1)))) {
            //     revert(0, 0)
            // }
            
            // save the arguments to storage
            constructorCrowdfundingSA(amountToRaise, numberOfDaysUntilDeadline)
            
            // deploy the contract and save it to memory, but not at 0 like normally
            // but rather at free memory pointer stored at 0x40 which is 0x80 + argumentSize
            let fmp := mload(0x40)
            let datasizeRT := datasize("runtime")
            codecopy(fmp, dataoffset("runtime"), datasizeRT)
            return(fmp, datasizeRT)
        }
        
        function constructorCrowdfundingSA(amountToRaise, numberOfDaysUntilDeadline)
        {
            // same as in the inline assembly

            if iszero(amountToRaise)
            {
                mstore(0, 30)
                mstore(0x20, "Amount to raise smaller than 0")
                revert(0, 0x40)
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
                if lt(callvalue(), 1) {
                    mstore(0x00, 24)
                    mstore(0x20, "Specify a funding amount")
                    revert(0x00, 0x40)
                }
                
                let funder := caller()
                if iszero(xor(funder, sload(0))) {
                    mstore(0x00, 27)
                    mstore(0x20, "Project creators can't fund")
                    revert(0x00, 0x40)
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

                // If state is not RAISING = 0
                if iszero(eq(and(amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0)) {
                    mstore(0x00, 32)
                    mstore(0x20, "The project is no longer raising")
                    revert(0x00, 0x40)
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
                    mstore(0x00, 32)
                    mstore(0x20, "Only project creator can pay out")
                    revert(0x00, 0x40)
                }

                let amountAndState := sload(1)
                if iszero(eq(and(amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 1)) {
                    // only pay out if it is in state RAISED = 1
                    mstore(0x00, 29)
                    mstore(0x20, "Not raised or project expired")
                    revert(0x00, 0x40)
                }

                /* --- send funds --- */

                /* --- send funds --- */

                // no reentrancy protection needed as the whole funds are sent anyway
                if iszero(call(0, owner, selfbalance(), 0, 0, 0, 0)) {
                    // revert if the transaction failed
                    mstore(0x00, 29)
                    mstore(0x20, "Can't transfer funds to owner")
                    revert(0x00, 0x40)
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

                if lt(amount, 1) {
                    mstore(0x00, 32) // overwrite previous, now unused value
                    mstore(0x20, "Can't pay out you haven't funded")
                    revert(0x00, 0x40)
                }

                // check for expiration
                let amountAndState := sload(1)
                if and(gt(timestamp(), sload(2)), lt(selfbalance(), shr(128, and(amountAndState, not(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))))) {
                    // if the deadline and the funding goal hasn't been met, set the state to EXPIRED = 2
                    // but only if it hasn't been set before!
                    if iszero(eq(and(amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 2)) {
                        // as the project has been expired, set the amountAndState with the new value for the next function
                        amountAndState := add(amountAndState, 2)
                        // update to storage
                        sstore(1, amountAndState)
                    }
                }

                // If state is not EXPIRED = 2
                if iszero(eq(and(amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 2)) {
                    mstore(0x00, 30)
                    mstore(0x20, "The project hasn't expired yet")
                    revert(0x00, 0x40)
                }

                /* --- send funds, reentrancy prevention and check success --- */
                sstore(helper, 0) // set the funds to zero

                if iszero(call(0, funder, amount, 0, 0, 0, 0)) {
                    // revert if the transaction failed
                    sstore(helper, amount)
                }

                if eq(selfbalance(), 0) {
                    // if all the funds have been refunded, set the state to REFUNDED = 3
                    sstore(1, add(amountAndState, 1))
                }

                return(0, 0)

            }

            function viewProject() { 
            
                let amountAndState := sload(1)

                let fmp := mload(64)
                mstore(fmp, and(sload(0), sub(shl(160, 1), 1)))
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