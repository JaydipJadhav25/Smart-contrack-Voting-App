

// SPDX-License-Identifier: GPL-3.0


pragma solidity >=0.7.0 <0.9.0;



contract Main{
  uint public  total;
  //all opreations work here
  //delegate call to other contract functions
  //addition
  function additionCall(address _contractAddress , bytes memory data) public returns(bool){
   //call functions
   (bool ok , ) = _contractAddress.delegatecall(data);
   require(ok , "delegate call failed!");
   return  ok;
  } 

}


contract Addition{
      uint public  total ;

      //addition logic
      function addTwoNumbers(uint val) public {
        total +=val;
      }
      
      function addfunctionByteCode(uint val) public pure returns (bytes memory){
        return abi.encodeWithSignature("addTwoNumbers(uint256)", val);
      }
}



contract Subtraction{
      uint public  total;

      //addition logic
      function subNumber(uint val) public {
        total -=val;
      }
      
      function subfunctionByteCode(uint val) public pure returns (bytes memory){
        return abi.encodeWithSignature("subNumber(uint256)", val);
      }
}





