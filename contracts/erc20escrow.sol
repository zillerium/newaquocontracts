// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract ERC20Escrow {
    address payable public seller;
    address payable public buyer;
    address public tokenAddress;
    IERC20 public token;
    uint256 public depositAmount;
    uint256 public releaseTime;

    constructor(address _seller, address _tokenAddress)    {
        seller = payable(_seller);
        tokenAddress = _tokenAddress;
        token = IERC20(tokenAddress);
    }

    function deposit(address _buyer, uint256 _amount) public {
        require(token.transferFrom(_buyer, address(this), _amount), "Transfer failed.");
        buyer = payable(_buyer);
        depositAmount = _amount;
        releaseTime = block.timestamp + 100; // releases funds after 1 day
    }

    function allowancecheck(address _buyer) public view returns(uint256) {
        return token.allowance(_buyer, address(this));

    }

    function release() public {
        require(block.timestamp >= releaseTime, "Release time has not been reached.");
        require(token.transfer(seller, depositAmount), "Transfer failed.");
    }

    function cancel() public {
        require(block.timestamp < releaseTime, "Release time has been reached, cannot cancel.");
        require(token.transfer(buyer, depositAmount), "Transfer failed.");
    }
}
