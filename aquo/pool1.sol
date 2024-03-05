contract Pool {
    RWA public rwaContract;
    mapping(address => uint256) public poolBalances; // Tracks POOL token balances

    // Constructor to set the RWA contract address
    constructor( ) {
         
        // Assume the Pool contract is initialized with a fixed supply of POOL tokens
        poolBalances[address(this)] = 1000; // Example supply
    }

    // Swap function to exchange POOL tokens with RWA1 tokens
    function swap(uint256 amount) external {
        require(poolBalances[address(this)] >= amount, "Insufficient POOL tokens in Pool");

        // Call the RWA contract to transfer RWA1 tokens from the sender to this Pool
        rwaContract.transfer(msg.sender, address(this), amount);

        // Adjust POOL token balances
        poolBalances[address(this)] -= amount;
        poolBalances[msg.sender] += amount;
    }
}
