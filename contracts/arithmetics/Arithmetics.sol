// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "hardhat/console.sol";

contract Arithmetics {

    // ### Addition ###
    function addSol(uint8 x, uint8 y) public returns(uint8 result) {
        result = x + y;
    }

    function addYul(uint8 x, uint8 y) public returns(uint8) {
        assembly {
            mstore(0x80, add(x, y))
            return(0x80, 0x20)
        }
    }

    
    // ### Subtraction ###
    function subSol(uint8 x, uint8 y) public returns(uint8 result) {
        result = x - y;
    }

    function subYul(uint8 x, uint8 y) public returns(uint8) {
        assembly {
            mstore(0x80, sub(x, y))
            return(0x80, 0x20)
        }
    }


    // ### Multiplication ###
    function mulSol(uint8 x, uint8 y) public returns(uint8 result) {
        result = x * y;
    }

    function mulYul(uint8 x, uint8 y) public returns(uint8) {
        assembly {
            mstore(0x80, mul(x, y))
            return(0x80, 0x20)
        }
    }


    // ### Division ###
    function divSol(uint8 x, uint8 y) public returns(uint8 result) {
        result = x / y;
    }

    function divYul(uint8 x, uint8 y) public returns(uint8) {
        assembly {
            mstore(0x80, div(x, y))
            return(0x80, 0x20)
        }
    }


    // ### Exponentiation ###
    function expSol(uint8 x, uint8 y) public returns(uint8 result) {
        result = x ** y;
    }

    function expYul(uint8 x, uint8 y) public returns(uint8) {
        assembly {
            mstore(0x80, exp(x, y))
            return(0x80, 0x20)
        }
    }
}