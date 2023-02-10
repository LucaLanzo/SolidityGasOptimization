// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract TransferFundsASM {

    function transferFundsASMTransfer(address payable to) public payable {
        assembly {            
            if iszero(call(0, to, callvalue(), 0, 0, 0, 0)) {
                // throw an error upon failure
                let pos := mload(64)
                returndatacopy(pos, 0, returndatasize())
                revert(pos, returndatasize())
            }

            return(0, 0)      
        }
    }


    function transferFundsASMSend(address payable to) public payable {
        assembly {            
            if iszero(call(0, to, callvalue(), 0, 0, 0, 0)) {
                // revert with custom error if returned boolean is zero (0x08c379a0 -> function sig Error(string))
                mstore(0x80, 0x08c379a0)
                mstore(0x84, 32)
                mstore(0xA4, 11)
                mstore(0xC4, "Send failed")
            
                revert(0x80, 100)
            }

            return(0, 0)        
        }
    }


    function transferFundsASMCall(address payable to) public payable {
        assembly {
            // as in Solidity, forward all gas
            if iszero(call(gas(), to, callvalue(), 0, 0, 0, 0)) {
                // revert with custom error if returned boolean is zero (0x08c379a0 -> function sig Error(string))
                mstore(0x80, 0x08c379a0)
                mstore(0x84, 32)
                mstore(0xA4, 11)
                mstore(0xC4, "Send failed")
            
                revert(0x80, 100)
            }
            
            return(0, 0)
        }
    }

    // Not part of the bachelor's thesis
    // Just an ingenious and especially safe way to send funds (although not cheap)
    /*
    function transferFundsASMForce(address payable to) public payable {
        assembly {
            mstore(0x00, to)    // Store the address in scratch space.
            mstore8(0x0b, 0x73) // Opcode `PUSH20`.
            mstore8(0x20, 0xff) // Opcode `SELFDESTRUCT`.
            // We can directly use `SELFDESTRUCT` in the contract creation.
            // no check and revert upon failure here
            pop(create(callvalue(), 0x0b, 0x16))
        }
    }


    function erc20TokenTransfer() public {
        
    }
    */
}