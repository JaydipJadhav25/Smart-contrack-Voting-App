// SPDX-License-Identifier: GPL-3.0


pragma solidity >=0.7.0 <0.9.0;

contract Owner  {

    address public  boos;
    uint public founds = 0;
    constructor(){
        boos = msg.sender;
    }

    //custom errors :
    error NotAuthorized(string message);
    
    // modifier checkPerson(address _person){
    //    if(boos != _person) revert NotAuthorized();
    //     _;
    // }


    function addFounds(uint _momey) public{
        //check isboos or not
       if(boos !=  msg.sender) revert NotAuthorized("access desmissed ! you are not boss");
      founds = _momey;
    }


      function checkTimestamp() public view returns (uint){
        return  block.timestamp;
    }


   
} 
