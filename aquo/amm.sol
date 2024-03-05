// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

interface IPriceOracle {
    // Returns the latest price
    function getLatestPrice() external view returns (uint256);
}

contract POOLDEX {
    IERC20 public rwaPoolToken;
    IERC20 public usdtToken;
    IPriceOracle public priceOracle;

    uint256 public constant PRICE_PRECISION = 1e6;

    // Example threshold for rebalancing (in percentage points, with precision)
   uint256 public rebalanceThreshold = 5 * 1e4; // 5%

    constructor(address _rwaPoolToken, address _usdtToken, address _priceOracle) {
        rwaPoolToken = IERC20(_rwaPoolToken);
        usdtToken = IERC20(_usdtToken);
        priceOracle = IPriceOracle(_priceOracle);
    }

    function checkAndRebalance() public view {
        uint256 oraclePrice = priceOracle.getLatestPrice(); // Assume oracle price is RWA POOL to USDT with 6 decimals
        uint256 rwaPoolPrice = getRWAPoolPrice();

        if (isRebalanceNeeded(oraclePrice, rwaPoolPrice)) {
            // Logic to rebalance the pool
            // This could involve adjusting the liquidity provided for RWA POOL and USDT
            // IMPORTANT: This is a complex operation and needs careful implementation to avoid manipulation or attacks
        }
    }

    function isRebalanceNeeded(uint256 oraclePrice, uint256 rwaPoolPrice) public view returns (bool) {
        uint256 priceDifference = oraclePrice > rwaPoolPrice ? oraclePrice - rwaPoolPrice : rwaPoolPrice - oraclePrice;
        uint256 priceDifferencePercentage = (priceDifference * PRICE_PRECISION) / oraclePrice;
        return priceDifferencePercentage >= rebalanceThreshold;
    }

    function getRWAPoolPrice() public view returns (uint256) {
        // Assuming the pool maintains equal value of POOL and USDT for simplicity
        // In a real scenario, the price would be determined by the ratio of POOL to USDT in the pool
        uint256 rwaPoolBalance = rwaPoolToken.balanceOf(address(this));
        uint256 usdtBalance = usdtToken.balanceOf(address(this));
        return (usdtBalance * PRICE_PRECISION) / rwaPoolBalance;
    }

    // Add more functions here for liquidity providers to add or remove liquidity, trade, etc.
}