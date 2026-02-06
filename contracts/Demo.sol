// SPDX-License-Identifier: GPL-3.0

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";


pragma solidity >=0.7.0 <0.9.0;



contract Demo{


using SafeERC20 for IERC20;
using SafeMath for uint256;


uint256 public tokenPrice = 2e16 wei; 


    // Updated logic for token price calculation with safeguards
function adjustTokenPriceBasedOnDemand(uint buyerCount , uint sellerCount) public  {

uint marketDemandRatio = buyerCount.mul(1e18).div(sellerCount);
console.log("market ration : " , marketDemandRatio);
uint smoothinfactor = 1e18;
uint adjustedRatio= marketDemandRatio.add(smoothinfactor).div(2);
console.log("adjustedRatio : " , adjustedRatio);

uint newTokenPrice =  tokenPrice.mul(adjustedRatio).div(1e18);
console.log("newTokenPrice  : " , newTokenPrice);

uint minTokenPrice = 1e15;
if (newTokenPrice < minTokenPrice){
    tokenPrice = minTokenPrice;
}

tokenPrice = newTokenPrice ;

   
}




function calculateTokenPrice(uint _amountOfToken) public view {
    //get updated token price
 require( _amountOfToken > 0 ,"amont of token is not less than zero or zero!");

 uint  amountopay = _amountOfToken.mul(tokenPrice).div(1e18);

console.log("amount to pay : " , amountopay);

}





   

}