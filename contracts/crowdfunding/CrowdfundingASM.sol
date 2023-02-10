// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract CrowdfundingASM {
    // enums are not supported with Yul, that's why an int128 is used
    // RAISING = 0, RAISED = 1, EXPIRED = 2, REFUNDED = 3, PAID = 4
    // enum ProjectState { RAISING, RAISED, EXPIRED, REFUNDED, PAID }
    
    address payable private creator; // to pay out  
    // changing the enum to an int allows the datatypes to be packed into one 32 byte slot  
    uint128 private amountToRaise;
    uint128 private state;
    uint256 private deadline;
    uint256 private startedAt;

    mapping (address => uint256) public fundings;

    function viewProject() external view returns(
        address _creator,
        uint128 _amountToRaise,
        uint128 _state,
        uint256 _deadline
    ) {
        assembly {
            _creator := sload(0)
            // The state and amount to raise are two 16 byte values packed in the same 32 byte storage slot
            // An AND-mask is needed to clear 128 higher and lower order bits (16 bytes) of the 32 byte value
            let amountAndState := sload(1)
            _amountToRaise := shr(128, amountAndState)
            _state := and(amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            _deadline := sload(2)
        }
    }


    constructor(uint128 _amountToRaise, uint256 _numberOfDaysUntilDeadline) {
        assembly {
            /* --- security checks --- */

            if iszero(_amountToRaise) {
                mstore(0x80, 0x08c379a0)
                mstore(0x84, 32)
                mstore(0xA4, 30)
                mstore(0xC4, "Amount to raise smaller than 0")
            
                revert(0x80, 100)
            }

            /* --- store variables --- */

            sstore(0, caller())
            // Pack the two 128 bit values amount and state in one 256 bit (32 byte) storage slot
            // SHL 16 bytes of amountToRaise will leave the right side zeroed which already equals state == 0
            sstore(1, shl(128, _amountToRaise))
            sstore(2, add(timestamp(), mul(_numberOfDaysUntilDeadline, 86400))) // a timestamp is always in seconds
            sstore(3, timestamp())
        }
    }


    //
    //    Method to contribute to a crowdfunding project
    //    Malpractice checks include state checking, caller checks and also a check which avoids double payment
    // 
    function fund() external payable {
        assembly {
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

            // impossible to call local Solidity functions from assembly: checkForExpiration() implemented here
            // a shift of 128 bits (16 bytes) of amountAndState equals the higher bit amount
            let amountAndState := sload(1)
            let amountToRaiseVar := shr(128, amountAndState)
            if and(gt(timestamp(), sload(2)), lt(selfbalance(), amountToRaiseVar)) {
                // if the deadline and the funding goal hasn't been met, set the state to EXPIRED = 2
                // but only if it hasn't been set before!
                if xor(and(amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 2) {
                    // as the project has been expired, set the amountAndState with the new value for the next function
                    amountAndState := add(amountAndState, 2)
                    // no need to sstore this updated value as it will be reverted in the next step anyway
                }
            }

            // if state is not RAISING = 0, revert
            // to get the right 16 byte state, an AND-Mask is applied to the combined 32 byte amountAndState field
            if xor(and(amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0) {
                let fmp := mload(0x40)
                mstore(fmp, 0x08c379a0)
                mstore(add(fmp, 0x04), 32)
                mstore(add(fmp, 0x24), 32)
                mstore(add(fmp, 0x44), "The project is no longer raising")
                revert(fmp, 0x64)
            }

            /* --- funding logic --- */

            // mappings are stored in storage as follows: the location of a mapping value is the result of
            // keccak256(key, slot) meaning that to find the raised amount of a specific funder address the result
            // of keccak256(0x12345, fundings.slot) yields the slot where the amount is saved
            mstore(0x00, funder)
            mstore(0x20, 4)
            let helper := keccak256(0x00, 0x40)

            // to store a new value, the same hash is computed, which will either point to previous fundings or a 0 
            // value if the caller has never funded before. Either way, the callvalue (= ether sent) needs to be added
            // to the old value at that location
            sstore(helper, add(sload(helper), callvalue()))

            /* --- post fund state checking --- */

            helper := selfbalance() // reuse old variables to save gas

            // as there is no greater than equal, 1 has to be subtracted from the amount
            // it turns "balance >= amount" to "balance > amount-1", which in turn saves multiple opcodes of or(gt(...), eq(...))
            if gt(helper, sub(amountToRaiseVar, 1)) {
                // if the goal has been met, set the state to RAISED = 1
                sstore(1, add(amountAndState, 1))
            }
        }
    }


    // 
    //    Funding goal met before deadline -> the creator can pay out the balance to himself
    //
    function payOut() external {
        assembly {
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
            // xor(amountAndState, 1) == amountAndState != 1
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
        }
    }

    //
    //    Deadline & funding goal not met -> backers can each refund their contributions
    //
    function refund() external {        
        assembly {
            /* --- security checks --- */
            let funder := caller()
            
            // check if the caller has even funded 
            // includes an owner entrancy prevention as well, as the owner can not have funded his own project in the first place
            mstore(0x00, funder)
            mstore(0x20, 4)
            let helper := keccak256(0x00, 0x40) // get the slot where the callers fundings are stored
            let individualAmountPaid := sload(helper)

            if iszero(individualAmountPaid) {
                mstore(0x80, 0x08c379a0)
                mstore(0x84, 32)
                mstore(0xA4, 32)
                mstore(0xC4, "Can't pay out you haven't funded")
            
                revert(0x80, 100)
            }

            // check for expiration
            let amountAndState := sload(1)
            if and(gt(timestamp(), sload(2)), lt(selfbalance(), shr(128, amountAndState))) {
                // if the deadline and the funding goal hasn't been met, set the state to EXPIRED = 2
                // but only if it hasn't been set before!
                if xor(and(amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 2) {
                    // as the project has been expired, set the amountAndState with the new value for the next function
                    amountAndState := add(amountAndState, 2)
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

            if iszero(call(0, funder, individualAmountPaid, 0, 0, 0, 0)) {
                // revert if the transaction failed
                sstore(helper, individualAmountPaid)
            }

            if iszero(selfbalance()) {
                // if all the funds have been refunded, set the state to REFUNDED = 3
                sstore(1, add(amountAndState, 1))
            }
        }
    }
}
