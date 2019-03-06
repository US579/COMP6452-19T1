pragma solidity ^0.4.22;

/// @title 委托投票
contract Ballot {
    // 这里声明了一个新的复合类型用于稍后的变量
    // 它用来表示一个选民
    
    uint private quorum = 4;
    uint count=0;
    
    bytes32[] public arr;

    struct Voter {
        uint weight; // 计票的权重，也就是票数
        bool voted;  // 若为真，代表该人已投票
        uint vote;   // 投票提案的索引
    }

    // 提案的类型
    struct Proposal {
        bytes32 name;   // 简称（最长32个字节）
        uint voteCount; // 得票数
    }

    address public chairperson;



    // 这声明了一个状态变量，为每个可能的地址存储一个 `Voter`。
    // 有权利投票的用户map
    mapping(address => Voter) public voters;

    // 一个 `Proposal` 结构类型的动态数组
    // 投票提案数组
    Proposal[] public proposals;

    // 为 `proposalNames` 中的每个提案，创建一个提案对象
    // 合约的构造函数，用constructor标识
    function add_proposal(bytes32[] proposalNames) public {
        // 合约的构造者为chairperson
        chairperson = msg.sender;
        // 赋予投票的权利
        voters[chairperson].weight = 1;
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

    // 授权 `voter` 投票的权利
    // 只有 `chairperson` 可以调用该函数。
    function giveRightToVote(address voter)  public {
        // 若 `require` 的第一个参数的计算结果为 `false`，
        // 则终止执行，撤销所有对状态和以太币余额的改动。
        // 在旧版的 EVM 中这曾经会消耗所有 gas，但现在不会了。
        // 使用 require 来检查函数是否被正确地调用，是一个好习惯。
        // 你也可以在 require 的第二个参数中提供一个对错误情况的解释。
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
       // require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    

    /// 把你的票(包括委托给你的票)，
    /// 投给提案 `proposals[proposal].name`.
    function vote(uint proposal) public {
        for (uint p = 0; p < proposals.length; p++) {
            count += proposals[p].voteCount;
            }
        require(count < quorum,"exceed quorum");
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;
        // 如果 `proposal` 超过了数组的范围，则会自动抛出异常，并恢复所有的改动
        proposals[proposal].voteCount += sender.weight;
    }
    
    
    
    function fab() public view returns(bytes32[]){
       for (uint p = 0; p < proposals.length; p++){
            arr.push(proposals[p].name);
        }
        return arr;
    }
    
    


   function winningProposal() public view
            returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    // 调用 winningProposal() 函数以获取提案数组中获胜者的索引，并以此返回获胜者的名称
    function winnerName() public view
            returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }
}