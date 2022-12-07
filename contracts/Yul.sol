// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract Yul {
    string public text;

    function test(string calldata) public {
        assembly {
            // calldataload(4) loads the first 32 bytes in the call data which holds the offset (e.g. 0x60)
            // to get to the start of the string, get the offset address at calldataload(4) and add 4 (signature skip)
            let startOfString := add(4, calldataload(4))

            // now let's get actually get the content of calldataload(4)+4 i.e. the length of the string
            let length := calldataload(startOfString)

            
        }
    }
}