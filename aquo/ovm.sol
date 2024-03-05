// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    // State variable to store a number
    uint256 public storedNumber;

    // Function to store a number
    function store(uint256 _number) public {
        storedNumber = _number;
    }

    // Function to retrieve the stored number
    function retrieve() public view returns (uint256) {
        return storedNumber;
    }
}
