// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MultiAssetManager is Ownable {

    struct Asset {
        string ipfsAddress;
        mapping(address => uint256) shareBalances;
        uint256 totalShares;
    }

    uint256 private nextAssetId = 1;
    mapping(uint256 => Asset) public assets;
    uint256[] public assetIds; // New array for storing assetIds

    function addAsset(string memory ipfsAddress, uint256 initialShares) public onlyOwner returns (uint256) {
        uint256 assetId = nextAssetId++;

        assets[assetId].ipfsAddress = ipfsAddress;
        assets[assetId].shareBalances[msg.sender] = initialShares;
        assets[assetId].totalShares = initialShares;

        assetIds.push(assetId); // Push the new assetId to the array

        return assetId;
    }

    function balanceOf(uint256 assetId, address user) public view returns (uint256) {
        return assets[assetId].shareBalances[user];
    }

    function transferShares(uint256 assetId, address to, uint256 amount) public {
        require(assets[assetId].shareBalances[msg.sender] >= amount, "Insufficient shares");
        assets[assetId].shareBalances[msg.sender] -= amount;
        assets[assetId].shareBalances[to] += amount;

        emit TransferShares(assetId, msg.sender, to, amount);
    }

    function getAllAssetIds() public view returns (uint256[] memory) {
        return assetIds;
    }

    event TransferShares(uint256 indexed assetId, address indexed from, address indexed to, uint256 amount);
}
