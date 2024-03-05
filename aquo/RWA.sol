// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RWA {

    address public owner;
    uint public rwaCode; // Unique identifier for the RWA
    mapping(address => uint) public balances; // Tracks the number of tokens each address owns
    address[] public tokenHolders; // List of addresses that hold tokens

    // Event declarations
    event Minted(address to, uint amount, uint rwaCode);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Transfer(address indexed from, address indexed to, uint amount);

    constructor(uint _rwaCode, uint _initialSupply) {
        owner = msg.sender; // The deployer is the initial owner
        rwaCode = _rwaCode; // Set the RWA code for the token
        mint(owner, _initialSupply); // Mint initial supply to owner
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // Function to mint tokens
    function mint(address _to, uint _amount) internal { // Changed to internal
        require(_to != address(0), "Invalid address");
        balances[_to] += _amount; // Increase the balance of the recipient
        tokenHolders.push(_to); // Add to tokenHolders
        emit Minted(_to, _amount, rwaCode);
    }

    // Function to transfer tokens from seller to buyer
    function transfer(address _seller, address _buyer, uint _amount) public {
        require(_seller != address(0) && _buyer != address(0), "Invalid address");
        require(balances[_seller] >= _amount, "Seller does not have enough tokens");

        // Transfer the tokens
        balances[_seller] -= _amount;
        balances[_buyer] += _amount;

        // Add buyer to tokenHolders if they are a new holder
        bool isTokenHolder = false;
        for (uint i = 0; i < tokenHolders.length; i++) {
            if (tokenHolders[i] == _buyer) {
                isTokenHolder = true;
                break;
            }
        }
        if (!isTokenHolder) {
            tokenHolders.push(_buyer);
        }

        emit Transfer(_seller, _buyer, _amount);
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
