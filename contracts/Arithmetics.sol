// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "hardhat/console.sol";

contract Arithmetics {

    // ### Addition ###
    function addSol(uint x, uint y) public returns(uint result) {
        result = x + y;
    }

    function addYul(uint x, uint y) public returns(uint) {
        assembly {
            let result := add(x, y)
            mstore(0x80, result)
            return(0x80, 0x100)
        }
    }

    
    // ### Subtraction ###
    function subSol(uint x, uint y) public returns(uint result) {
        result = x - y;
    }

    function subYul(uint x, uint y) public returns(uint) {
        assembly {
            let result := sub(x, y)
            mstore(0x80, result)
            return(0x80, 0x100)
        }
    }


    // ### Multiplication ###
    function mulSol(uint x, uint y) public returns(uint result) {
        result = x * y;
    }

    function mulYul(uint x, uint y) public returns(uint) {
        assembly {
            let result := mul(x, y)
            mstore(0x80, result)
            return(0x80, 0x100)
        }
    }


    // ### Division ###
    function divSol(uint x, uint y) public returns(uint result) {
        result = x / y;
    }

    function divYul(uint x, uint y) public returns(uint) {
        assembly {
            let result := div(x, y)
            mstore(0x80, result)
            return(0x80, 0x100)
        }
    }


    // ### Exponentiation ###
    function expSol(uint x, uint y) public returns(uint result) {
        result = x ** y;
    }

    function expYul(uint x, uint y) public returns(uint) {
        assembly {
            let result := exp(x, y)
            mstore(0x80, result)
            return(0x80, 0x100)
        }
    }
}