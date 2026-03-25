// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Token {
    mapping(address => uint256) public balances;
    // address[] public holders;
    uint256 public totalSupply;

    //holders
    mapping (address => bool) public  holders;
    

    event Transfer(address indexed from, address indexed to, uint256 amount);

    constructor(uint256 _initialSupply) {
        //check not zero
        require(_initialSupply > 0 , "_initialSupply is grater than zero !");
        totalSupply = _initialSupply;
        balances[msg.sender] = _initialSupply;
        // holders.push(msg.sender);  // Add the contract creator to the holders list
        holders[msg.sender] =  true;
    }

    function transfer(address _to, uint256 _amount) external {
        // uint256   userBal = balances[msg.sender];
        uint senderBalance  = balances[msg.sender];
        require(senderBalance >= _amount, "Insufficient balance");


        // balances[msg.sender] -= _amount;

         unchecked {
             balances[msg.sender] = senderBalance - _amount;
        balances[_to] += _amount;
         }
        
        // Check if recipient is a new holder
        if (!holders[_to]) {
            // holders.push(_to);
           holders[_to] = true;
        }
        
        emit Transfer(msg.sender, _to, _amount);
    }

    // function isHolder(address _address) internal view returns (bool) {
    //     // uint len =  holders.length;
    //     // for (uint256 i = 0; i < len; i++) {
    //     //     if (holders[i] == _address) {
    //     //         return true;
    //     //     }
    //     // }
    //     // return false;


    // }
    
    function getHolders() external view returns (address[] memory) {
        return holders;
    }
}