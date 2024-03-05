// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AssetShares is ERC20, Ownable {
    
    mapping(address => uint256) private balances;  // Mapping to hold balances
    address[] private holders;  // Array to hold addresses of all holders
    
    constructor(uint256 initialSupply) ERC20("AssetShares", "ASH") {
        _mint(msg.sender, initialSupply);  // Initial distribution to the contract owner
        holders.push(msg.sender);  // Add contract owner to holders array
        balances[msg.sender] = initialSupply;  // Update balance in mapping
    }
    
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _updateHolders(msg.sender, recipient, amount);  // Update holders before transfer
        return super.transfer(recipient, amount);
    }
    
    
    function _updateHolders(address sender, address recipient, uint256 amount) internal {
        if (balances[recipient] == 0) {
            holders.push(recipient);  // Add recipient to holders array if not already a holder
        }
        balances[sender] -= amount;  // Update sender's balance in mapping
        balances[recipient] += amount;  // Update recipient's balance in mapping
    }
    
    function getAllHolders() public view returns (address[] memory, uint256[] memory) {
        uint256[] memory holderBalances = new uint256[](holders.length);
        for (uint i = 0; i < holders.length; i++) {
            holderBalances[i] = balances[holders[i]];  // Get balance of each holder from mapping
        }
        return (holders, holderBalances);
    }
}
