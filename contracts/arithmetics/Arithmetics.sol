// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "hardhat/console.sol";

contract Arithmetics {

    // ### Addition ###
    function addSol(uint8 x, uint8 y) public returns(uint8 result) {
        result = x + y;
    }

    function addSolUnchecked(uint8 x, uint8 y) public returns(uint8 result) {
        unchecked {
            result = x + y;
        }
    }

    
    // ### Subtraction ###
    function subSol(uint8 x, uint8 y) public returns(uint8 result) {
        result = x - y;
    }

    function subSolUnchecked(uint8 x, uint8 y) public returns(uint8 result) {
        unchecked {
            result = x - y;
        }
    }


    // ### Multiplication ###
    function mulSol(uint8 x, uint8 y) public returns(uint8 result) {
        result = x * y;
    }

    function mulSolUnchecked(uint8 x, uint8 y) public returns(uint8 result) {
        unchecked {
            result = x * y;
        }
    }


    // ### Division ###
    function divSol(uint8 x, uint8 y) public returns(uint8 result) {
        result = x / y;
    }

    function divSolUnchecked(uint8 x, uint8 y) public returns(uint8 result) {
        unchecked {
            result = x / y;
        }
    }


    // ### Exponentiation ###
    function expSol(uint8 x, uint8 y) public returns(uint8 result) {
        result = x ** y;
    }

    function expSolUnchecked(uint8 x, uint8 y) public returns(uint8 result) {
        unchecked {
            result = x ** y;
        }
    }
}