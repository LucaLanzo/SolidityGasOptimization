// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract Yul {
    bytes32 public changeableMessage = "Hello";
    int256 public changeableNumber = 0;

    event Message(string _message);


    function change() public {
        
        assembly {
            let yulText := "This is my text"
            let yulNumber := 1

            sstore(changeableMessage.slot, yulText)
            sstore(changeableNumber.slot, yulNumber)
        }
    }


    function getMessage() public view returns(bytes32) {
        return changeableMessage;
    }

    function getNumber() public view returns(int256) {
        return changeableNumber;
    }
}