// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "hardhat/console.sol";

contract ArithmeticsASM {

    // ### Addition ###
    function addASM(uint8 x, uint8 y) public returns(uint8) {
        assembly {
            mstore(0x80, add(x, y))
            return(0x80, 0x20)
        }
    }

    
    // ### Subtraction ###
    function subASM(uint8 x, uint8 y) public returns(uint8) {
        assembly {
            mstore(0x80, sub(x, y))
            return(0x80, 0x20)
        }
    }


    // ### Multiplication ###
    function mulASM(uint8 x, uint8 y) public returns(uint8) {
        assembly {
            mstore(0x80, mul(x, y))
            return(0x80, 0x20)
        }
    }


    // ### Division ###
    function divASM(uint8 x, uint8 y) public returns(uint8) {
        assembly {
            mstore(0x80, div(x, y))
            return(0x80, 0x20)
        }
    }


    // ### Exponentiation ###
    function expASM(uint8 x, uint8 y) public returns(uint8) {
        assembly {
            mstore(0x80, exp(x, y))
            return(0x80, 0x20)
        }
    }
}