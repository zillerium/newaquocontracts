// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PoolList {
    struct Pool {
        uint256 poolId;
        address poolAddress;
    }

    Pool[] private pools;
    uint256 private nextPoolId = 1;
    mapping(uint256 => uint256) internal poolIdToIndex;
    mapping(address => uint256) internal poolAddressToIndex;
    mapping(address => bool) internal poolAddressExists;
    mapping(address => bool) internal unallocatedPool;  // True if ipfsAddress is null

    function listPool(address _poolAddress) public returns (uint256) {
        require(!poolAddressExists[_poolAddress], "Contract Address already exists");

        uint256 poolId = nextPoolId++;
        Pool memory newPool = Pool({
            poolId: poolId,
            poolAddress: _poolAddress
        });
        pools.push(newPool);
        uint256 index = pools.length - 1;
        poolIdToIndex[poolId] = index;
        poolAddressToIndex[_poolAddress] = index;
        poolAddressExists[_poolAddress] = true;
        unallocatedPool[_poolAddress] = false; // default

        return poolId;
    }

    function getPoolByPoolAddress(address _poolAddress) public view returns (Pool memory) {
        uint256 index = poolAddressToIndex[_poolAddress];
        return pools[index];
    }

    function getPoolByPoolId(uint256 _poolId) public view returns (Pool memory) {
        uint256 index = poolIdToIndex[_poolId];
        return pools[index];
    }

    function getAllPools() public view returns (Pool[] memory) {
        return pools;
    }
}
