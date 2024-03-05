pragma solidity ^0.8.0;

contract HTLC {
    address payable public buyer;
    address payable public seller;
    uint public deposit;
    bytes32 public secretHash;
    uint public expiration;
    bool public isOpen;

    constructor(address payable _seller, bytes32 _secretHash, uint _expiration) public {
        seller = _seller;
        secretHash = _secretHash;
        expiration = _expiration;
        isOpen = true;
    }

    function deposit() public payable {
        require(isOpen, "HTLC is closed");
        require(msg.value > 0, "Deposit must be greater than 0");
        buyer = msg.sender;
        deposit = msg.value;
    }

    function claim(bytes32 _secret) public {
        require(isOpen, "HTLC is closed");
        require(keccak256(_secret) == secretHash, "Secret does not match hash");
        require(now >= expiration, "HTLC has not yet expired");
        isOpen = false;
        seller.transfer(deposit);
    }

    function refund() public {
        require(isOpen, "HTLC is closed");
        require(now >= expiration, "HTLC has not yet expired");
        isOpen = false;
        buyer.transfer(deposit);
    }
}
