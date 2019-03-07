pragma solidity ^0.4.22;

/// @title Poll Smart Contract 
contract Poll {

    bytes32[] public arr;
    bool public ended;
    uint public quorum;
    uint[] public arrVote;


    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single voter.
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

    address public creator;

    // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;

    // A dynamically-sized array of `Choice` structs.
    Choice[] public choices;

    /// 为 `proposalNames` 中的每个提案，创建一个新的（投票）表决
    function add_proposal(bytes32[] ChoiceNames) public {
        creator = msg.sender;
        voters[creator].weight = 1;
        for (uint i = 0; i < ChoiceNames.length; i++) {
            choices.push(Choice({
                name: ChoiceNames[i],
                vcount: 0
            }));
        }
    }

    //nput the  number of quorum
    function getQuorum(uint quorum_){
        require(msg.sender == creator);
        quorum = quorum_;
    }

    // Give `voter` the right to vote on this poll.
    // only  `chairperson` can implements this function
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
    function sumall() public view returns (uint) {
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

    function getResult() public view returns(uint[],bytes32[]){
        for (uint p = 0; p < choices.length; p++) {
            arrVote.push(choices[p].vcount);
        }
        return (arrVote,list_all_choices());
    }

    //destory contract after poll terminate
    function destory_contract() public {
        require(ended,"Contract only can be destoryed after poll");
        require(msg.sender == creator,"Only cractor can destory the Contract");
        selfdestruct(msg.sender);
    }
}