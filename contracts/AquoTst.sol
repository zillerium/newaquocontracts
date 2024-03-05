// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AssetShares is ERC721, Ownable {
    uint256 public totalShares;
    uint256 public sharesAllocated;
    uint256 public nextTokenId = 1;

    // Mapping from tokenId to shares
    mapping(uint256 => uint256) public tokenShares;

    constructor(uint256 _totalShares) ERC721("AssetShare", "ASH") {
        totalShares = _totalShares;
    }

    function allocateShares(uint256 _shares, address _recipient) external onlyOwner {
        require(sharesAllocated + _shares <= totalShares, "Not enough shares available");
        uint256 tokenId = nextTokenId++;
        _mint(address(this), tokenId);  // Mint to contract address
        _transfer(address(this), _recipient, tokenId);  // Transfer to recipient
        tokenShares[tokenId] = _shares;
        sharesAllocated += _shares;
    }

    function transferShares(uint256 _tokenId, uint256 _shares, address _recipient) external onlyOwner {
        require(tokenShares[_tokenId] >= _shares, "Not enough shares on token");
        require(_shares > 0, "Shares must be positive");
        
        uint256 remainingShares = tokenShares[_tokenId] - _shares;
        
        // Burn the original NFT
        _burn(_tokenId);
        
        // Mint new NFTs for the seller and buyer
        if (remainingShares > 0) {
            uint256 holderTokenId = nextTokenId++;
            _mint(address(this), holderTokenId);  // Mint to contract address
            _transfer(address(this), msg.sender, holderTokenId);  // Transfer to seller
            tokenShares[holderTokenId] = remainingShares;
        }
        
        uint256 buyerTokenId = nextTokenId++;
        _mint(address(this), buyerTokenId);  // Mint to contract address
        _transfer(address(this), _buyer, buyerTokenId);  // Transfer to buyer
        tokenShares[buyerTokenId] = _shares;
    }
}
