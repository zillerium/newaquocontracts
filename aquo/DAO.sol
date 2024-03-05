// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRWATokenization {
    function balanceOf(address _wallet) external view returns (uint);
    function getTokenHolders() external view returns (address[] memory);
}

contract DAO {

    struct Proposal {
        address proposer;
        address poolContract; // Address of the pool contract involved in the proposal
        uint dilution; // Dilution factor or any other proposal-specific parameter
        uint yesVotes; // Total yes votes
        uint noVotes; // Total no votes
        bool executed; // Whether the proposal has been executed
        bool outcome; // Outcome of the proposal, true for passed, false for not passed
    }

    Proposal[] public proposals;
    IRWATokenization public rwaTokenizationContract; // RWA contract instance
    mapping(uint => mapping(address => bool)) public hasVoted; // Keeps track of who has voted on which proposal

    event ProposalCreated(uint indexed proposalId, address indexed proposer, address poolContract, uint dilution);
    event Voted(uint indexed proposalId, address indexed voter, bool vote);
    event ProposalExecuted(uint indexed proposalId, bool outcome);

    constructor(address _rwaTokenizationContract) {
        rwaTokenizationContract = IRWATokenization(_rwaTokenizationContract);
    }

    modifier onlyTokenHolder() {
        require(rwaTokenizationContract.balanceOf(msg.sender) > 0, "Not a token holder");
        _;
    }

    function createProposal(address _poolContract, uint _dilution) public onlyTokenHolder {
        proposals.push(Proposal({
            proposer: msg.sender,
            poolContract: _poolContract,
            dilution: _dilution,
            yesVotes: 0,
            noVotes: 0,
            executed: false,
            outcome: false // Initialize the outcome as false
        }));

        uint proposalId = proposals.length - 1;
        emit ProposalCreated(proposalId, msg.sender, _poolContract, _dilution);
    }

    function vote(uint _proposalId, bool _vote) public onlyTokenHolder {
        require(_proposalId < proposals.length, "Proposal does not exist");
        require(!hasVoted[_proposalId][msg.sender], "Already voted on this proposal");

        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");

        if (_vote) {
            proposal.yesVotes += rwaTokenizationContract.balanceOf(msg.sender);
        } else {
            proposal.noVotes += rwaTokenizationContract.balanceOf(msg.sender);
        }

        hasVoted[_proposalId][msg.sender] = true;
        emit Voted(_proposalId, msg.sender, _vote);
    }

    function executeProposal(uint _proposalId) public {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");

        proposal.outcome = proposal.yesVotes > proposal.noVotes; // Determine the outcome
        proposal.executed = true;

        emit ProposalExecuted(_proposalId, proposal.outcome);
    }

    // Optional: Function to view the outcome of a specific proposal
    function getProposalOutcome(uint _proposalId) public view returns (bool outcome, bool executed) {
        require(_proposalId < proposals.length, "Proposal does not exist");
        Proposal storage proposal = proposals[_proposalId];
        return (proposal.outcome, proposal.executed);
    }
}
