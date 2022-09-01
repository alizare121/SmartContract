// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract Vote {
    // state variable
    address public owner;
    enum state {notStarted , Started , Finished}
    state public currentState;
    struct candidate {
        uint8 id;
        string name;
        uint voteCount;
    }
    mapping(uint8=> candidate) public candidates;
    mapping(address => bool) public voters;
    uint8 public candidateNumber;

    // error functions:


    // modifiers : 

    modifier inState(state _state) {
        if(currentState != _state)
        revert("invalid state");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner , "only owner can call this function!!");
        _;
    }

    modifier alreadyVoted() {
        if(voters[msg.sender])
        revert("the voter has already voted !!");
        _;
    }

    modifier candidateNotFound(uint8 _id) {
        if(_id > candidateNumber -1)
        revert("candidate not found !!");
        _;
    }

    // events :
    event winner(uint8 winnerid , uint winnervote); 


    // constructor : 

    constructor() {
        owner = msg.sender;

    }


    // functions : 

    function changeStete(uint8 s) public onlyOwner {
        if(s == 0){
            currentState = state.notStarted;
        } if (s == 1) {
            currentState = state.Started;
        } else {
            currentState = state.Finished;
        }
    }

    function addCandidate(string memory name) public onlyOwner inState(state.notStarted) returns(string memory){
        candidates[candidateNumber] = candidate(candidateNumber , name , 0);
        candidateNumber ++ ;
        return "add condidate successfully";
    }

    function vote(uint8 _id) public inState(state.Started) alreadyVoted candidateNotFound(_id) returns(string memory){
        candidates[_id].voteCount ++ ;
        voters[msg.sender] = true;
        return "vote is successfully";
    }

    function finalWinner() public inState(state.Finished){
        uint8 winnerid;
        uint winnervote;
        for(uint8 i=0; i < candidateNumber; i++){
            if(candidates[i].voteCount > winnervote){
                winnerid = i;
                winnervote = candidates[i].voteCount;
            }
        }
        emit winner(winnerid , winnervote);

    }

}