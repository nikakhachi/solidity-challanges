// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface Contract {
   function attempt() external;
}

contract Middleman {
    address private destinationContractAddress = 0xcF469d3BEB3Fc24cEe979eFf83BE33ed50988502;

    function initiate() external {
        Contract(destinationContractAddress).attempt();
    }
}
