// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract Opt{

    uint public  a ;

    function chnageA() public {
        a = 1;
    }
    //ex gas - 22256 // 20,000 -> fro change state vaiable , 2100- >cold access , so 156 is function executions gas


    // tx  gas - 43320 = 21000 min gas cost - 22256 function excutions cost 


    function chnageAagin() public {
        a = 2;
    }

    //fro function 2 : 
    //ex cost of gas : 5178 = 5000- fro chnage nonzero to nozero , 100 - warm access
    //tx const of gas : 26242 = 21,000 -> bast cost of tx , 5178 tx gas

    
   

}