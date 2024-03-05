// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

contract AquoOracle is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    // Other contract variables and constructor remain unchanged

    // Modified request function to accept a parameter
    function request(string memory identifier) public {
        Chainlink.Request memory req = buildOperatorRequest(jobId, this.fulfill.selector);
        
        // Use the 'identifier' parameter to modify the request
        // For example, appending it to the URL
        string memory baseURL = "https://peacioapi.com:3001/getRwa/";
        string memory fullURL = string(abi.encodePacked(baseURL, identifier));

        req.add('method', 'GET');
        req.add('url', fullURL);
        req.add('headers', '["content-type", "application/json"]');
        req.add('body', '');
        
        // The rest of the request setup remains the same
        req.add('path', 'data,rwaPrice,$numberDecimal');
        req.addInt('multiplier', 10 ** 18);

        // Send the request to the Chainlink oracle
        sendOperatorRequest(req, fee);
    }

    // The rest of the contract remains unchanged
}
