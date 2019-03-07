pragma solidity ^0.4.22;

/// @title 委托投票
contract Ballot {

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

    // 提案的类型
    struct Proposal {
        bytes32 name;   // 简称（最长32个字节）
        uint voteCount; // 得票数
    }

    address public creator;

    // 这声明了一个状态变量，为每个可能的地址存储一个 `Voter`。
    mapping(address => Voter) public voters;

    // 一个 `Proposal` 结构类型的动态数组
    Proposal[] public proposals;

    /// 为 `proposalNames` 中的每个提案，创建一个新的（投票）表决
    function add_proposal(bytes32[] proposalNames) public {
        creator = msg.sender;
        voters[creator].weight = 1;
        //对于提供的每个提案名称，
        //创建一个新的 Proposal 对象并把它添加到数组的末尾。
        for (uint i = 0; i < proposalNames.length; i++) {
            // `Proposal({...})` 创建一个临时 Proposal 对象，
            // `proposals.push(...)` 将其添加到 `proposals` 的末尾
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }
    
    //nput the  number of quorum
    function getQuorum(uint quorum_){
        require(msg.sender == creator);
        quorum = quorum_;
    }
    
    // 授权 `voter` 对这个（投票）表决进行投票
    // 只有 `chairperson` 可以调用该函数。
    function giveRightToVote(address voter) public {
        // 若 `require` 的第一个参数的计算结果为 `false`，
        // 则终止执行，撤销所有对状态和以太币余额的改动。
        // 在旧版的 EVM 中这曾经会消耗所有 gas，但现在不会了。
        // 使用 require 来检查函数是否被正确地调用，是一个好习惯。
        // 你也可以在 require 的第二个参数中提供一个对错误情况的解释。
        require(
            msg.sender == creator,
            "Only creator can add friends to voter."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    //get how many choices in the vote pool
    function fetch_proposals_len() private view returns(uint num){
        num = proposals.length;
    }

    // function for calculating the number of the voting so far and return the sum
    function sumall() public view returns (uint) {
        uint S;
        for(uint i;i < proposals.length;i++){
            S += proposals[i].voteCount;
        }
        return S;
    }
    
    /// 把你的票(包括委托给你的票)，
    /// 投给提案 `proposals[proposal].name`.
    function vote(uint proposal) public {
        require(sumall() < quorum,'exceed quorum,vote terminate' );
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;
        // 如果 `proposal` 超过了数组的范围，则会自动抛出异常，并恢复所有的改动
        proposals[proposal].voteCount += sender.weight;
        //if the number of the voting is equal to the quorum , ended is true , so creator can destory contract
        if (sumall() ==  quorum){
            ended = true;
        }
    }
    
    //list all the choices added by the creator
    function list_all_choices() public view 
        returns(bytes32[]){
       for (uint p = 0; p < proposals.length; p++){
            arr.push(proposals[p].name);
        }
        return arr;
    }
    
    /// @dev 结合之前所有的投票，计算出最终胜出的提案
    function getResult() public view returns(uint[],bytes32[]){
         for (uint p = 0; p < proposals.length; p++) {
             arrVote.push(proposals[p].voteCount);
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