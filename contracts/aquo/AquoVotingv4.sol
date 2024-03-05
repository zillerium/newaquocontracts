// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AquoAssetTransferv4.sol";

interface IAssetContract {
    function balanceOf(address _userAddr) external view returns (uint256);
    function sharesLocked() external view returns (bool);
    function totalSupply() external view returns (uint256); // Added line for totalSupply
}

contract VotingContract {
    uint256 private constant QUORUM_PERCENTAGE = 51; // Define quorum percentage

    struct Proposal {
        address proposerAddr;
        address investmentPoolAddr;
        uint256 dilutionFactor;
        uint256 endTime;
        bool executed;
        uint256 totalVotes;
        uint256 yesVotes;
    }

    mapping(address => Proposal) public proposals;
    uint public DURATION;

    event ProposalCreated(address indexed assetContractAddr, address indexed proposerAddr, uint256 endTime);
    event Vote(address indexed assetContractAddr, address indexed voterAddr, bool vote);

    function createProposal(
        address _assetContractAddr,
        address _investmentPoolAddr,
        uint256 _dilutionFactor
    ) external {
        require(!IAssetContract(_assetContractAddr).sharesLocked(), "Shares are locked");
        require(proposals[_assetContractAddr].endTime < block.timestamp, "Existing proposal in progress");

        proposals[_assetContractAddr] = Proposal({
            proposerAddr: msg.sender,
            investmentPoolAddr: _investmentPoolAddr,
            dilutionFactor: _dilutionFactor,
            endTime: block.timestamp + DURATION,
            executed: false,
            totalVotes: 0,
            yesVotes: 0
        });

        emit ProposalCreated(_assetContractAddr, msg.sender, block.timestamp + DURATION);
    }

    function vote(address _assetContractAddr, bool _support) external {
        Proposal storage p = proposals[_assetContractAddr];
        require(block.timestamp <= p.endTime, "Voting period over");
        require(!p.executed, "Proposal already executed");

        uint256 voterBalance = IAssetContract(_assetContractAddr).balanceOf(msg.sender);
        require(voterBalance > 0, "Only shareholders can vote");

        p.totalVotes += voterBalance;
        if (_support) {
            p.yesVotes += voterBalance;
        }

        emit Vote(_assetContractAddr, msg.sender, _support);
    }

    function executeProposal(address _assetContractAddr) external {
        Proposal storage p = proposals[_assetContractAddr];
        require(!p.executed, "Proposal already executed");

        p.executed = true; // Prevent re-entrancy

        uint256 totalSupply = IAssetContract(_assetContractAddr).totalSupply(); // This function needs to exist in the AssetContract

        // Check if the total votes cast is equal to or greater than the quorum needed
        // and if the yes votes constitute a majority of the total votes cast.
        if (p.totalVotes >= totalSupply * QUORUM_PERCENTAGE / 100 && p.yesVotes > totalSupply / 2) {
            // Proceed with quorum-met logic, like locking shares
        }


       
    }

    function isProposalSuccessful(address _assetContractAddress) public view returns (bool) {
        Proposal storage p = proposals[_assetContractAddress];
        uint256 totalSupply = IAssetContract(_assetContractAddress).totalSupply();
        // Ensure we're past the voting end time, the proposal was not already executed,
        // and the vote count meets quorum and majority requirements.
        return block.timestamp > p.endTime && 
               !p.executed && 
               p.totalVotes >= totalSupply * QUORUM_PERCENTAGE / 100 && 
               p.yesVotes > p.totalVotes / 2;
    }

}
