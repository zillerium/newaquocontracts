// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NameRegistry {
    // Mapping to store the association between Ethereum addresses and names
    mapping(address => string) public addressToName;
    
    // Mapping to check if an address has already registered a name
    mapping(address => bool) public isRegistered;
    
    // Event to log the registration of a new name
    event NameRegistered(address indexed ethAddress, string name);

    // Function to register a name with an Ethereum address
    function registerName(string memory name) public {
        require(bytes(name).length > 0, "Name should not be empty");
        require(!isRegistered[msg.sender], "Address is already registered");
        
        addressToName[msg.sender] = name;
        isRegistered[msg.sender] = true;
        
        emit NameRegistered(msg.sender, name);
    }
    
    // Function to fetch the name associated with an Ethereum address
    function getName() public view returns (string memory) {
        require(isRegistered[msg.sender], "Address is not registered");
        return addressToName[msg.sender];
    }
}
