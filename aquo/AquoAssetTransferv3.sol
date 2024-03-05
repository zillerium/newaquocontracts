// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AssetContract {
    address public owner;
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

    constructor(uint256 _initialShares, address _owner) {
        owner = _owner;
        shareBalances[_owner] = _initialShares;
        holderAddresses.push(_owner); // Add the owner to the holder addresses array
    }

    function balanceOf(address _user) public view returns (uint256) {
        return shareBalances[_user];
    }

    function transferShares(address _to, uint256 _amount) public {
        require(shareBalances[msg.sender] >= _amount, "Insufficient shares");
        shareBalances[msg.sender] -= _amount;
        shareBalances[_to] += _amount;

        if (shareBalances[_to] == _amount) { // if the balance was zero before transfer
            holderAddresses.push(_to); // Add the recipient to the holder addresses array
        }
    }

    function getHolders() public view returns (Holder[] memory) {
        Holder[] memory holders = new Holder[](holderAddresses.length);
        for (uint256 i = 0; i < holderAddresses.length; i++) {
            holders[i] = Holder(holderAddresses[i], shareBalances[holderAddresses[i]]);
        }
        return holders;
    }
}