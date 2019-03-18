pragma solidity ^0.4.22;

///contract address: 0xEBfd3872143AF032D2df23019d03cf7797A37c7C
///initial with quorum == 3

/// @title Poll Smart Contract
contract Poll {
    //the array stores all the chonices name which provided the person who call the `list_all_choice` function
    bytes32[] private arr;
    //the variable represent whether the poll finised
    bool private ended;
    //the variable represent the max votes
    uint private quorum;
    //the array to store votes
    uint[] private arrVote;

    
    //the struct represent a single Voter.
    struct Voter {
        uint weight; // weight is accumulated by delegation
        bool voted;  // if true, that person already voted
        uint vote;   // index of the voted choices
    }


    // the details of choice
    struct Choice {
        bytes32 name;   // choice name（32bytes）
        uint vcount; // the number of vote
    }
    
    //the address of the depolyer
    address private creator;

    // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) private voters;

    // A dynamically-sized array of `Choice` structs.
    Choice[] private choices;

    //allow depolyer to add more choices.
    function add_chocies(bytes32[] ChoiceNames) public {
        creator = msg.sender;
        voters[creator].weight = 1;
        for (uint i = 0; i < ChoiceNames.length; i++) {
            choices.push(Choice({
                name: ChoiceNames[i],
                vcount: 0
            }));
        }
    }

    //input the number of quorum when deplying the contract, initial with 0
    constructor (uint quorum_) public {
        quorum = quorum_;
    }

    // Give voter the right to vote on this poll.
    // only chairperson can implements this function
    function giveRightToVote(address voter) public {
        require(msg.sender == creator,"Only creator can add friends to voter." );
        require(!voters[voter].voted,"The voter already voted.");
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    //get how many choices in the vote pool
    function fetch_choices_len() private view returns(uint num){
        num = choices.length;
    }

    // function for calculating the number of the voting so far and return the sum
    function sumall() private view returns (uint) {
        uint S;
        for(uint i;i < choices.length;i++){
            S += choices[i].vcount;
        }
        return S;
    }


    function vote(uint choice) public {
        require(sumall() < quorum,'exceed quorum,vote terminate' );
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = choice;
        choices[choice].vcount += sender.weight;
        //if the number of the voting is equal to the quorum , ended is true , so creator can destory contract
        if (sumall() ==  quorum){
            ended = true;
        }
    }

    //list all the choices added by the creator
    function list_all_choices() public view
    returns(bytes32[]){
        for (uint p = 0; p < choices.length; p++){
            arr.push(choices[p].name);
        }
        return arr;
    }
    //function to get poll result so far(this is the second methods to get result)
    function getResult2() private view returns(uint[],bytes32[]){
        for (uint p = 0; p < choices.length; p++) {
            arrVote.push(choices[p].vcount);
        }
        return (arrVote,list_all_choices());
    }
    
    //function to get poll result so far
    function getResult() external view returns (bytes32[] memory name, uint[] memory vcount) {
        name = new bytes32[](choices.length);
        vcount = new uint[](choices.length);
        for(uint i = 0; i<choices.length;i++) {
            name[i] = choices[i].name;
            vcount[i] = choices[i].vcount;
        }
    }
    
    //destory contract after poll terminate
    function destory_contract() public {
        require(ended,"Contract only can be destoryed after poll");
        require(msg.sender == creator,"Only cractor can destory the Contract");
        selfdestruct(msg.sender);
    }
}