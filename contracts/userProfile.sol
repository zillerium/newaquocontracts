// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NameRegistry {
    // Define a struct to represent user profile
    struct UserProfile {
        string userName;
        bool registered;
    }

    // Mapping to store the association between Ethereum addresses and user profiles
    mapping(address => UserProfile) public addressToProfile;

    // Event to log the registration of a new name
    event NameRegistered(address indexed ethAddress, string name);

    // Event to log the deregistration of a name
    event NameDeregistered(address indexed ethAddress);

    // Function to register a name
    function registerName(string memory _userName) public {
        require(bytes(_userName).length > 0, "Name should not be empty");
        require(!addressToProfile[msg.sender].registered, "Address is already registered");

        addressToProfile[msg.sender] = UserProfile({userName: _userName, registered: true});

        emit NameRegistered(msg.sender, _userName);
    }

    // Function to deregister a name
    function deregisterName() public {
        // Check if the address is registered
        require(addressToProfile[msg.sender].registered, "Address is not registered");

        // Mark the address as deregistered and clear the name
        addressToProfile[msg.sender] = UserProfile({userName: "", registered: false});

        emit NameDeregistered(msg.sender);
        
    }

    // Function to fetch the name associated with the sender's address
    function getName(address _userAddress) public view returns (string memory) {
        UserProfile memory profile = addressToProfile[_userAddress];
        if (profile.registered) {
            return profile.userName;
        } else {
            return "not found";
        }
    }
}
