// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./aquopool.sol";
import "./AquoPoolList.sol";

contract DeployPoolContract {

    PoolList public poolList;
 
    // Event to log the address of the deployed asset contract
    event poolDeployed(address poolAddress);

    constructor(address _poolList) {
        poolList = PoolList(_poolList);
        //ProspectusRegistry = ProspectusRegistry(_prospectusRegistry);
    }

    function deployAndRegisterPool(
           ) public returns (address) {
 

        // Deploy the Asset contract
        PoolContract  newPool = new PoolContract();
        // Register the asset in the AssetManager
        poolList.listPool(address(newPool));

       
        // Emit the event
        emit poolDeployed(address(newPool));

        return address(newPool);
    }
}
