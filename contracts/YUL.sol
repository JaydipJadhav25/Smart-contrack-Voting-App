// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;



contract Yul{
     
     uint public  val ;


     function storVal(uint slot , uint val) public {
        assembly{
            sstore(slot, val)
        }
     }

     function getVal(uint slot) public view   returns (uint){
        uint  value;

        assembly{
            value := sload(slot)
        }
        return  val;
     }

}