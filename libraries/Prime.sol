// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

library Prime {
    function dividesEvenly(uint a, uint b) public pure returns (bool) {
        return a % b == 0;
    }

    function isPrime(uint n) public pure returns (bool) {
		for(uint i = 2; i <= n / 2; i++) {
			if(dividesEvenly(n, i)) {
				return false;
			}
		}
		return true;   
    }
}