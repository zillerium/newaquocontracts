// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract AssetContract {
    address public owner;
    bool public sharesLocked = false; // New state variable to track lock status
    uint256 private totalShares; // Variable to keep track of the total supply


    mapping(address => uint256) private shareBalances; // Mapping to keep track of balances
    address[] private holderAddresses; // Array to keep track of all addresses ever held shares

    struct Holder {
        address addr;
        uint256 balance;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier whenNotLocked() {
        require(!sharesLocked, "Shares are locked");
        _;
    }

    constructor(uint256 _initialShares, address _owner) {
        owner = _owner;
        totalShares = _initialShares; // Set the total supply at deployment

        shareBalances[_owner] = _initialShares;
        holderAddresses.push(_owner); // Add the owner to the holder addresses array
    }

    function totalSupply() public view returns (uint256) {
        return totalShares;
    }

    function balanceOf(address _user) public view returns (uint256) {
        return shareBalances[_user];
    }

    function transferShares(address _to, uint256 _amount) public whenNotLocked {
        require(shareBalances[msg.sender] >= _amount, "Insufficient shares");
        shareBalances[msg.sender] -= _amount;
        shareBalances[_to] += _amount;

        // Check if the recipient was a holder before the transfer
        bool isHolder = false;
        for (uint256 i = 0; i < holderAddresses.length; i++) {
            if (holderAddresses[i] == _to) {
                isHolder = true;
                break;
            }
        }

        // If the recipient was not a holder before transfer, add to the list
        if (!isHolder) {
            holderAddresses.push(_to);
        }
    }

    // New function to lock all shares
    function lockShares() external onlyOwner {
        sharesLocked = true;
    }

    // New function to unlock all shares
    function unlockShares() external onlyOwner {
        sharesLocked = false;
    }

    function getHolders() public view returns (Holder[] memory) {
        Holder[] memory holders = new Holder[](holderAddresses.length);
        for (uint256 i = 0; i < holderAddresses.length; i++) {
            holders[i] = Holder(holderAddresses[i], shareBalances[holderAddresses[i]]);
        }
        return holders;
    }
}
