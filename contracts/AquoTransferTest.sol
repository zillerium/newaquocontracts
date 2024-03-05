pragma solidity ^0.8.20;

contract AssetContract {
    address public owner;
    mapping(address => uint256) private shareBalances;
    address[] private holders; // New array to store holders
    mapping(address => bool) private isHolder; // Helper mapping to keep track if an address is already a holder
    uint256 public totalShares;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(uint256 _initialShares, address _owner) {
        owner = _owner;
        shareBalances[owner] = _initialShares;
        totalShares = _initialShares;
        holders.push(owner); // Initialize the owner as the first holder
        isHolder[owner] = true;
    }

    function balanceOf(address _user) public view returns (uint256) {
        return shareBalances[_user];
    }

    function transferShares(address _to, uint256 _amount) public {
        require(shareBalances[msg.sender] >= _amount, "Insufficient shares");
        shareBalances[msg.sender] -= _amount;
        shareBalances[_to] += _amount;

        if (_amount > 0 && !isHolder[_to]) { // Check if _to is not a holder and amount is greater than 0
            holders.push(_to); // Add to holders list
            isHolder[_to] = true; // Mark as holder
        }

        if (shareBalances[msg.sender] == 0) { // Remove sender if balance is zero
            isHolder[msg.sender] = false;
        }
        // Note: The removal mechanism is not implemented here and should be handled with caution
    }

    function getHolders() public view returns (address[] memory) {
        return holders;
    }
}
