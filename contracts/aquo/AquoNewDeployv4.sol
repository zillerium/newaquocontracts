// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AquoAssetTransferv4.sol";
import "./AquoContractListv3.sol";
import "./AquoProspectusList2v3.sol";
import "./AquoVotingv4.sol"; // Import the VotingContract interface if necessary


contract DeployContract {

    ContractList public contractList;
    ProspectusRegistry public prospectusRegistry;
    VotingContract public votingContract;


    // Event to log the address of the deployed asset contract
    event contractDeployed(address contractAddress);

    constructor(address _contractList, address _prospectusRegistry, address _votingContractAddress) {
        contractList = ContractList(_contractList);
        prospectusRegistry = ProspectusRegistry(_prospectusRegistry);
        votingContract = VotingContract(_votingContractAddress);
    }

    // Function to unlock shares of a deployed Asset Contract
    function unlockAssetShares(address assetContractAddress) public {
        // Create an instance of the AssetContract at the provided address
        AssetContract assetContract = AssetContract(assetContractAddress);
        
        // Call the unlockShares function of the AssetContract
        assetContract.unlockShares();
    }

    function lockShares(address _votingContractAddress, address _assetContractAddress) public {
        // You would call this function providing the address of the VotingContract and the AssetContract
        
        // Instantiate the VotingContract
        VotingContract votingContractInstance = VotingContract(_votingContractAddress);

        // Determine if the proposal was successful by calling isProposalSuccessful on the VotingContract
        bool proposalSuccess = votingContractInstance.isProposalSuccessful(_assetContractAddress);

        // Instantiate the AssetContract
        AssetContract assetContractInstance = AssetContract(_assetContractAddress);

        // If the proposal was successful and shares are not already locked, lock them
        if (proposalSuccess && !assetContractInstance.sharesLocked()) {
            assetContractInstance.lockShares();
        } 
      
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
