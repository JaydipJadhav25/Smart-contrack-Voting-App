// SPDX-License-Identifier: GPL-3.0


pragma solidity >=0.7.0 <0.9.0;

contract A  {

uint256 counter = 0;


function set(uint256 val) public {
  counter = val;
}


function get() public view returns (uint) {
   return  counter;
}

   
}



contract B {
  function getVal(A acontractAddress) external view  returns(uint){
       return   acontractAddress.get();
  }


   function setVal(A acontractAddress) external{
       acontractAddress.set(20);
  }

  function demo(string memory name , uint age , uint[] memory fixarray) public  pure  returns(bytes memory){
    return abi.encode(name , age , fixarray);

  }
  
}
