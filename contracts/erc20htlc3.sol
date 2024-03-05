// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
 
 

contract Peacio {
 
    uint public saleRelease;
    uint public disputeRelease;
    address payable  buyer;
    address notary;
    address payable  seller;
    bool public dispute; 

    address   usdcAddressAvax = 0x5425890298aed601595a70AB815c96711a31Bc65; // avax testnet
    address   usdcAddressPolygon  = 0x0FA8781a83E46826621b3BC094Ea2A0212e71B23;
    address payable usdcAddressDERC20 = payable(0xfe4F5145f6e09952a5ba9e956ED0C25e3Fa4c7F1);
 
    address usdcAddress;

    receive() external payable {}

    constructor(address payable _seller

               )  {
        seller = _seller;
        buyer = payable(msg.sender); 

        usdcAddress = usdcAddressPolygon;
   
    }


    function approveTransfer(uint256 _value1) 
        public returns (bool, bool, bool, bool, bool) {
        uint256 amount = _value1;
        bool b1 = IERC20(usdcAddress).approve(msg.sender, amount);
        bool b2 = IERC20(usdcAddress).approve(seller, amount);
        bool b3=  IERC20(usdcAddress).approve(buyer, amount);
        bool b4=  IERC20(usdcAddress).approve(usdcAddress, amount);
        bool b5=  IERC20(usdcAddress).approve(tx.origin, amount);
        return (b1, b2, b3, b4, b5);
    }
   function payContract(uint256 _value1) 
        public  {
        uint256 amount = _value1;
       IERC20(usdcAddress).transfer(seller, amount);
    }

    function checkAllowance() public view returns (uint256, uint256, uint256, uint256, uint256) {
        uint256 b1= IERC20(usdcAddress).allowance(msg.sender, usdcAddress);
          uint256 b2= IERC20(usdcAddress).allowance(buyer, usdcAddress);
            uint256 b3= IERC20(usdcAddress).allowance(seller, usdcAddress);
              uint256 b4= IERC20(usdcAddress).allowance(usdcAddress, usdcAddress);
               uint256 b5= IERC20(usdcAddress).allowance(tx.origin, usdcAddress);
                    return (b1, b2, b3, b4, b5);
    }

    function approveAndTransferUSDC(uint256 _value1) 
        public payable returns(bool)  {
        uint256 amount = _value1;
        return IERC20(usdcAddress).transferFrom(usdcAddress, address(this), amount);
    }

     

   function getBuyerUsdcBalance() public view returns (uint256, uint256, uint256) {
        require(tx.origin == buyer);
        uint256 amount = IERC20(usdcAddress).balanceOf(buyer);
                uint256 amount1 = IERC20(usdcAddress).balanceOf(seller);
                uint256 amount2 = IERC20(usdcAddress).balanceOf(msg.sender);
        return (amount, amount1, amount2);
         
    }

   function getContractUsdcBalance() public view returns (uint256) {
        require(tx.origin == notary || tx.origin == seller || tx.origin == buyer);
        uint256 amount = IERC20(usdcAddress).balanceOf(address(this));
        return amount;
         
    }


    function getSenderBalance() public view returns (uint256) {
        return msg.sender.balance;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

      
  

     
 
}
