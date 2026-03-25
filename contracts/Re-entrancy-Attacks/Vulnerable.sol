// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";


contract Vulnerable is {

    mapping(address => uint) public balances;


    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }


    function withdraw() public {
        uint bal = balances[msg.sender];
        require(bal > 0, "balance ir requried !");// eth >0
        (bool sent, ) = msg.sender.call{value: bal}("");//contract transfet to msg.sender
        require(sent, "Failed to send Ether");

        balances[msg.sender] = 0;
    }


    function callerAddress() public view returns(address){
        return msg.sender;
    }


}

