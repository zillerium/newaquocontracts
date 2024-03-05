// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AquoNewERC20.sol";
import "./AquoContractList.sol";

contract Deployer {

    address public assetManagerAddress;

    // Event to log the address of the deployed contract
    event ERC20Deployed(address deployedAddress);

    constructor(address _assetManagerAddress) {
        assetManagerAddress = _assetManagerAddress;
    }

    function deployAndRegisterERC20(uint256 initialSupply) public returns (address) {
        // Deploy the ERC20 contract
        AssetShares newToken = new AssetShares(initialSupply);
        
        // Register the ERC20 in the AssetManager
        AssetManager(assetManagerAddress).addAsset("", "", address(newToken));

        // Emit the event
        emit ERC20Deployed(address(newToken));

        return address(newToken);
    }
}
