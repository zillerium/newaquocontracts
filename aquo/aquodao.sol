// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRWATokenization {
    function balanceOf(address _wallet) external view returns (uint);
    function getTokenHolders() external view returns (address[] memory);
}

contract DAO {

    struct Proposal {
        address proposer;
        address poolAddress; // Address of the pool contract to join
        address rwaContract;
        uint dilution; // Dilution factor or any other proposal-specific parameter
        uint yesVotes; // Total yes votes
        uint noVotes; // Total no votes
        bool executed; // Whether the proposal has been executed
        bool outcome; // Outcome of the proposal, true for passed, false for not passed
    }

    Proposal public proposal; // Single proposal for the entire contract

    IRWATokenization public rwaTokenizationContract; // RWA contract instance

    mapping(address => bool) public hasVoted; // Keeps track of who has voted

    event ProposalCreated(address indexed proposer, address poolContract, uint dilution);
    event Voted(address indexed voter, bool vote);
    event ProposalExecuted(bool outcome);

constructor(
    address _rwaTokenizationContract, 
    address _poolAddress, 
    uint _dilution,
    address _proposerWallet
) {
    // Check if the proposer wallet address is valid and a token holder
    require(_proposerWallet != address(0), "Invalid proposer wallet address");
    require(IRWATokenization(_rwaTokenizationContract).balanceOf(_proposerWallet) > 0, "Deploying wallet must be a token holder");

    // Check if the RWA tokenization contract address is valid
    require(_rwaTokenizationContract != address(0), "Invalid RWA tokenization contract address");

    // Check if the pool address is valid
    require(_poolAddress != address(0), "Invalid pool address");

    // Check if dilution is a non-negative integer; this is inherently true as uint cannot be negative in Solidity

    rwaTokenizationContract = IRWATokenization(_rwaTokenizationContract);

    proposal = Proposal({
        proposer: _proposerWallet, // Use the passed proposer wallet address
        poolAddress: _poolAddress,
        rwaContract: _rwaTokenizationContract,
        dilution: _dilution,
        yesVotes: 0,
        noVotes: 0,
        executed: false,
        outcome: false // Initialize the outcome as false
    });

    emit ProposalCreated(_proposerWallet, _poolAddress, _dilution);
}


    modifier onlyTokenHolder() {
        require(rwaTokenizationContract.balanceOf(msg.sender) > 0, "Not a token holder");
        _;
    }

    function vote(bool _vote) public onlyTokenHolder {
        require(!hasVoted[msg.sender], "Already voted");
        require(!proposal.executed, "Proposal already executed");

        if (_vote) {
            proposal.yesVotes += rwaTokenizationContract.balanceOf(msg.sender);
        } else {
            proposal.noVotes += rwaTokenizationContract.balanceOf(msg.sender);
        }

        hasVoted[msg.sender] = true;
        emit Voted(msg.sender, _vote);
    }

    function executeProposal() public {
        require(!proposal.executed, "Proposal already executed");

        proposal.outcome = proposal.yesVotes > proposal.noVotes; // Determine the outcome
        proposal.executed = true;

        emit ProposalExecuted(proposal.outcome);
    }

    // Optional: Function to view the outcome of the proposal
    function getProposalOutcome() public view returns (bool outcome, bool executed) {
        return (proposal.outcome, proposal.executed);
    }
}
