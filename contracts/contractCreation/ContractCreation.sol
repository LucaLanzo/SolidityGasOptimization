// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract ContractCreation {
    function deployContract() public {
        CreatedContract cc = new CreatedContract();
    }
}


contract CreatedContract {
    int256 intial = 0;
}