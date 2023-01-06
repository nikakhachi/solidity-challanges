// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// From Alchemy University Ethereum Bootcamp Course #6

contract Switch {
    address public owner;
    address public recipient;
    uint public lastActive;

    constructor(address _recipient) payable {
        recipient = _recipient;
        owner = msg.sender;
        lastActive = block.timestamp;
    }

    function withdraw() external {
        require(lastActive + 52 weeks < block.timestamp);
        (bool success, ) = recipient.call{ value: address(this).balance }("");
        require(success, "Failed to Withdraw Funds");
    }

    function ping() external {
        require(owner == msg.sender);
        lastActive = block.timestamp;
    }
}