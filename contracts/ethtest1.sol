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
    function registerName(string memory _userName, address _userAddress) public returns (uint) {
        // Check if the name is not empty
        if (bytes(_userName).length == 0) {
            // Return code 404 for name not specified
            return 404;
        }
        
       // Check if the address is not empty
        if (_userAddress == address(0)) {
            // Return code 405 for address not specified
            return 405;
        }

        // Check if the address is already registered
        if (isRegistered[_userAddress]) {
            // Return code 811 for duplicate attempt
            return 811;
        }
        
        addressToName[_userAddress] = _userName;
        isRegistered[_userAddress] = true;
        
        emit NameRegistered(_userAddress, _userName);
        
        // Return code 200 for success
        return 200;
    }
    
    // Function to fetch the name associated with an Ethereum address
    function getName(address _userAddress) public view returns (string memory) {
        if (isRegistered[_userAddress]) {
            return addressToName[_userAddress];
        } else {
            return "not found";
        }
    }
}
