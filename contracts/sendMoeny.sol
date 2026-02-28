// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SendMoney {
   

   function trnsfer(address _to) public payable  returns(bool){
         (bool ok , ) = _to.call{value : msg.value}("");
         return  ok;
   }


}
