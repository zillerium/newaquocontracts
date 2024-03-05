// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AssetContract {

    address public owner;
    string public ipfsAddress;
    mapping(address => uint256) shareBalances;
    uint256 public totalShares;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

// this is deployed from a contract and hence msg.sender would be the sending contract, so _owner is used
    constructor(string memory _ipfsAddress, uint256 initialShares, address _owner) {
        owner = _owner;
        ipfsAddress = _ipfsAddress;
        shareBalances[owner] = initialShares;
        totalShares = initialShares;
    }

    function balanceOf(address user) public view returns (uint256) {
        return shareBalances[user];
    }

    function transferShares(address to, uint256 amount) public {
        require(shareBalances[msg.sender] >= amount, "Insufficient shares");
        shareBalances[msg.sender] -= amount;
        shareBalances[to] += amount;
    }
}
