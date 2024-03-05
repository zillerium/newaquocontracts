// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AssetContract {
    address public owner;
    mapping(address => uint256) private shareBalances;
    address[] private holders; // Array to store the list of holders with non-zero balance
    mapping(address => bool) private isHolder; // Map to check if an address is already a holder
    uint256 public totalShares;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(uint256 _initialShares, address _owner) {
        owner = _owner;
        shareBalances[owner] = _initialShares;
        totalShares = _initialShares;
        holders.push(owner); // Initialize the owner as the first holder
        isHolder[owner] = true;
    }

    function balanceOf(address _user) public view returns (uint256) {
        return shareBalances[_user];
    }

    function transferShares(address _to, uint256 _amount) public {
        require(shareBalances[msg.sender] >= _amount, "Insufficient shares");
        shareBalances[msg.sender] -= _amount;
        shareBalances[_to] += _amount;

        if (_amount > 0 && !isHolder[_to]) {
            holders.push(_to);
            isHolder[_to] = true;
        }

        if (shareBalances[msg.sender] == 0) {
            isHolder[msg.sender] = false;
            // Additional logic to remove holder from the array needed here
        }
    }

    function getHoldersWithBalances() public view returns (address[] memory, uint256[] memory) {
        uint256[] memory balances = new uint256[](holders.length);
        for (uint i = 0; i < holders.length; i++) {
            balances[i] = shareBalances[holders[i]];
        }
        return (holders, balances);
    }
}
