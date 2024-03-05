// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NameRegistry {
    // Mapping to store the association between Ethereum addresses and names
    mapping(address => string) public addressToName;

    // Mapping to check if an address has already registered a name
    mapping(address => bool) public isRegistered;

    // Mapping to check if an address has been deregistered
    mapping(address => bool) public isDeregistered;

    // Event to log the registration of a new name
    event NameRegistered(address indexed ethAddress, string name);

    // Event to log the deregistration of a name
    event NameDeregistered(address indexed ethAddress);

    // Function to register a name
    function registerName(string memory _userName) public  {
        require(bytes(_userName).length > 0, "Name should not be empty");
        require(!isRegistered[msg.sender], "Address is already registered");
        
        addressToName[msg.sender] = _userName;
        isRegistered[msg.sender] = true;
        
        emit NameRegistered(msg.sender, _userName);
    }

    // Function to deregister a name
    function deregisterName() public returns (uint) {
        // Check if the address is registered
        require(isRegistered[msg.sender], "Address is already registered");

        // Mark the address as deregistered and clear the name
        isDeregistered[msg.sender] = true;
        delete addressToName[msg.sender];

        emit NameDeregistered(msg.sender);

        // Return code 200 for success
        return 200;
    }

    // Function to fetch the name associated with the sender's address
    function getName(address _userAddress) public view returns (string memory) {
        if (isRegistered[_userAddress]) {
            return addressToName[_userAddress];
        } else {
            return "not found";
        }
    }
}
