// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract Crowdfunding {
    enum ProjectState { RAISING, RAISED, EXPIRED, REFUNDED, PAID }
    
    address payable private creator; // to pay out    
    ProjectState private state;
    uint256 private amountToRaise;
    uint256 private deadline;
    uint256 private startedAt;

    mapping (address => uint) public fundings;

    function viewProject() external view returns(
        address _creator,
        ProjectState _state,
        uint256 _amountToRaise,
        uint256 _deadline
    ) {
        _creator = creator;
        _state = state;
        _amountToRaise = amountToRaise;
        _deadline = deadline;
    }


    constructor(uint256 _amountToRaise, uint256 _numberOfDaysUntilDeadline) {
        require(_amountToRaise > 0, "Amount to raise smaller than 0");

        creator = payable(msg.sender);
        state = ProjectState.RAISING;
        amountToRaise = _amountToRaise;
        deadline = block.timestamp + (_numberOfDaysUntilDeadline * 1 days);
        startedAt = block.timestamp;

        // emit NewProjectStarted(_title, _descr, address(this), msg.sender, _amountToRaise, deadline);
    }


    //
    //    Method to contribute to a crowdfunding project
    //    Malpractice checks include state checking, caller checks and also a check which avoids double payment
    // 
    function fund() external payable {
        require(msg.value > 0, "Specify a funding amount");
        require(msg.sender != creator, "Project creators can't fund");
        
        checkForExpiration();   
        require(state == ProjectState.RAISING, "The project is no longer raising");

        // fund
        fundings[msg.sender] += msg.value;

        // emit NewFunding(msg.sender, msg.value, address(this).balance);

        if(address(this).balance >= amountToRaise) {
            state = ProjectState.RAISED;
        }
    }


    // 
    //    Funding goal met before deadline -> the creator can pay out the balance to himself
    //
    function payOut() external {
       	require(msg.sender == creator, "Only project creator can pay out");
        require(state == ProjectState.RAISED, "Not raised or project expired");     

        // no reentrancy protection needed as the whole funds are sent anyway
        (bool sent, ) = creator.call{value: address(this).balance}("");

        if (sent) {
            state = ProjectState.PAID;
        }
    }

    //
    //    Deadline & funding goal not met -> backers can each refund their contributions
    //
    function refund() external {        
        // only funders can pay out (prevents payout to creator as well)
        require(fundings[msg.sender] > 0, "Can't pay out you haven't funded");

        // check if the project has expired
        checkForExpiration();
        require(state == ProjectState.EXPIRED, "The project hasn't expired");

        uint _amountToRefund = fundings[msg.sender];
        fundings[msg.sender] = 0;

        bool transactionSuccessful = payable(msg.sender).send(_amountToRefund);

        if (!transactionSuccessful) {
            // revert
            fundings[msg.sender] = _amountToRefund;
        }

        if (address(this).balance == 0) {
            state = ProjectState.REFUNDED;
        }
    }

    
    //    Checks if project has reached its deadline and amount hasn't been met
    //    @return boolean, true if project ended, false if project still ongoing
    function checkForExpiration() public {
        if (block.timestamp > deadline && address(this).balance < amountToRaise) {
            state = ProjectState.EXPIRED;
        }
    }
}
