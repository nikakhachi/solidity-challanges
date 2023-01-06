// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// From Alchemy University Ethereum Bootcamp Course #6

contract MultiSig {
    uint public transactionCount;

    address[] public owners;
    uint256 public required;

    constructor(address[] memory _addresses, uint256 _required){
        require(_addresses.length > 0);
        require(_required != 0);
        require(_addresses.length >= _required);
        owners = _addresses;
        required = _required;
    }

    function isOwner(address addr) private view returns(bool) {
        for(uint i = 0; i < owners.length; i++) {
            if(owners[i] == addr) {
                return true;
            }
        }
        return false;
    }

    struct Transaction {
        address payable destination;
        uint256 value;
        bool executed;
        bytes data;
    }

    Transaction[] public transactions;
    mapping (uint => mapping(address => bool)) public confirmations;

    function addTransaction(address _destination, uint256 _value, bytes memory data) internal returns(uint) {
        transactions.push(Transaction(payable(_destination), _value, false, data));
        transactionCount++;
        return transactions.length - 1;
    }

    function confirmTransaction(uint transactionId) public {
        require(isOwner(msg.sender));
        confirmations[transactionId][msg.sender] = true;
        if(isConfirmed(transactionId)){
            executeTransaction(transactionId);
        }
    }

    function getConfirmationsCount(uint _transactionId) public view returns (uint256) {
        uint count;
        for(uint i = 0; i < owners.length; i++){
            if(confirmations[_transactionId][owners[i]] == true){
                count++;
            }
        }
        return count;
    }

    function submitTransaction(address payable _destination, uint _value, bytes memory data) external {
        uint transactionId = addTransaction(_destination, _value, data);
        confirmTransaction(transactionId);
    }

    receive() external payable {}

    function isConfirmed(uint _transactionId) public view returns (bool) {
        return getConfirmationsCount(_transactionId) >= required;
    }

    function executeTransaction(uint _transactionId) public {
        require(isConfirmed(_transactionId));
        Transaction storage _tx = transactions[_transactionId];
        (bool success, ) = _tx.destination.call{ value: _tx.value }(_tx.data);
        require(success, "Failed to Send ETH for Transaction Execution");
        _tx.executed = true;
    }
}
