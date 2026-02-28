// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;




contract SimpleStorage{

    mapping (uint => uint) numbers;


    uint public  num ;

    function setNumber(uint val) public virtual  {
        num = val;
    }

}