// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AssetContract {
    address public owner;
    mapping(address => uint256) private shareBalances;
    Holder[] private holders; // Array to store holder structs
    mapping(address => uint256) private holderIndex; // Map to store index in the array
    uint256 public totalShares;

    struct Holder {
        address addr; // Address of the holder
        uint256 balance; // Balance of the holder
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(uint256 _initialShares, address _owner) {
        owner = _owner;
        totalShares = _initialShares;
        holders.push(Holder({addr: owner, balance: _initialShares})); // Add the owner to the holders array
        holderIndex[owner] = holders.length; // Set the owner's index
        shareBalances[owner] = _initialShares;
    }

    function balanceOf(address _user) public view returns (uint256) {
        return shareBalances[_user];
    }

    function transferShares(address _to, uint256 _amount) public {
        require(shareBalances[msg.sender] >= _amount, "Insufficient shares");
        if (holderIndex[_to] == 0) { // Check if _to is not in the array
            holders.push(Holder({addr: _to, balance: 0})); // Initialize with zero balance
            holderIndex[_to] = holders.length; // Set the new holder's index
        }
        
        // Transfer shares
        shareBalances[msg.sender] -= _amount;
        shareBalances[_to] += _amount;
        holders[holderIndex[_to] - 1].balance = shareBalances[_to]; // Update the balance in the struct

        if (shareBalances[msg.sender] == 0) {
            delete holders[holderIndex[msg.sender] - 1]; // Remove holder struct
            holderIndex[msg.sender] = 0; // Reset the index mapping
        }
    }

    function getHolders() public view returns (Holder[] memory) {
        return holders;
    }
}
