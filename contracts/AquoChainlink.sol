// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AssetPricing {
    // Struct to hold the asset pricing data.
    struct AssetData {
        uint256 price; // The price of the asset.
        bool exists;  // A flag to check if an entry exists for the asset.
    }

    // Mapping from asset contract address to its pricing data.
    mapping(address => AssetData) public assetPrices;

    // Address of the Chainlink Oracle (or another authorized entity) that can update the price.
    address public authorizedUpdater;

    // Event to be emitted when the asset price is updated.
    event PriceUpdated(address indexed assetContract, uint256 newPrice);

    // Ensure only the authorized address can call certain functions.
    modifier onlyAuthorizedUpdater() {
        require(msg.sender == authorizedUpdater, "Not authorized to update price");
        _;
    }

    constructor(address _authorizedUpdater) {
        authorizedUpdater = _authorizedUpdater;
    }

    // Update the asset price for a specific contract. Only callable by the authorized address.
    function updateAssetPrice(address _assetContract, uint256 _newPrice) external onlyAuthorizedUpdater {
        AssetData storage assetData = assetPrices[_assetContract];

        // If the asset doesn't exist in the mapping, set the exists flag.
        if (!assetData.exists) {
            assetData.exists = true;
        }

        assetData.price = _newPrice;
        emit PriceUpdated(_assetContract, _newPrice);
    }

    // Getter function to read the current asset price for a specific contract.
    function getCurrentAssetPrice(address _assetContract) external view returns (uint256) {
        AssetData memory assetData = assetPrices[_assetContract];
        require(assetData.exists, "Asset not found");
        return assetData.price;
    }

    // Function to update the authorized address. Useful in case you want to change the Chainlink Oracle or entity allowed to update prices.
    // Only the current authorized address can transfer this role.
    function setAuthorizedUpdater(address _newUpdater) external onlyAuthorizedUpdater {
        authorizedUpdater = _newUpdater;
    }
}
