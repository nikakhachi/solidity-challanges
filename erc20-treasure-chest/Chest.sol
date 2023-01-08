// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC20.sol";

contract Chest {
    function plunder(address[] calldata _tokenAddresses) external {
        for(uint i = 0; i < _tokenAddresses.length; i++) {
            IERC20 token = IERC20(_tokenAddresses[i]);
            uint balance = token.balanceOf(address(this));
            token.transfer(msg.sender, balance);
        }
    }
}
