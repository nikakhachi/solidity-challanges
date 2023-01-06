// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// From Alchemy University Ethereum Bootcamp Course #6

contract Party {
    uint depositAmount;

	constructor(uint256 amount){
        depositAmount = amount;
    }

    address[] public members;
    mapping (address => bool) public hasPaid;

    function rsvp() external payable {
        require(msg.value == depositAmount);
        require(!hasPaid[msg.sender]);
        hasPaid[msg.sender] = true;
        members.push(msg.sender);
    }

    function payBill(address _venue, uint _totalCost) external {
        (bool success1,) = _venue.call{ value: _totalCost }("");
        require(success1, "Failed to Pay The Bill");
        uint remainingFunds = address(this).balance;
        for(uint i; i < members.length; i++){
            (bool success,) = members[i].call{ value: remainingFunds / members.length }("");
            require(success, "Failed to Distribute the Remaining Funds");
        }
    }
}