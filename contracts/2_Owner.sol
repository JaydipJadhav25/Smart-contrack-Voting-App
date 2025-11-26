// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Owner {

    address public  person ;

    constructor(){
        person = msg.sender;
    }

    function checkMsgSender() public   returns (address){
        person=msg.sender;
        return  msg.sender;
    }

      function checkTimestamp() public view    returns (uint){
        return  block.timestamp;
    }

    enum data{notfilled , pending , done}



   
} 
