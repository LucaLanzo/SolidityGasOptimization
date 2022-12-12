// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract TransferFunds {

    function transferFunds(address payable _to) public payable {
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "Send failed");
    }
}