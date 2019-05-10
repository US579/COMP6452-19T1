# COMP6452-19T1

## how to install

`npm install --save mocha ganache-cli truffle-hdwallet-provider@0.0.3 solc@0.4.18 web3@1.0.0-beta.35 `

* Install npm first by using command 

`pip install npm`

## Assignment1

the voting smart contract

Mark: 12.5/12.5

## Assignment2

ATAM analysis

Mark: 11.5/12.5

# Review
### week 1 Introduction
1.Data privacy
* no privileged users
* 在privacy和transparency之间做出了tradeoff

2.Scalability
需要与其他节点同步所以吞吐量较小
* Latency of data transmission 
* write latency 应为要同步(propagation)
* 每个块里面交易的大小
* 提交和确认之间的延迟 

我们有两种

1.permission-less blockchain 

2.permissioned  blockchain

有一个authority来充当看门的大爷,不是所有人都可以access,通过大爷确认后才能加入网络

* 这种blockchain 适合于regulated industries
* The suitability of a permissioned blockchain may also depend on the size of the network.
* the permission management mechanism may itself become a potential single point of failure, not just operationally but also from a business perspective.

举个🌰

如果用permission-less的话,if banks are required to establish the real-world 

identity,跨辖区边界的免许可区块链可以绕过这一点并破坏监管控制。


- zero-knowledge proof 
In cryptography, zero knowledge proofs let you convince me that you know something, or have done something, without revealing to me what your secret thing was.

* Logging into a website: rather than typing your password into a potentially unsafe website, you can simply send a proof that you “know your password”.

类似于利用私钥加密,然后用私钥加密后的信息来证明,这个人就是自己

下面举了两个🌰

1.supply chain

将blockchain应用于supply chain的好处
*  Ensure ownership, right to sell, etc are handled correctly
*  Reduce financial risk

2.Money Transfers
* 交易速度快
* 手续费少

### week 2 Existing Blockchain Platforms

Cryptography basics

1.公钥私钥加密

用私钥签名,签名可以authentication(只要公钥能够解密)

2.用hash algorithm(MD5,SHA)

Bitcoin

* Total supply: 21 million
* 在2016年开始的时候,incentive 是 50 BTC (reward for the miner)
* The reward is halving every 210,000 blocks.

1.Linked list with hash pointer

类似于linked list,后一节点的block里包含有前一节点的hash value,而第一个block叫block 0 (Genesis block)

2.Merkle tree

用Tree的数据结构来存储transcation的hash vlaue

这样可以在检查个别的hash时可以减少计算量,compare to the Hash list 

Ps : 这两个结构是在一起的,想象linked list的每一个块里面包含了很多transcations,而这些transaction用一个Merkle 

tree来保证intergrity.



