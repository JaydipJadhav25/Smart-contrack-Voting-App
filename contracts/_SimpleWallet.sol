// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
//Transaction - from,to,timings,amount

//COA - 0xB9B678B56D243e5d4a9Dff43458226c06557EA2b

contract SimpleWallet {
    
    //custome errors
    error NotAuthorized(string);


    struct Transaction{
      address to;
      address send;
      uint timestamp;
      uint amount;
    }

    //dynamic array to stor transcations
    Transaction[] public  transcationHistory;
  


    address public owner;
    uint public old;
    uint public newval;
    string public  message;
    bool stop = false;
    event Transfer(address user , uint amounth);
    event Receive(address sender, uint amounth);


   mapping (address => uint) SuspiciousUser;


    constructor(){
       owner = msg.sender;
    }
 
    modifier onlyOwner() {
    if(owner !=  msg.sender) revert NotAuthorized("access desmissed ! you are not Owner");
        _;
    }



   
    modifier getSuspiciousUser(address _sender) {
    require(SuspiciousUser[_sender] <4  , "Activity found suspicious  , block for 1 day");
      _;
    }


    modifier isEmergencyDeclared() {
        require(stop == false , "emergency delecred!");
      _;
    }
   
    function toggleStop() external onlyOwner {
       stop = !stop;
    }


    function changOwner(address newOwner) public onlyOwner isEmergencyDeclared {
      require(newOwner != address(0), "Invalid address!");
      owner = newOwner;
    }


    /**Contract related functions**/
    function transferToContract() external payable {
      //to stor all transcations
      transcationHistory.push(Transaction({
       send : msg.sender,
       to : address(this),
       timestamp : block.timestamp,
       amount : msg.value
      }));

    }

    function transferToUserViaContract(address payable _to, uint _weiAmount) external onlyOwner {
     //check balance
     require(address(this).balance >= _weiAmount , "unsufficenet balance!");
     //check correct ot valid address
     require(_to != address(0), "Address is invalid check onces!");

     //to send money
     //event emit
     emit  Transfer(_to, _weiAmount);

          transcationHistory.push(Transaction({
       send : msg.sender,
       to : _to,
       timestamp : block.timestamp,
       amount : _weiAmount
      }));

    //  _to.transfer(_weiAmount);

     (bool ok , ) = _to.call{value : _weiAmount}("");

     require(ok, "failed !");

    }

    function withdrawFromContract(uint _weiAmount) external onlyOwner {
     require(address(this).balance >= _weiAmount , "unsufficenet balance!");
      payable(msg.sender).transfer(_weiAmount);
      transcationHistory.push(Transaction({
       send : address(this),
       to :msg.sender,
       timestamp : block.timestamp,
       amount : _weiAmount
      }));
    }

    function getContractBalanceInWei() external view returns (uint) {
       return  address(this).balance; //this refer currect address like currect contract
    }
   
     /**User related functions**/
    function transferToUserViaMsgValue(address payable  _to) external payable getSuspiciousUser(msg.sender){
    //check balance first of currect user
     old = address(this).balance; //this is contrack balance but we are use  , we use user balance to that why to chekc flow
    require(address(this).balance >= msg.value , " unsufficent balance => contrack!");
    require(msg.sender.balance >= msg.value , " unsufficent balance => user!");
    //then send to another user using user address
     _to.transfer(msg.value);
     newval = address(this).balance;
   //note**
    // msg.value => basically global variable , alos we can take fro user in function parameter
    }


    //event - sender,receiver, amount
    function receiveFromUser() external payable {
    //check first sender balance
    require(msg.value > 0 ,"amounth must br grater than zero !");
     payable(owner).transfer(msg.value);
    }


    function getOwnerBalanceInWei() external  view returns(uint){
     return owner.balance;
    }


   receive() external payable {
    emit Receive(msg.sender, msg.value);
    }


     function suspiciousActivity(address _sender) public {
     //update acitivity
     SuspiciousUser[_sender] +=1;
    }


    fallback() external payable {
      // message="fallback function is call !";
      // payable(msg.sender).transfer(msg.value); 
    suspiciousActivity(msg.sender);

    }


    function getTransactionHistory() external view returns(Transaction[] memory){
      return  transcationHistory;
    }


    function emergencyWithdrawl() external {
      require(stop == true , "emergency not defind!");
      //contract to owner
      payable (owner).transfer(address(this).balance);
    }


   




}


//Add the following features
//1.Setting and Changing Owner done
//2.Emergency Stop
//3. Emergency Withdrawl
//4. Check for invalid address done
//5. Transaction history - from,to,amount,timestamp done

















