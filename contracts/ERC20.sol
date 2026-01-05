// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.4.0) (token/ERC20/IERC20.sol)

pragma solidity >=0.4.16;

interface IERC20 {
   
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

     //total supplay token
    function totalSupply() external view returns (uint256);
    //total balance of account
    function balanceOf(address account) external view returns (uint256);
    //transfer
    function transfer(address to, uint256 value) external returns (bool);
    //allowing to transfer token
    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

 
contract Jaydip is IERC20{

address public  founder;
       //total supplay token
    // function totalSupply() external view returns (uint256); no need to make function just make variable
   
uint256 public  totalSupply =  1000; //number of token

mapping (address => uint) public  balanceOfUser;
mapping (address => mapping (address => uint)) public  allowedToken;
uint public  decimales = 0;
constructor(){
    founder = msg.sender;
    //assign initial token to founder
   balanceOfUser[founder] = totalSupply;
}



//total balance of account
    function balanceOf(address account) external view returns (uint256){
        //return user account balance
        return balanceOfUser[account];
    }

   //transfer
    function transfer(address to, uint256 value) external returns (bool){
        //check address is valide
        require(to != address(0), "address is InValid !");
        //check balalnce
        require(balanceOfUser[msg.sender] >= value , "insufficent balance ! check out balancee..");
        //decress balance
        balanceOfUser[msg.sender] -= value;
        //add another user balance
        balanceOfUser[to] += value;
      emit  Transfer(msg.sender,  to,  value);
        return  true;
    }   


 //allowing to transfer token
    function allowance(address owner, address spender) external view returns (uint256){
    //allow token 
    return  allowedToken[owner][spender];
    }


    //writing check
    function approve(address spender, uint256 value) external returns (bool){
         //check address is valide
        require(spender != address(0), "address is InValid !");
        //check balalnce
        require(balanceOfUser[msg.sender] >= value , "insufficent balance ! check out balancee..");
        //give aprove
        allowedToken[msg.sender][spender] = value;
       emit  Approval(msg.sender,spender, value);
        return  true;
    }

     function transferFrom(address from, address to, uint256 value) external returns (bool){
         //check address is valide
        require(to != address(0), "address is InValid !");
        //check balalnce that user
        require( allowedToken[from][to] >= value , "insufficent balance ! check out balancee..");
        //check value
        require(value >= 0 ,  "value is not be nigative !");
        allowedToken[from][to] -=value;
        balanceOfUser[from] -= value;
        balanceOfUser[to] += value;
      emit  Transfer(from,  to,  value);
        return  true;
     }


}