// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract TransferFunds {

    function transferFundsTransfer(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    function transferFundsSend(address payable _to) public payable {
        bool sent = _to.send(msg.value);
        require(sent, "Send failed");
    }

    function transferFundsCall(address payable _to) public payable {
        // call() forwards all gas by default
        (bool sent, ) = _to.call{ value: msg.value }("");
        require(sent, "Send failed");
    }
}