// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// deploy first in the sequence of contracts -  AquoAssetManager.sol, then AquoUserProxy.sol

contract AquoAssetShareNFT is ERC721URIStorage, Ownable {
    constructor(address manager) ERC721("Asset Share Token", "AST") {
        transferOwnership(manager);
    }
 
    // Mint new NFTs
    function mint(address to) external onlyOwner returns (uint256) {
        uint256 tokenId = totalSupply() + 1;
        _mint(to, tokenId);
        return tokenId;
    }
}
