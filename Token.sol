// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Token {
    event Transfer(address from, address to, uint256 amount);

    string public name = "NIKAKHACHI";
    string public symbol = "NKH";
    uint8 public decimals = 18;

    uint public totalSupply = 1000 * (10 ** 18);

    mapping (address => uint256) public balances;

    constructor(){
        balances[msg.sender] = totalSupply;
    }

    function balanceOf(address _address) external view returns (uint) {
        return balances[_address];
    }

    function transfer(address _recipient, uint _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient Funds");
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(msg.sender, _recipient, _amount);
    }
}