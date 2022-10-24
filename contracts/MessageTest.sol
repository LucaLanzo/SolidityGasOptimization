// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract MessageTest is Ownable {
    string public message;

    constructor() {
        message = "Hello World!";
    }


    function setMessage(string memory _message) public onlyOwner returns(string memory) {
        require(bytes(_message).length > 0);

        // set new message
        message = _message;
        return message;
    }

    
    function getMessage() external view returns (string memory) {
        return message;
    }
}