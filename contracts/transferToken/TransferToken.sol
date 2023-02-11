// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TransferToken {
    string public constant name = "transferToken";
    string public constant symbol = "TFT";
    uint8 public constant decimals = 18;  
    uint256 totalSupply_;

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowances;
    

    constructor(uint256 total) {  
	    totalSupply_ = total;
	    balances[msg.sender] = totalSupply_;
    }


    function totalSupply() public view returns (uint256) {
	    return totalSupply_;
    }
    
    function balanceOf(address owner) public view returns (uint) {
        return balances[owner];
    }
    
    function allowance(address owner, address spender) public view returns (uint) {
        return allowances[owner][spender];
    }

    function approve(address spender, uint value) public returns (bool) {
        allowances[msg.sender][spender] = value;

        return true;
    }

    function transfer(address to, uint value) public returns (bool) {
        require(balances[msg.sender] >= value, "Not enough tokens available!");

        balances[msg.sender] -= value;
        balances[to] += value;

        return true;
    }

    function transferFrom(address from, address to, uint value) public returns (bool) {
        require(balances[from] >= value, "Not enough tokens available!");    
        require(allowances[from][msg.sender] >= value, "Not enough allowance granted!");
    
        balances[from] -= value;
        allowances[from][msg.sender] -= value;
        balances[to] += value;

        return true;
    }
}