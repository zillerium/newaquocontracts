// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IOracle {
    function getLatestValuation(address assetContract) external view returns (uint256);
}

contract ContractList {
    struct Contract {
        uint256 contractId;
        string ipfsAddress;
        address contractAddress;
        uint256 valuation;  // Added to store the contract's valuation
    }

    Contract[] private contracts;
    uint256 private nextContractId = 1;
    IOracle public oracle; // Instance of the Oracle interface

 
    constructor(address _oracleAddress) {
        oracle = IOracle(_oracleAddress); // Set the Oracle address on deployment
    }

    mapping(uint256 => uint256) internal contractIdToIndex;
    mapping(address => uint256) internal contractAddressToIndex;
    mapping(address => bool) internal contractAddressExists;
    mapping(address => bool) internal unallocatedContracts;  // True if ipfsAddress is null

    // Event to emit when a contract's valuation is updated
    event ValuationUpdated(address indexed contractAddress, uint256 newValuation);

    function listContract(address _contractAddress, string memory _ipfsAddress) public returns (uint256) {
        require(!contractAddressExists[_contractAddress], "Contract Address already exists");

        uint256 contractId = nextContractId++;
        Contract memory newContract = Contract({
            contractId: contractId,
            ipfsAddress: _ipfsAddress,
            contractAddress: _contractAddress,
            valuation: 0  // Initialize valuation with zero
        });
        contracts.push(newContract);
        uint256 index = contracts.length - 1;

        contractIdToIndex[contractId] = index;
        contractAddressToIndex[_contractAddress] = index;
        contractAddressExists[_contractAddress] = true;
        unallocatedContracts[_contractAddress] = false; // default

        return contractId;
    }

    function updateValuation(address _contractAddress) public {
        require(contractAddressExists[_contractAddress], "Contract Address does not exist");
        uint256 index = contractAddressToIndex[_contractAddress];
        uint256 newValuation = oracle.getLatestValuation(_contractAddress);
        contracts[index].valuation = newValuation;
        emit ValuationUpdated(_contractAddress, newValuation);
    }

    function getAssetByContractAddress(address _contractAddress) public view returns (Contract memory) {
        require(contractAddressExists[_contractAddress], "Contract Address does not exist");
        return contracts[contractAddressToIndex[_contractAddress]];
    }

    function getContractByContractId(uint256 _contractId) public view returns (Contract memory) {
        return contracts[contractIdToIndex[_contractId]];
    }

    function getAllContracts() public view returns (Contract[] memory) {
        return contracts;
    }
}
