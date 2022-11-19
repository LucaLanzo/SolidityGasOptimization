// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract OnlyOwnerTestYul {
    event Successful(uint number);

    constructor() {
        assembly {
            sstore(0x0, caller())
        }
    }

    function ownerTest() public {
        assembly {
            if iszero(eq(caller(), sload(0x0))) {
                revert(0, 0)
            }
        }

        emit Successful(1);
    }
}