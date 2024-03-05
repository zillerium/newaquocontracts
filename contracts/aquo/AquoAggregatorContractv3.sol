// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AquoContractListv3.sol";
import "./AquoProspectusList2v3.sol";

contract AggregatorContract {
    ContractList private contractList;
    ProspectusRegistry private prospectusRegistry;

    constructor(address _contractListAddress, address _prospectusRegistryAddress) {
        contractList = ContractList(_contractListAddress);
        prospectusRegistry = ProspectusRegistry(_prospectusRegistryAddress);
    }

    // A function to retrieve data from both ContractList and ProspectusRegistry
    function getContractAndProspectus(address contractAddress) public view returns (
        uint256 contractId,
        string memory prospectusCid,
        string memory imageCid,
        address proposer
    ) {
        // Retrieve contract data using the provided contract address
        ContractList.Contract memory contractData = contractList.getAssetByContractAddress(contractAddress);

        // Retrieve prospectus data using the prospectusCid obtained from contract data
        ProspectusRegistry.ProspectusRecord memory prospectusRecord = prospectusRegistry.getProspectusRecord(contractData.ipfsAddress);

        // Prepare data to return
        return (
            contractData.contractId,
            prospectusRecord.prospectusCid,
            prospectusRecord.imageCid,
            prospectusRecord.proposer
        );
    }
}
