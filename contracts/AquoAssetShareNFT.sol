// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// deploy first in the sequence of contracts -  AquoAssetManager.sol, then AquoUserProxy.sol

contract AquoAssetShareNFT is ERC721URIStorage, Ownable {
    constructor() ERC721("Asset Share Token", "AST") {
     
    }
 
    // Mint new NFTs
    function mint(
        address _to,
        uint256 _tokenId,
        string calldata _uri
    ) external onlyOwner  {
        _mint(_to, _tokenId);
        _setTokenURI(_tokenId, _uri);
    }
}
