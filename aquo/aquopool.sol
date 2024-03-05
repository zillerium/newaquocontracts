// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRWAToken {
    function transferFrom(address from, address to, uint amount) external;
    function updatePoolSlot(uint newPoolSlot) external; // Interface to call updatePoolSlot in RWAToken
}

contract PoolContract {
    address public owner;
    mapping(address => uint) public balances;
    mapping(uint => address) public slotToAddress; // Mapping of slots to addresses
    uint public lastSlot = 0; // Tracks the last allocated slot



    // Token name and symbol for representation
    string public name = "POOL Tokens";
    string public symbol = "POOL";

    constructor() {
        owner = msg.sender; // Setting the contract deployer as the owner
    }

    // Modifier to restrict certain functions to the contract's owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

    // Modifier to validate RWA addresses
    modifier validAddress(address addr) {
        require(addr != address(0), "Invalid address");
        _;
    }

    // Minting function to create tokens and assign them to the contract's address
    function mint(uint amount) public onlyOwner {
        balances[address(this)] += amount;
    }

    // Function to transfer tokens from the contract to another address
    function transfer(address to, address rwaContractAddr, uint poolSlot, uint amount) public validAddress(slotToAddress[poolSlot]) {
        require(balances[address(this)] >= amount, "Not enough tokens in contract");
        require(slotToAddress[poolSlot] == rwaContractAddr, "RWA address does not match slot"); // Check if the RWA address matches the slot
        require(slotToAddress[poolSlot] != address(0), "Slot does not exist");

        //address to = slotToAddress[poolSlot];

        // Transfer the tokens
        balances[address(this)] -= amount;
        balances[to] += amount;

        // For RWA transfer logic, you would need the RWA token address associated with `poolSlot`
        // This example assumes that logic is handled elsewhere or differently
        IRWAToken rwaToken = IRWAToken(rwaContractAddr);

        // Call `transferFrom` on the RWA contract to transfer RWA tokens from 'to' to the POOL contract
        // The 'to' address must have previously approved the POOL contract to spend RWA tokens on their behalf
        rwaToken.transferFrom(to, address(this), amount);
    }

    function transferFrom(address from, address to, uint amount) public {
        require(balances[from] >= amount, "Insufficient balance");
        balances[from] -= amount;
        balances[to] += amount;
    }

    // Function to add a new slot and its corresponding address
    function addSlot(address rwaAddress) public onlyOwner validAddress(rwaAddress) {
        uint newSlot = lastSlot + 1;
        slotToAddress[newSlot] = rwaAddress;
        IRWAToken rwaToken = IRWAToken(rwaAddress); // Create a local instance of the RWAToken contract
        rwaToken.updatePoolSlot(newSlot); 
        lastSlot = newSlot; // Update the last slot to the newly allocated slot
    }
}
