// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "hardhat/console.sol";

contract Voting {
    event ProposalCreated(uint proposalId);
    event VoteCast(uint proposalId, address voter);

    enum VoteType { HASNT_VOTED, VOTED_YES, VOTED_NO }

    struct Proposal {
        address target;
        bytes data;
        uint yesCount;
        uint noCount;
    }

    mapping(address => bool) members;

    constructor(address[] memory _members) {
        for(uint i = 0; i < _members.length; i++) {
            members[_members[i]] = true;
        }
        members[msg.sender] = true;
    }


    mapping (uint => mapping (address => VoteType)) proposalVoters;
    Proposal[] public proposals;

    function newProposal(address _target, bytes calldata _data) external {
        require(members[msg.sender]);
        Proposal memory proposal = Proposal(_target, _data, 0, 0);
        proposals.push(proposal);
        emit ProposalCreated(proposals.length - 1);
    }
    
    function castVote(uint _proposalId, bool _isSupporter) external {
        require(members[msg.sender]);        
        console.log("---");
        console.log("VOTER: ", msg.sender, _isSupporter);
        Proposal storage proposal = proposals[_proposalId];
        if(proposalVoters[_proposalId][msg.sender] == VoteType.VOTED_YES){
            if(!_isSupporter){
                console.log("WAS SUPPORTER, NOW NOT");
                proposal.yesCount--;
                proposal.noCount++;
                proposalVoters[_proposalId][msg.sender] = VoteType.VOTED_NO;
            }
        } else if (proposalVoters[_proposalId][msg.sender] == VoteType.VOTED_NO){
            if(_isSupporter){
                console.log("WASN'T SUPPORTER, NOW YES");
                proposal.yesCount++;
                proposal.noCount--;
                proposalVoters[_proposalId][msg.sender] = VoteType.VOTED_YES;
            }
        } else {
            if(_isSupporter) {
                console.log("VOTED YES");
                proposalVoters[_proposalId][msg.sender] = VoteType.VOTED_YES;
                proposal.yesCount++;
            } else {
                console.log("VOTED NO");
                proposalVoters[_proposalId][msg.sender] = VoteType.VOTED_NO;
                proposal.noCount++;
            }
        }
        emit VoteCast(_proposalId, msg.sender);
        if(proposal.yesCount >= 10){
            (bool success, ) = proposal.target.call(proposal.data);
            require(success);
        }
    }

}
