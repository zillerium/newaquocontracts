// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NameRegistry {
    // Define a struct to represent user profile
    struct UserProfile {
        string userName;
        bool registered;
        string ipfsImageHash; // New field for storing IPFS image hash
    }

    // Mapping to store the association between Ethereum addresses and user profiles
    mapping(address => UserProfile) public addressToProfile;

    // Event to log the registration of a new name
    event NameRegistered(address indexed ethAddress, string name, string ipfsImageHash);

    // Event to log the deregistration of a name
    event NameDeregistered(address indexed ethAddress);

    // Event to log the transfer of a name
    event NameTransferred(address indexed fromAddress, address indexed toAddress, string name);

    // Function to register a name
    function registerName(string memory _userName, string memory _ipfsImageHash) public {
        require(bytes(_userName).length > 0, "Name should not be empty");
        require(!addressToProfile[msg.sender].registered, "Address is already registered");

        addressToProfile[msg.sender] = UserProfile({
            userName: _userName,
            registered: true,
            ipfsImageHash: _ipfsImageHash // Assigning the IPFS image hash
        });

        emit NameRegistered(msg.sender, _userName, _ipfsImageHash);
    }

    // Function to deregister a name
    function deregisterName() public {
        require(addressToProfile[msg.sender].registered, "Address is not registered");

        addressToProfile[msg.sender] = UserProfile({userName: "", registered: false, ipfsImageHash: ""});

        emit NameDeregistered(msg.sender);
    }

    // Function to transfer a name to a new address
    function transferName(address _newAddress) public {
        UserProfile memory oldProfile = addressToProfile[msg.sender];

        require(oldProfile.registered, "Address is not registered");
        require(!addressToProfile[_newAddress].registered, "New address is already registered");

        addressToProfile[_newAddress] = UserProfile({
            userName: oldProfile.userName, 
            registered: true,
            ipfsImageHash: oldProfile.ipfsImageHash // Transferring the IPFS image hash
        });
        
        addressToProfile[msg.sender] = UserProfile({userName: "", registered: false, ipfsImageHash: ""});

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
    
    // Function to get IPFS Image Hash associated with the address
    function getIpfsImageHash(address _userAddress) public view returns (string memory) {
        UserProfile memory profile = addressToProfile[_userAddress];
        return profile.ipfsImageHash;
    }

    // Function to fetch the name and IPFS image hash associated with the address
    function getNameAndIpfsHash(address _userAddress) public view returns (string memory, string memory) {
        UserProfile memory profile = addressToProfile[_userAddress];
        if (profile.registered) {
            return (profile.userName, profile.ipfsImageHash);
        } else {
            return ("not found", "");
        }
    }

}
