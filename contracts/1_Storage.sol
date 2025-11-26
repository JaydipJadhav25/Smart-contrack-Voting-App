// SPDX-License-Identifier: MIT




pragma solidity ^0.8.26;




contract Vote {

  //1
    struct Voter {
        string name;
        uint age;
        uint voterId; // personal id
        Gender gender;
        uint voteCandidateId; //candidateId 
        address voterAddress;
    }

  //2
    struct Candidate {
        string name;
        string party;
        uint age;
        Gender gender;
        uint candidateId;//personal id
        address candidateAddress;
        uint votes; // number of votes
    }

    //3
    address public  electionCommission;

    address public winner;

    uint nextVoterId = 1;
    uint nextCandidateId = 1;

    //voter periode
    uint startTime;
    uint endTime;
    bool stopVoting;


    mapping(uint => Voter) voterDetails;
    mapping(uint => Candidate) candidateDetails;


    enum VotingStatus {NotStarted, InProgress, Ended}
    enum Gender {NotSpecified, Male, Female, Other}


    constructor() {
      electionCommission = msg.sender;
    }


    modifier isVotingOver() {
      require(block.timestamp <= endTime && stopVoting == false, "voting time is over!");
      _;
    }


    modifier onlyCommissioner() {
      require(msg.sender == electionCommission , "not Authorized!");
        _;
    }

    modifier checkAgeLimit(uint _age){
    require(_age >= 18,"you are below 18 !");
      _;
    }


    function registerCandidate(
        string calldata _name, // read-only refernces data / location
        string calldata _party,
        uint _age,
        Gender _gender
    ) external checkAgeLimit(_age) {

      //check ccodition
      require(isCandidateNotRegistered(msg.sender) , "candidate already registed!");
      require(nextCandidateId < 3, "candidate registered fulled!");
      require(msg.sender != electionCommission , " you are electionCommision , is not allowed");
      //stor in mapping
      candidateDetails[nextCandidateId] = Candidate(
        _name,
       _party,
        _age,
        _gender,
         nextCandidateId,
          msg.sender,
          0
          );
          nextCandidateId++; 
    }


    function isCandidateNotRegistered(address _person) internal view returns (bool) {
           //to chedck candidateis exsiting or not
           for (uint i = 0; i <nextCandidateId; i++) 
           {
            if(candidateDetails[i].candidateAddress == _person){
              return  false;
            }            
           }
           return  true;
    }

    //  string name;
    //     string party;
    //     uint age;
    //     Gender gender;
    //     uint candidateId;//personal id
    //     address candidateAddress;
    //     uint votes; // number of votes

   //convert into dynamix array
    function getCandidateList() public view returns (Candidate[] memory) {
        Candidate[] memory allCanditates = new Candidate[](nextCandidateId-1);
        //add data in array
        for (uint i = 0 ; i < allCanditates.length ; i++) 
        {
          allCanditates[i] = candidateDetails[i+1];
        }
        return  allCanditates;
    }


    function isVoterNotRegistered(address _person) internal view returns (bool) {

         for (uint i =0; i < nextVoterId; i++) 
         {
           if(voterDetails[i].voterAddress == _person) return false;
         }
         return  true;

         
    }


    function registerVoter(
        string calldata _name,
        uint _age,
        Gender _gender
    ) external checkAgeLimit(_age) {

      require(isVoterNotRegistered(msg.sender) , "Voter already registed!");

      //stor data in regiter struch in mappin
      voterDetails[nextVoterId] = Voter(
        {
          name : _name,
          age : _age,
          voterId : nextVoterId,
          gender : _gender,
          voteCandidateId : 0,
          voterAddress : msg.sender
        }
      );
      nextVoterId++;

    }


    function getVoterList() public view returns (Voter[] memory) {
      Voter[] memory allVoters = new Voter[](nextVoterId -1);
      for (uint i =0 ; i < allVoters.length;i++) 
      {
        allVoters[i] = voterDetails[i+1];
      }

      return allVoters;
    }


    function castVote(uint _voterId, uint _candidateId) external {
      //check voter is persend of not
      require(voterDetails[_voterId].voterAddress == msg.sender , "You aare not authourtherized!");
      require(voterDetails[_voterId].voteCandidateId == 0 , "You are already voted!");
      require(_candidateId >= 1 &&_candidateId <3 , "candidateId is Wreong" );
    //now add vote
    voterDetails[_voterId].voteCandidateId = _candidateId; //candidate id
    candidateDetails[_candidateId].votes ++; //candidae vote update
    }


    function setVotingPeriod(uint _startTime, uint _endTime) external onlyCommissioner() {   
      // require(_startTime < _endTime , "invalida time");
      require(_endTime >3600 , "aleast must be 1 houres");
      startTime = block.timestamp + _startTime; //starttime =0  endtime=3600
      endTime = startTime + _endTime;
    }


    function getVotingStatus() public view returns (VotingStatus) {
       if(startTime == 0){

        return VotingStatus.NotStarted;

       }else if(endTime > block.timestamp && stopVoting == false){

        return  VotingStatus.InProgress;

       }else{

        return  VotingStatus.Ended;

       }
    }


    function announceVotingResult() external  onlyCommissioner() {
      uint  max = 0;
      //flow -> loop on mapping and checks all data
        // Candidate[] memory allCanditates = new Candidate[](nextCandidateId-1);
        //add data in array
        for (uint i = 1 ; i < nextCandidateId ; i++) 
        {
          //check max
          if(candidateDetails[i].votes > max){
            //this is winner
            winner = candidateDetails[i].candidateAddress;
            max =  candidateDetails[i].votes;
          }

        }      
    }


    function emergencyStopVoting() public onlyCommissioner() {
       stopVoting = true;
    }
}











