// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RWATokenization {

    address public owner;
    uint public rwaCode; // Unique identifier for the RWA
    mapping(address => uint) public balances; // Tracks the number of tokens each address owns
    address[] public tokenHolders; // List of addresses that hold tokens

    // Event declarations
    event Minted(address to, uint amount, uint rwaCode);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(uint _rwaCode) {
        owner = msg.sender; // The deployer is the initial owner
        rwaCode = _rwaCode; // Set the RWA code for the token
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // Function to mint tokens
    function mint(address _to, uint _amount) public onlyOwner {
        require(_to != address(0), "Invalid address");
        if(balances[_to] == 0) {
            tokenHolders.push(_to); // Add to tokenHolders if new holder
        }
        balances[_to] += _amount; // Increase the balance of the recipient
        emit Minted(_to, _amount, rwaCode);
    }

    // Function to check token balance of a wallet
    function balanceOf(address _wallet) public view returns (uint) {
        return balances[_wallet];
    }

    // Function to get all token holders
    function getTokenHolders() public view returns (address[] memory) {
        return tokenHolders;
    }

    // Function to transfer contract ownership
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}
