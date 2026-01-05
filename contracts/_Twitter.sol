// SPDX-License-Identifier: MIT


pragma solidity ^0.8.26;

// Twitter Project (Lab - 10)
// Objective: Develop a smart contract that simulates a simple social media platform where users can tweet, send messages, follow other users, and manage operator permissions.

// Requirements:

// Tweeting:

// Users can post tweets.
// An operator (authorized by a user) can post tweets on behalf of that user.

// Messaging:

// Users can send direct messages to other users.
// An operator can send messages on behalf of the user who authorized them.
// Following:

// Users can follow other users.
// Operator Management:

// Users can allow or disallow other users as operators who can act on their behalf.
// Retrieving Tweets:

// Retrieve the latest tweets from all users.
// Retrieve the latest tweets from a specific user.

// Instructions:
// Define the Contract Structure:
// Create a Tweet struct to store tweet details (ID, author, content, creation timestamp).
// Create a Message struct to store message details (ID, content, sender, receiver, creation timestamp).
// Mappings:

// tweets: A mapping to store all tweets.
// tweetsOf: A mapping to store the IDs of tweets by each user.
// conversations: A mapping to store direct messages between users.
// operators: A mapping to manage operator permissions.
// following: A mapping to store the list of users that each user follows.
// Functions:

// _tweet(address _from, string memory _content): Internal function to handle the tweeting logic.
// _sendMessage(address _from, address _to, string memory _content): Internal function to handle messaging logic.
// tweet(string memory _content): Allows a user to post a tweet.
// tweet(address _from, string memory _content): Allows an operator to post a tweet on behalf of a user.
// sendMessage(string memory _content, address _to): Allows a user to send a message.
// sendMessage(address _from, address _to, string memory _content): Allows an operator to send a message on behalf of a user.
// follow(address _followed): Allows a user to follow another user.
// allow(address _operator): Allows a user to authorize an operator.
// disallow(address _operator): Allows a user to revoke an operator's authorization.
// getLatestTweets(uint count): Returns the latest tweets across all users.
// getLatestTweetsOf(address user, uint count): Returns the latest tweets of a specific user.

contract Twitter{

//1 . Create a Tweet struct to store tweet details (ID, author, content, creation timestamp).
    struct Tweet{
        uint Id;
        address author;
        string content;
        uint creation_timestamp;
    }
//2 . Create a Message struct to store message details (ID, content, sender, receiver, creation timestamp).
    struct Message{
        uint Id;
        string content;
        address sender;
        address receiver;
        uint creation_timestamp;
    }



// tweets: A mapping to store all tweets. 
 mapping (uint => Tweet) public  tweets;
// tweetsOf: A mapping to store the IDs of tweets by each user.
mapping (uint => uint[]) public   tweetsOf;
// conversations: A mapping to store direct messages between users.
mapping (address => Message[]) public conversations;
// operators: A mapping to manage operator permissions.
mapping (address => mapping(address => bool)) public   operators;
// following: A mapping to store the list of users that each user follows.
mapping (address => address[]) public  following;



address public user;//current user

uint  nextTweetId = 0;
uint  nextMessageId = 0;

//array to stor all tweets
Tweet[]  public allTweets;
Message[] public  allMessages;




//contrustore
constructor(){
    user = msg.sender;
}


// Functions:

//1 . _tweet(address _from, string memory _content): Internal function to handle the tweeting logic.
function _tweet(address _from, string memory _content) internal   {
    tweets[nextTweetId] = Tweet({
        Id : nextTweetId,
        author : _from,
        content :  _content,
        creation_timestamp : block.timestamp
    });
    //stor in array
    allTweets.push(tweets[nextTweetId]);
    nextTweetId++;
}

//2 . _sendMessage(address _from, address _to, string memory _content): Internal function to handle messaging logic.
function _sendMessage(address _from, address _to, string memory _content) internal    {
   conversations[_from].push(Message({
         Id : nextMessageId,
         content : _content,
        sender : _from,
        receiver : _to,
        creation_timestamp : block.timestamp
   }));
   //store in array
   allMessages.push(Message({
         Id : nextMessageId,
         content : _content,
        sender : _from,
        receiver : _to,
        creation_timestamp : block.timestamp
   }));
   //update message id
   nextMessageId +=1;
}

//3. tweet(string memory _content): Allows a user to post a tweet.
function tweet(string memory _content) public {
    //create tweet
    _tweet(msg.sender, _content);
}


//4. tweet(address _from, string memory _content): Allows an operator to post a tweet on behalf of a user.
function tweet(address _from, string memory _content) public {

//check first is permission 


}



}