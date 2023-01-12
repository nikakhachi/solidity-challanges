// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

library UIntFunctions {
    function isEven(uint n) public pure returns (bool) {
        return n % 2 == 0;
    }
}