// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AquoAssetTransferv3.sol";
import "./AquoContractListv3.sol";
import "./AquoProspectusList2v3.sol";

contract DeployContract {

    ContractList public contractList;
    ProspectusRegistry public prospectusRegistry;

    // Event to log the address of the deployed asset contract
    event contractDeployed(address contractAddress);

    constructor(address _contractList, address _prospectusRegistry) {
        contractList = ContractList(_contractList);
        //ProspectusRegistry = ProspectusRegistry(_prospectusRegistry);
        prospectusRegistry = ProspectusRegistry(_prospectusRegistry); // Fixed this line

    }

    function deployAndRegisterContract(
           string memory _pdfAddress,
           string memory _imageAddress, 
           uint256 _initialShares
           ) public returns (address) {
        require(bytes(_pdfAddress).length != 0, "PDF address is missing");
         require(bytes(_imageAddress).length != 0, "Image address is missing");
         require(_initialShares > 0, "Initial shares must be greater than zero");


        // Deploy the Asset contract
        AssetContract newContract = new AssetContract(_initialShares, msg.sender);
        // Register the asset in the AssetManager
        contractList.listContract(address(newContract), _pdfAddress);

        //ProspectusRegistry newProspectus = new ProspectusRegistry();
        prospectusRegistry.addRecord(_pdfAddress, _imageAddress); // Fixed this line


       // prospectusRegistry.addRecord(address(newProspectus), _pdfAddress, _imageAddress);

        // Emit the event
        emit contractDeployed(address(newContract));

        return address(newContract);
    }
}
