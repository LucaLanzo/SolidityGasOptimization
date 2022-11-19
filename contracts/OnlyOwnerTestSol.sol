// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OnlyOwnerTestSol is Ownable {
    event Successful(uint number);

    function ownerTest() public onlyOwner {
        emit Successful(1);
    }
}