// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SafeWallet {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    function transfer(address payable _to, uint256 _amount) public {
      require(msg.sender == owner, "Not owner");
    
      (bool sent, ) = _to.call{ value: _amount }("");
      require(sent, "Failed to send Ether");
    }
}
