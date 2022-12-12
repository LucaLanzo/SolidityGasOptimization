// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract OnlyOwnerASM {

    constructor() {
        assembly {
            // save the address of the caller of the contract creation, which is the onwer
            sstore(0, caller())
        }
    }

    modifier onlyOwner() {
        assembly {
            if xor(caller(), sload(0)) {
                // the caller is not the stored owner, revert if eq() != 1
                revert(0, 0)
            }
        }
        _;
    }
    
    function ownerTest() public onlyOwner {
        
    }
}