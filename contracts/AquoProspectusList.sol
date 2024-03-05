// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProspectusRegistry {
    
    // Define a struct to hold the IPFS address and the proposer's wallet address
    struct ProspectusRecord {
        string ipfsAddress;
        address proposer;
    }
    
    // Array to hold all the ProspectusRecord entries
    ProspectusRecord[] public records;
    
    // Mapping to check for unique IPFS entries
    mapping(string => bool) private ipfsExists;

    // Add a new record to the array
    function addRecord(string memory _ipfsAddress) public {
        // Ensure the IPFS address hasn't been added before
        require(!ipfsExists[_ipfsAddress], "IPFS address already exists");
        
        // Create a new record and push it to the array
        records.push(ProspectusRecord({
            ipfsAddress: _ipfsAddress,
            proposer: msg.sender
        }));
        
        // Mark the IPFS address as added
        ipfsExists[_ipfsAddress] = true;
    }

    // Get the total number of records
    function getRecordCount() public view returns (uint) {
        return records.length;
    }
    
    // Get a specific record by index
    function getRecord(uint _index) public view returns (ProspectusRecord memory) {
        require(_index < records.length, "Index out of bounds");
        return records[_index];
    }

    function getAllRecords() public view returns (ProspectusRecord[] memory) {
        return records;
    }

    
    // For convenience, this getter function is automatically created for the 'records' array by marking it as public.
    // It will allow you to retrieve a record by index.
    // function records(uint _index) public view returns (ProspectusRecord memory);
}

