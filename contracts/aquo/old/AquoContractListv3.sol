// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ContractList {
    struct Contract {
        uint256 contractId;
        string ipfsAddress;
        address contractAddress;
    }

    Contract[] private contracts;
    uint256 private nextContractId = 1;
    mapping(uint256 => uint256) internal contractIdToIndex;
    mapping(address => uint256) internal contractAddressToIndex;
    mapping(address => bool) internal contractAddressExists;
    mapping(address => bool) internal unallocatedContracts;  // True if ipfsAddress is null

    function listContract(address _contractAddress, string memory _ipfsAddress) public returns (uint256) {
        require(!contractAddressExists[_contractAddress], "Contract Address already exists");

        uint256 contractId = nextContractId++;
        Contract memory newContract = Contract({
            contractId: contractId,
            ipfsAddress: _ipfsAddress,
            contractAddress: _contractAddress
        });
        contracts.push(newContract);
        uint256 index = contracts.length - 1;
        contractIdToIndex[contractId] = index;
        contractAddressToIndex[_contractAddress] = index;
        contractAddressExists[_contractAddress] = true;
        unallocatedContracts[_contractAddress] = false; // default

        return contractId;
    }

    function getAssetByContractAddress(address _contractAddress) public view returns (Contract memory) {
        uint256 index = contractAddressToIndex[_contractAddress];
        return contracts[index];
    }

    function getContractByContractId(uint256 _contractId) public view returns (Contract memory) {
        uint256 index = contractIdToIndex[_contractId];
        return contracts[index];
    }

    function getAllContracts() public view returns (Contract[] memory) {
        return contracts;
    }
}
