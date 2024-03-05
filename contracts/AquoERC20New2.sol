// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AssetShares {
    
    mapping(address => uint256) private balances;

    constructor(uint256 _totalSupply) {
        balances[msg.sender] = _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(balances[msg.sender] >= amount, "Insufficient balance.");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        return true;
    }
}
