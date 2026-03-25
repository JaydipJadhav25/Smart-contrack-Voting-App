// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/finance/PaymentSplitter.sol";


contract SplitPayments is PaymentSplitter {
    constructor (
        address[] memory payees,
        uint256[] memory shares_
    ) payable PaymentSplitter(payees, shares_) {


    }
}


//https://github.com/OpenZeppelin/openzeppelin-contracts/pull/4276#issuecomment-1584175563
//https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/CHANGELOG.md
//https://github.com/OpenZeppelin/openzeppelin-contracts/releases



