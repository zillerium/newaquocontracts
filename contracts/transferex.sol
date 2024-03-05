// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleTransferContract1 {
    // Mapping to store token balances for each address
    mapping(address => uint256) private balances;

    // Function to transfer ERC20 tokens
    function transferToken(address recipient, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
    }

    // Function to get the balance of a specific address
    function getBalance(address account) external view returns (uint256) {
        return balances[account];
    }

    // Function to transfer ether
    function transferEth(address payable recipient) external payable {
        require(msg.value > 0, "No ether sent");
        recipient.transfer(msg.value);
    }
}
