// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract OnlyOwnerTestYul {

    constructor() {
        assembly {
            sstore(0, caller())
        }
    }

    function ownerTest() public {
        assembly {
            if iszero(eq(caller(), sload(0))) {
                revert(0, 0)
            }
        }
    }
}