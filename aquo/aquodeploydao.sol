// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./aquodao.sol";
import "./AquoDaoList.sol";

contract DeployDAOContract {

    DAOList public daoList;
 
    // Event to log the address of the deployed asset contract
    event daoDeployed(address daoAddress);

    constructor(address _daoList) {
        daoList = DAOList(_daoList);
        //ProspectusRegistry = ProspectusRegistry(_prospectusRegistry);
    }

    function deployAndRegisterDAO(address _rwaContract, 
            address _poolAddress, uint _dilution
           ) public returns (address) {
 

        // Deploy the Asset contract
        DAO  newDAO = new DAO(_rwaContract, _poolAddress, _dilution, msg.sender);
        // Register the asset in the AssetManager
        daoList.listDAO(address(newDAO));

       
        // Emit the event
        emit daoDeployed(address(newDAO));

        return address(newDAO);
    }
}
