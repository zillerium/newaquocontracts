// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Peacio {
 
    uint public saleRelease;
    uint public disputeRelease;
    address payable buyer;
    address notary;
    address payable seller;
    bool public dispute; 

    receive() external payable {}

    constructor(address payable _seller, 
                address _notary, 
                uint _saleRelease,  
                uint _disputeRelease) payable {
        seller = _seller;
        notary = _notary;
        buyer = payable(msg.sender); 
        dispute = false;
        saleRelease = _saleRelease;
        if (_disputeRelease < _saleRelease) {
            disputeRelease = _saleRelease;
        } else {
            disputeRelease = _disputeRelease;
        }
    }

    function getContractBalance() public view returns (uint256) {
         return address(this).balance;
    }

    // Buyer disputes the contract payment before the sale release date
    function raiseDispute() public payable {
        require(tx.origin == buyer);
        require(block.timestamp <= saleRelease);
        dispute=true;
    }

    // Buyer can settle anytime to the Seller
    function settlement() public  {
        require(tx.origin == buyer);
        uint256 amount = address(this).balance;
        seller.transfer(amount);
         
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // the notary can decide to pay the seller or buyer based on a decision 
    function disputeSettlement(bool paySeller) public payable {
        require(tx.origin == notary);
        require(dispute == true);
        require(block.timestamp <= disputeRelease);
        uint256 amount = address(this).balance;
        if (paySeller) {
            seller.transfer(amount);
        } else {
            buyer.transfer(amount);
        }
    }

    // when no dispute is raised, the seller can get the funds after the sale release time
    function saleSettlement() public payable {
        require(tx.origin == notary || tx.origin == seller || tx.origin == buyer);
        require(block.timestamp >= saleRelease && dispute == false);
        uint256 amount = address(this).balance;
        seller.transfer(amount);
    }

    // after the dispute release time (regardless of if a dispute is raised or not),
    // the seller is entitled to the funds
    function defaultDisputeSettlement() public payable {
        require(tx.origin == notary || tx.origin == seller || tx.origin == buyer);
        require((block.timestamp >= disputeRelease));
        uint256 amount = address(this).balance;
        seller.transfer(amount);
    }

 

 
    fallback() external payable {
        revert();
    }

     
 
}
