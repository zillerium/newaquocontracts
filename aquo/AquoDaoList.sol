// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DAOList {
    struct DAO {
        uint256 daoId;
        address daoAddress;
    }

    DAO[] private daos;
    uint256 private nextDAOId = 1;
    mapping(uint256 => uint256) internal daoIdToIndex;
    mapping(address => uint256) internal daoAddressToIndex;
    mapping(address => bool) internal daoAddressExists;
    mapping(address => bool) internal unallocatedDAO;  // True if ipfsAddress is null

    function listDAO(address _daoAddress) public returns (uint256) {
        require(!daoAddressExists[_daoAddress], "Contract Address already exists");

        uint256 daoId = nextDAOId++;
        DAO memory newDAO = DAO({
            daoId: daoId,
            daoAddress: _daoAddress
        });
        daos.push(newDAO);
        uint256 index = daos.length - 1;
        daoIdToIndex[daoId] = index;
        daoAddressToIndex[_daoAddress] = index;
        daoAddressExists[_daoAddress] = true;
        unallocatedDAO[_daoAddress] = false; // default

        return daoId;
    }

    function getDAOByDAOAddress(address _daoAddress) public view returns (DAO memory) {
        uint256 index = daoAddressToIndex[_daoAddress];
        return daos[index];
    }

    function getDAOByDAOId(uint256 _daoId) public view returns (DAO memory) {
        uint256 index = daoIdToIndex[_daoId];
        return daos[index];
    }

    function getAllDAOs() public view returns (DAO[] memory) {
        return daos;
    }
}