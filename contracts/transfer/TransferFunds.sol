// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract TransferFunds {

    function transferFundsSol(address payable _to) public payable {
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "Send failed");
    }


    function transferFundsYul(address to) public payable {
        assembly {
            let success := call(gas(), to, callvalue(), 0, 0, 0, 0)
            if iszero(eq(success, 1)) {
                revert(0, 0)
            }
        }
    }
}