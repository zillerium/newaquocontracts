// SPDX-License-Identifier: BSD-2-Clause
pragma solidity ^0.8.16;

// This contract has three functions - 
/* 
- sendEtherTested - sends 1 Ether
- sendEtherTestedWei - sends 1e18 (also 1 Ether)
- sendEtherError - fails to add 1 Ether and would send 1 Wei
*/

contract SendOneEth {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    // Owner can send 1 Eth to any recipient using this function
    function sendEtherTested(address _recipient) public {
        require(address(this).balance >= 1 ether);
        require(msg.sender == owner, "Only owner can send ether.");

        uint amount = 1 ether;
        payable(_recipient).transfer(amount);
    }

    // Owner can send 1 Eth to any recipient using this function
    function sendEtherTestedWei(address _recipient) public {
        require(address(this).balance >= 1e18);
        require(msg.sender == owner, "Only owner can send ether.");

        uint amount = 1e18;
        payable(_recipient).transfer(amount);
    }

    // Owner can send 1 Eth to any recipient using this function (has an error)
    function sendEtherError(address _recipient) public {
        require(address(this).balance >= 1);
        require(msg.sender == owner, "Only owner can send ether.");

        uint amount = 1;
        payable(_recipient).transfer(amount);
    }
}