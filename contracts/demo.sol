SPDX-License-Identifier: GPL-3.0


pragma solidity >=0.7.0 <0.9.0;


// import "./Library.sol";

contract Demo{
    function result(uint a , uint b)external pure returns(uint){
        return  Opreations.additions(a ,b);
    }
}