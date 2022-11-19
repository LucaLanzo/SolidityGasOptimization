// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OnlyOwnerTestSol is Ownable {
    function ownerTest() public onlyOwner {
    }
}