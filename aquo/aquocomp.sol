// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RWA {
    mapping(address => uint256) public balances;
    address public poolContract;
    address public owner;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event UpdatePoolAddress(address indexed oldAddress, address indexed newAddress);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function mint(uint256 amount) external onlyOwner {
        balances[address(this)] += amount;
    }

    function transfer(address recipient, uint256 amount) external returns (bool) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function swap(uint256 amount) external {
        require(poolContract != address(0), "Pool contract address not set");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        // Simulate swapping by transferring RWA tokens to Pool contract
        balances[address(this)] -= amount;
        balances[poolContract] += amount;

        // Notify the Pool contract about the swap
        Pool(poolContract).receiveSwap(msg.sender, amount);
    }

    function updatePoolAddress(address newPoolContract) external onlyOwner {
        address oldPoolContract = poolContract;
        poolContract = newPoolContract;
        emit UpdatePoolAddress(oldPoolContract, newPoolContract);
    }
}

contract Pool {
    mapping(address => uint256) public balances;
    address public rwaContract;
    address public owner;

    event Mint(uint256 amount);
    event Swap(address indexed from, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function mint(uint256 amount) external onlyOwner {
        balances[address(this)] += amount;
        emit Mint(amount);
    }

    function swap(address recipient, uint256 amount) external {
        require(balances[address(this)] >= amount, "Insufficient balance");
        balances[address(this)] -= amount;
        emit Swap(recipient, amount);
    }

    function setRWAContract(address _rwaContract) external onlyOwner {
        rwaContract = _rwaContract;
    }

    function receiveSwap(address sender, uint256 amount) external {
        require(msg.sender == rwaContract, "Only RWA contract can call this function");
        // Simulate swapping by transferring POOL tokens to sender
        balances[sender] += amount;
    }
}
