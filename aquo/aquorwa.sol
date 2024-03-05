// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPOOLToken {
    function transfer(uint poolSlot, uint amount) external; // Modified to accept a poolSlot number
    function transfer(address to, address rwaContractAddress, uint poolSlot, uint amount) external;
}

contract RWAToken {
    address public owner;
    address public poolAddress; // Variable to store the pool address
    uint public poolSlot; // Variable to store the pool slot number associated with this RWA token

    mapping(address => uint) public balances;

    // Token name and symbol for representation
    string public name = "Real World Asset";
    string public symbol = "RWA";

    event Transfer(address indexed from, address indexed to, uint amount);
    event Mint(address indexed to, uint amount);

    constructor() {
        owner = msg.sender; // Setting the contract deployer as the owner
    }

    // Modifier to restrict certain functions to the contract's owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

    modifier onlyPool() {
        require(msg.sender == poolAddress, "Only the POOL contract can perform this action");
        _;
    }


    function mint(uint amount) public onlyOwner {
        balances[address(this)] += amount;
        emit Mint(address(this), amount);
    }

    function transfer(address to, uint amount) public {
        require(balances[address(this)] >= amount, "Not enough tokens in contract");
        balances[address(this)] -= amount;
        balances[to] += amount;
        emit Transfer(address(this), to, amount);
    }

    function transferFrom(address from, address to, uint amount) public {
        require(balances[from] >= amount, "Insufficient balance");
        balances[from] -= amount;
        balances[to] += amount;
        emit Transfer(from, to, amount);
    }

    function updatePoolAddress(address newPoolAddress) public onlyOwner {
        poolAddress = newPoolAddress;
    }

    // Updated to accept a poolSlot number instead of msg.sender
    function swap(uint amount) public {
        require(balances[msg.sender] >= amount, "Insufficient RWA balance");
        IPOOLToken(poolAddress).transfer(msg.sender,  address(this), poolSlot, amount); // Modified to use poolSlot
        emit Transfer(msg.sender, poolAddress, amount); // Emit a Transfer event for the RWA tokens
    }

    // New function to update the pool slot number
    function updatePoolSlot(uint newPoolSlot) public onlyPool {
        poolSlot = newPoolSlot;
    }

}
