// // SPDX-License-Identifier: GPL-3.0


// pragma solidity >=0.7.0 <0.9.0;


interface  IDemo {
    function demo() external pure returns (uint);
}


contract A is IDemo {

    function demo() external pure returns (uint){
        return  10;
    }


}


//access first contract using second contract using address


contract B {

    function getDemofun(address _conAdd) external  pure returns(uint){
       return  IDemo(_conAdd).demo();
    }
}







