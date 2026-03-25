// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract A {
    B public bContract;
   //. Referencing an Already Deployed Contract (using the contract type and address)

    constructor(address _bAddress) {
        bContract = B(_bAddress);
    }


    function callB() public view returns (address, address) {
        return bContract.callC();
    }
}




contract B {
    C public cContract;


    constructor(address _cAddress) {
        cContract = C(_cAddress);
    }


    function callC() public view returns (address, address) {
        return cContract.getOriginAndSender();
    }
}




contract C {
    function getOriginAndSender() public view returns (address, address) {
        return (tx.origin, msg.sender);
    }
}



