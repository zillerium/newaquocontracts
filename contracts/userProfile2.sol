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

    // Event to log the transfer of a name
    event NameTransferred(address indexed fromAddress, address indexed toAddress, string name);

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

    // Function to transfer a name to a new address
    function transferName(address _newAddress) public {
        UserProfile memory oldProfile = addressToProfile[msg.sender];
        
        // Ensure the sender is registered before trying to transfer
        require(oldProfile.registered, "Address is not registered");
        // Ensure the new address is not registered already
        require(!addressToProfile[_newAddress].registered, "New address is already registered");

        // Create a new entry for the supplied address and the name held under msg.sender
        addressToProfile[_newAddress] = UserProfile({userName: oldProfile.userName, registered: true});
        
        // Deregister current entry for msg.sender
        addressToProfile[msg.sender] = UserProfile({userName: "", registered: false});

        emit NameTransferred(msg.sender, _newAddress, oldProfile.userName);
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
