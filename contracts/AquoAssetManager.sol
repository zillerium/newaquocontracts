// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

// NFT contract for the shares
// deploy first (should deploy also asset share nft)

import "./AquoAssetShareNFT.sol";


contract AquoAssetManager {
    // Define the Asset structure
    struct Asset {
        uint256 assetId;
        uint256 assetVal;
        string assetCurr;
        uint256 nShares;
    }

    mapping(uint256 => Asset) public assets;
    mapping(uint256 => address) public assetToOwner;
    mapping(uint256 => uint256) public tokenToAsset;

    AquoAssetShareNFT public nft;

    constructor() {
        nft = new AquoAssetShareNFT(address(this));
    }

    // Add an asset to the contract and mint NFTs for the shares
    function addAsset(uint256 _assetId, uint256 _assetVal, string memory _assetCurr, uint256 _nShares) public {
        require(assets[_assetId].assetId == 0, "Asset with this ID already exists!");

        // Optional: Check if the AssetManager contract is approved to manage the user's tokens.
        // If not, revert with a message asking them to approve first.
        require(nft.isApprovedForAll(msg.sender, address(this)), "Please approve the AssetManager contract to manage your tokens.");

        Asset memory newAsset = Asset({
            assetId: _assetId,
            assetVal: _assetVal,
            assetCurr: _assetCurr,
            nShares: _nShares
        });

        assets[_assetId] = newAsset;
        assetToOwner[_assetId] = msg.sender;

        // Mint NFTs for the shares
        for (uint256 i = 0; i < _nShares; i++) {
           // nft.mint(msg.sender);
            uint256 tokenId = nft.mint(msg.sender);
            tokenToAsset[tokenId] = _assetId;
        }

     
    }

    // Transfer an asset share to a new owner (Transfer NFT)
    function transferAssetShare(uint256 _tokenId, address _newOwner) public {
        require(nft.ownerOf(_tokenId) == msg.sender, "Only the owner can transfer the share!");

        nft.transferFrom(msg.sender, _newOwner, _tokenId);
    }

     

    // Get total number of NFTs owned by an address
    function getTotalNFTsOwned(address owner) external view returns (uint256) {
        return nft.balanceOf(owner);
    }

function checkOwnerOf(uint256 tokenId) external view returns (address) {
    return nft.ownerOf(tokenId);
}



    // Get a list of token IDs owned by an address
    function getTokenIdsOwned(address owner) external view returns (uint256[] memory) {
        uint256 totalNFTs = nft.balanceOf(owner);
        uint256[] memory ownedTokenIds = new uint256[](totalNFTs);

        for (uint256 i = 0; i < totalNFTs; i++) {
            ownedTokenIds[i] = nft.tokenOfOwnerByIndex(owner, i);
        }

        return ownedTokenIds;
    }

    // Get asset details based on a token ID
    function getAssetByTokenId(uint256 tokenId) external view returns (Asset memory) {
        uint256 assetId = tokenToAsset[tokenId];
        return assets[assetId];
    }

}
