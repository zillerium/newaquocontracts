// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

import "./AquoAssetManager.sol";
import "./AquoAssetShareNFT.sol";

contract AquoUserProxy {
    AquoAssetManager public assetManager;
    AquoAssetShareNFT public nft;

    constructor(address _assetManager, address _nft) {
        assetManager = AquoAssetManager(_assetManager);
        nft = AquoAssetShareNFT(_nft);
    }

    function approveManager() external {
        nft.setApprovalForAll(address(assetManager), true);
    }
}
