// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "hardhat/console.sol";

contract ArithmeticSol {
    event Successful(string methodname);

    // ### Addition ###
    function addSol(uint x, uint y) public {
        uint result = x + y;

        emit Successful("Sol add successful! Result");
    }

    function addYul(uint x, uint y) public {
        assembly {
            let result := add(x, y)
            mstore(0x0, result)
        }

        emit Successful("Yul add successful!");
    }


    // ### Subtraction ###
    function subSol(uint x, uint y) public {
        uint result = x - y;

        emit Successful("Sol sub successful!");
    }

    function subYul(uint x, uint y) public {
        assembly {
            let result := sub(x, y)
            mstore(0x0, result)
        }

        emit Successful("Yul sub successful!");
    }


    // ### Multiplication ###
    function mulSol(uint x, uint y) public {
        uint result = x * y;

        emit Successful("Sol mul successful!");
    }

    function mulYul(uint x, uint y) public {
        assembly {
            let result := mul(x, y)
            mstore(0x0, result)
        }

        emit Successful("Yul mul successful!");
    }


    // ### Division ###
    function divSol(uint x, uint y) public {
        uint result = x / y;

        emit Successful("Sol div successful!");
    }

    function divYul(uint x, uint y) public {
        assembly {
            let result := div(x, y)
            mstore(0x0, result)
        }

        emit Successful("Yul div successful!");
    }
}