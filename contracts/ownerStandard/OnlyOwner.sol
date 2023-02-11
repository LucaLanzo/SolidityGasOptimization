// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

contract OnlyOwnerSol is Ownable {
    function ownerTest() public onlyOwner {
    }
}