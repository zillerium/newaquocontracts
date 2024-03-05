// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AssetShares is ERC721URIStorage, Ownable {
    uint256 public totalShares;
    uint256 public sharesSold;
    uint256 public nextTokenId = 1;

    // Mapping from tokenId to shares
    mapping(uint256 => uint256) public tokenShares;

    constructor(uint256 _totalShares) ERC721("AssetShare", "ASH") {
        totalShares = _totalShares;
    }

    function allocateShares(uint256 _shares, address _recipient) external onlyOwner {
        require(sharesSold + _shares <= totalShares, "Not enough shares available");
        uint256 tokenId = nextTokenId++;
        _mint(_recipient, tokenId);  // Mint directly to recipient
        tokenShares[tokenId] = _shares;
        sharesSold += _shares;
    }

    function transferShares(uint256 _tokenId, uint256 _shares, address _newHolder) external {
        require(ownerOf(_tokenId) == msg.sender, "Only token owner can transfer shares");
        require(tokenShares[_tokenId] >= _shares, "Not enough shares on token");
        require(_shares > 0, "Shares must be positive");
        
        uint256 remainingShares = tokenShares[_tokenId] - _shares;
        
        // Burn the original NFT
        _burn(_tokenId);
        
        // Mint new NFTs for the sender and receiver
        if (remainingShares > 0) {
            uint256 remainingTokenId = nextTokenId++;
            _mint(msg.sender, remainingTokenId);  // Mint directly to sender
            tokenShares[remainingTokenId] = remainingShares;
        }
        
        uint256 newTokenId = nextTokenId++;
        _mint(_newHolder, newTokenId);  // Mint directly to receiver
        tokenShares[newTokenId] = _shares;
    }
}
