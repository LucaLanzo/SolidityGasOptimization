object "CrowdfundingSA" {
    code {
        /* ----- constructor ----- */
        /* --- security checks --- */
        /*
        This is how calldata is handled on external functions:

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


        But in constructors, all parameters are put into memory and then it looks like the following:

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
        
        let _amountToRaise := mload(0x100) // wrong
        // let _numberOfDaysUntilDeadline := mload(0x120) // wrong
        
        if iszero(gt(_amountToRaise, 0)) {
            mstore(0x00, 30)
            mstore(0x20, "Amount to raise smaller than 0")
            revert(0x00, 0x40)
        }


        /* --- store variables --- */ 
        
        sstore(0, caller())
        // packing of uint128 amountToRaise and uint128 state = default 0
        sstore(1, shl(128, _amountToRaise))
        sstore(2, add(timestamp(), mul(mload(0x120), 86400))) // a timestamp is always in seconds
        sstore(3, timestamp())
        // mappings = fixed at slot 4

        /* --- emit event --- */
        // Keccak256: NewProjectStarted(string,string,address,address,uint128,uint256)
        // let signatureHash := 0x99d6a8696589d8d6e9a6ca721dffbe3aa9b2e8664eadfe8b8105f69d467d264e
        // log1(_title, 0x40, signatureHash)
        

        /* --- contract deployment --- */
        datacopy(0, dataoffset("runtime"), datasize("runtime"))
        return(0, datasize("runtime"))
    }

    object "runtime" {
        code {
            /* ----- dispatcher: calldata to function call ----- */
            switch selector()
                case 0xb60d4288 { /* fund() */ 
                    fund()
                }
                case 0xc2052403 { /* payOut() */
                    payOut()
                }
                case 0x590e1ae3 { /* refund() */
                    refund()
                }
                case 0xca3c23c1 { /* viewProject() */
                    let _creator, _amountToRaise, _state, _deadline := viewProject()
                    let fmp := mload(0x40)
                    mstore(fmp, _creator)
                    mstore(add(fmp, 0x20), _amountToRaise)
                    mstore(add(fmp, 0x40), _state)
                    mstore(add(fmp, 0x60), _deadline)

                    return(fmp, 0x20)
                }
                default {
                    revert(0, 0)
                }


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
                if and(gt(timestamp(), sload(2)), lt(balance(address()), shr(128, and(amountAndState, not(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))))) {
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

                /* --- emit event --- */

                // ?

                /* --- post fund state checking --- */

                helper := balance(address()) // reuse old variables to save gas
                amountAndState := sload(1)

                // if (balance >= amount) -> no greaterthanequals in Sol -> if (balance > amount-1)
                if gt(helper, sub(shr(128, and(amountAndState, not(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))), 1)) {
                    // if the goal has been met, set the state to RAISED = 1
                    sstore(1, add(amountAndState, 1))
                }
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

                // no reentrancy protection needed as the whole funds are sent anyway
                let success := call(gas(), owner, balance(address()), 0, 0, 0, 0)

                /* --- check success --- */
                switch eq(success, 1)
                case 1 {
                    // if the funds have been paid out, set the state to PAID = 4 (as it is in state 1, adding 3 will suffice)
                    sstore(1, and(amountAndState, 3))

                    /* --- emit event --- */

                    // ?
                }
                default {
                    mstore(0x00, 29)
                    mstore(0x20, "Can't transfer funds to owner")
                    revert(0x00, 0x40)
                }
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
                if and(gt(timestamp(), sload(2)), lt(balance(address()), shr(128, and(amountAndState, not(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))))) {
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

                /* --- send funds and reentrancy prevention --- */
                sstore(helper, 0) // set the funds to zero
                let success := call(gas(), funder, amount, 0, 0, 0, 0)
                
                /* --- check success --- */
                if iszero(eq(success, 1)) {
                    // revert if the transaction failed
                    sstore(helper, amount)
                }

                if eq(balance(address()), 0) {
                    // if all the funds have been refunded, set the state to REFUNDED = 3
                    sstore(1, add(amountAndState, 1))
                }
            }

            function viewProject() -> _creator, _amountToRaise, _state, _deadline {
                _creator := sload(0)
                let amountAndState := sload(1)
                _amountToRaise := shr(128, and(amountAndState, not(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)))
                _state := and(amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
                _deadline := sload(2)
            }
            
            /* ----- calldata decoding helper function ----- */
            function selector() -> s {
                // same as shift right 32-4=28 bytes (256 - 32 = 224) -> gets only the first 4 bytes (8 hex chars) for the function signature
                s := shr(28, calldataload(0))
            }
        }
    }
  }