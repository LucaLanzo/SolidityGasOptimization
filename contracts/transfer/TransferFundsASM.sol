// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract TransferFundsASM {

    function transferFundsASM(address to) public payable {
        assembly {
            if iszero(call(0, to, callvalue(), 0, 0, 0, 0)) {
                revert(0, 0)
            }
        }
    }
}