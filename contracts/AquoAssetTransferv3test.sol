// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AssetContract {

    address public owner;
    mapping(address => uint256) shareBalances;
    uint256 public totalShares;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

// this is deployed from a contract and hence msg.sender would be the sending contract, so _owner is used
    constructor(uint256 _initialShares, address _owner) {
        owner = _owner;
        shareBalances[owner] = _initialShares;
        totalShares = _initialShares;
    }

    function balanceOf(address _user) public view returns (uint256) {
        return shareBalances[_user];
    }

    function transferShares(address _to, uint256 _amount) public {
        require(shareBalances[msg.sender] >= _amount, "Insufficient shares");
        shareBalances[msg.sender] -= _amount;
        shareBalances[_to] += _amount;
    }
}
