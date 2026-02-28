// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;



import {SimpleStorage} from "./SimpleStorage.sol";




contract StrorageFactory is SimpleStorage{

  function setNumber(uint val) public override  {
        num = val +10;
    }



}