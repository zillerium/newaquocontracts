// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceOracle is IPriceOracle {
    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Ethereum Mainnet
     * Aggregator: RWAPOOL/USDT
     * Address: [Deployed Chainlink Aggregator Address for RWA/USDT]
     */
    constructor() {
        priceFeed = AggregatorV3Interface([Deployed Chainlink Aggregator Address for RWAPOOL/USDT]);
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() external view override returns (uint256) {
        (
            /*uint80 roundID*/,
            int256 price,
            /*uint256 startedAt*/,
            /*uint256 timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        require(price >= 0, "Invalid price");
        return uint256(price);
    }
}
