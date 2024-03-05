// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimulatedOracle {
    // Owner address for oracle management
    address public owner;

    // Mapping from asset contract addresses to their current valuation
    mapping(address => uint256) private valuations;

    // Modifier to restrict certain functions to the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // Event to emit when a valuation is updated
    event ValuationSet(address indexed assetContract, uint256 valuation);

    // Constructor sets the initial owner of the contract
    constructor() {
        owner = msg.sender;
    }

    // Function to set the valuation for a specific asset contract
    function setValuation(address assetContract, uint256 valuation) public onlyOwner {
        valuations[assetContract] = valuation;
        emit ValuationSet(assetContract, valuation);
    }

    // Function to get the latest valuation for a specific asset contract
    function getLatestValuation(address assetContract) external view returns (uint256) {
        return valuations[assetContract];
    }

    // Allow owner to transfer contract ownership
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        owner = newOwner;
    }
}
