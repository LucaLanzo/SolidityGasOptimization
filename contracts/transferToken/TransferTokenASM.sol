// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TransferTokenASM {
    string public constant name = "transferToken";                  // storage slot 0
    string public constant symbol = "TFT";                          // storage slot 1
    uint8 public constant decimals = 18;                            // storage slot 2 
    uint256 totalSupply_;                                           // storage slot 3

    mapping(address => uint256) balances;                           // storage slot 4
    mapping(address => mapping (address => uint256)) allowances;    // storage slot 5
    

    constructor(uint256 total) {        
        assembly {
            sstore(3, total)

            // create hash(address, slot)
            mstore(0x00, caller())
            mstore(0x20, 4) // slot

            // put balance at slot of hash(address, balanceMappingSlot)
            // basically mint as deployer gets everything
            sstore(keccak256(0x00, 0x40), total)
        }
    }


    function totalSupply() public view returns (uint256) {
        assembly {
            // load the totalSupply from storage to memory and return from memory
            mstore(0x00, sload(3))
            return(0x00, 0x20)
        }
    }
    
    function balanceOf(address owner) public view returns (uint) {
        // return balances[owner];

        assembly {
            // save owner and balanceMappingSlot to memory for hash
            mstore(0x00, owner)
            mstore(0x20, 4)
            // overwrite memory with balance
            mstore(0x00, sload(keccak256(0x00, 0x40)))

            return(0x00, 0x20)
        }
    }
    
    function allowance(address owner, address spender) public view returns (uint) {
        // return allowances[owner][spender];

        assembly {
            mstore(0x00, owner)
            mstore(0x20, 5)
            
            let slotForSpender := keccak256(0x00, 0x40)
            mstore(0x00, spender)
            mstore(0x20, slotForSpender)

            // load allowance from slot of owner -> spender
            mstore(0x00, sload(keccak256(0x00, 0x40)))

            return(0x00, 0x20)
        }
    }

    function approve(address spender, uint value) public returns (bool) {
        // allowances[msg.sender][spender] = value;

        // return true;

        assembly {
            let callerVar := caller()
            mstore(0x00, callerVar)
            mstore(0x20, 5)
            
            let slotForSpender := keccak256(0x00, 0x40)
            mstore(0x00, spender)
            mstore(0x20, slotForSpender)

            // load allowance from slot of owner -> spender
            sstore(keccak256(0x00, 0x40), value)

            // store the value in memory for the log function
            mstore(0x00, value)
            log3(0x00, 0x20, 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925, callerVar, spender)
            
            // store the value in memory for the log function
            mstore(0x00, value)
            log3(0x00, 0x20, 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925, callerVar, spender)
                
            mstore(0x00, 1)         // boolean 1
            return(0x00, 0x20)
        }
    }

    function transfer(address to, uint value) public returns (bool) {
        /*
        require(balances[msg.sender] >= value);

        balances[msg.sender] -= value;
        balances[to] += value;

        return true;
        */

        assembly {
            // get balance of caller
            let callerVar := caller()
            mstore(0x00, callerVar)
            mstore(0x20, 4)
            let balanceSlot := keccak256(0x00, 0x40)
            let balanceSender := sload(balanceSlot)

            if gt(value, balanceSender) {
                // not enough tokens to spend
                mstore(0x80, shl(229, 4594637))
                mstore(0x84, 32)
                mstore(0xA4, 28)
                mstore(0xC4, "Not enough tokens available!")
                
                revert(0x80, 100)
            }

            // remove tokens from sender
            sstore(balanceSlot, sub(balanceSender, value))

            // add tokens to receiver
            mstore(0x00, to)
            mstore(0x20, 4)
            balanceSlot := keccak256(0x00, 0x40)
            sstore(balanceSlot, add(sload(balanceSlot), value))
            
            // store the value in memory for the log function
            mstore(0x00, value)
            log3(0x00, 0x20, 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef, callerVar, to)


            mstore(0x00, 1)
            return(0x00, 0x20)
        }
    }

    function transferFrom(address from, address to, uint value) public returns (bool) {
        /*
        require(balances[from] >= value);    
        require(allowances[from][msg.sender] >= value);
    
        balances[from] -= value;
        allowances[from][msg.sender] -= value;
        balances[to] += value;

        return true;
        */
        
        assembly {
            // get balance of 'from', and check if enough tokens
            mstore(0x00, from)
            mstore(0x20, 4)
            let balanceSlot := keccak256(0x00, 0x40) // from balanceSlot
            let balanceSender := sload(balanceSlot)  // from balance

            if gt(value, balanceSender) {
                // not enough tokens to spend
                mstore(0x80, shl(229, 4594637))
                mstore(0x84, 32)
                mstore(0xA4, 28)
                mstore(0xC4, "Not enough tokens available!")
                
                revert(0x80, 100)
            }

            // check if caller has enough allowance from 'from'
            // mstore(0x00, from) <- already done
            mstore(0x20, 5)
            let allowanceSlotFromFrom := keccak256(0x00, 0x40)

            let callerVar := caller()
            mstore(0x00, callerVar)
            mstore(0x20, allowanceSlotFromFrom)
            let allowanceSlotForCaller := keccak256(0x00, 0x40)         // save for later
            let allowanceForCaller := sload(allowanceSlotForCaller)     // save for later

            if gt(value, allowanceForCaller) {
                // allowance granted from 'from' to caller not enough
                mstore(0x80, shl(229, 4594637))
                mstore(0x84, 32)
                mstore(0xA4, 29)
                mstore(0xC4, "Not enough allowance granted!")
                
                revert(0x80, 100)
            }

            // remove tokens from sender
            sstore(balanceSlot, sub(balanceSender, value))              // overflow!

            // remove allowance
            sstore(allowanceSlotForCaller, sub(allowanceForCaller, value))         // overflow!

            // add tokens to receiver
            mstore(0x00, to)
            mstore(0x20, 4)
            balanceSlot := keccak256(0x00, 0x40)
            sstore(balanceSlot, add(sload(balanceSlot), value))         // overflow!

            // store the value in memory for the log function
            mstore(0x00, value)
            log3(0x00, 0x20, 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef, callerVar, to)

            mstore(0x00, 1)
            return(0x00, 0x20)
        }
    }
}