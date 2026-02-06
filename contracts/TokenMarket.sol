// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";


contract TokenMarketPlace is Ownable {
    
using SafeERC20 for IERC20;
using SafeMath for uint256;

uint256 public tokenPrice = 2e16 wei; // 0.02 ether per GLD token just balance in wei //2 ^26 wei => 0.2 ether price of token
uint256 public sellerCount = 1;
uint256 public buyerCount=1;
uint public prevAdjustedRatio;
IERC20 public gldToken;

event TokenPriceUpdated(uint256 newPrice);
event TokenBought(address indexed buyer, uint256 amount, uint256 totalCost);
event TokenSold(address indexed seller, uint256 amount, uint256 totalEarned);
event TokensWithdrawn(address indexed owner, uint256 amount);
event EtherWithdrawn(address indexed owner, uint256 amount);
event CalculateTokenPrice(uint256 priceToPay);


//construtor
constructor(address _gldToken) Ownable(msg.sender){
    gldToken = IERC20(_gldToken);
}




// Updated logic for token price calculation with safeguards
function adjustTokenPriceBasedOnDemand() public {
   uint marketDemandRatio = buyerCount.mul(1e18).div(sellerCount); 
   uint smoothingFactor = 1e18;
   uint adjustedRatio = marketDemandRatio.add(smoothingFactor).div(2);
   if(prevAdjustedRatio!=adjustedRatio){
    prevAdjustedRatio=adjustedRatio;
    uint newTokenPrice =  tokenPrice.mul(adjustedRatio).div(1e18);
    uint minimumPrice = 2e16;
    if(newTokenPrice<minimumPrice){
        tokenPrice = minimumPrice;
    }
    tokenPrice = newTokenPrice;
   }
}

// Updated logic for token price calculation with safeguards
// function adjustTokenPriceBasedOnDemand() public {
// uint marketDemandRatio = buyerCount.mul(1e18).div(sellerCount);
// uint smoothinfactor = 1e18;
// uint adjustedRatio= marketDemandRatio.add(smoothinfactor).div(2);
// uint newTokenPrice =  tokenPrice.mul(adjustedRatio).div(1e18);

// uint minTokenPrice = 1e15;
// if (newTokenPrice < minTokenPrice){
//     tokenPrice = minTokenPrice;
// }

// tokenPrice = newTokenPrice;

// }

function calculateTokenPrice(uint _amountOfToken) public returns (uint) {
    require( _amountOfToken > 0 ,"amont of token is not less than zero or zero!");
    adjustTokenPriceBasedOnDemand();
     uint  amountopay = _amountOfToken.mul(tokenPrice).div(1e18);//this is power of token  one token 1e18 => for floting number use
     console.log("amount token : " , amountopay);
     return amountopay;
}

// Buy tokens from the marketplace
function buyGLDToken(uint256 _amountOfToken) public payable {
    //check amout of token ig grater than zero
    uint tokemPrice = calculateTokenPrice(_amountOfToken);
    //get correct token price from user
    require(tokemPrice == msg.value , "fill correct token price");
    //this function automatically take ether from user and stor incontract
    // gldToken.safeTransfer( gldToken , msg.address , _amountOfToken);
    gldToken.safeTransfer( msg.sender , _amountOfToken);
    buyerCount++;
    //ement event
    emit TokenBought(msg.sender, _amountOfToken, tokemPrice);
   
}



// Sell tokens back to the marketplace
function sellGLDToken(uint256 amountOfToken) public {

//check user tokens
require(gldToken.balanceOf(msg.sender) >= amountOfToken , "user do not have token , check agian!");

// check first token and amount of token
uint totaltokneprice = calculateTokenPrice(amountOfToken);
gldToken.trySafeTransferFrom(msg.sender , address(this) , amountOfToken);
//then transfer to user amount
(bool ok ,) = payable (msg.sender).call{value :  totaltokneprice}("");
require(ok , "failed to send");
sellerCount++;
emit  TokenSold( msg.sender,   amountOfToken, totaltokneprice);

}

// Owner can withdraw excess tokens from the contract
function withdrawTokens(uint256 amount) public onlyOwner {
  require(amount > 0 , "amount is less than zero!");
    // transfer to user back
   require(gldToken.balanceOf(address(this)) >= amount , "out of balnce");
   //send back token to user
   gldToken.safeTransfer(msg.sender , amount);
   emit  TokensWithdrawn(msg.sender,  amount);
}

// Owner can withdraw accumulated Ether from the contract
function withdrawEther(uint256 amount) public onlyOwner {
   //check amount that have contract
   require( address(this).balance >= amount, "lnsufucent balance !");
  //send to user
  (bool ok , )  = payable (msg.sender).call{value : amount}("");
  require(ok , "failed!");
  emit  EtherWithdrawn(msg.sender , amount);

}

}