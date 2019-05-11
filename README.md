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

Author : Wanze Liu
___

## WEEK 1 Introduction

***1.Data privacy***
* no privileged users
* 在privacy和transparency之间做出了tradeoff

***2.Scalability***

需要与其他节点同步所以吞吐量较小

* Latency of data transmission 
* write latency 应为要同步(propagation)
* 每个块里面交易的大小
* 提交和确认之间的延迟 

我们有两种

***1.permission-less blockchain***

***2.permissioned  blockchain***

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

***1.supply chain***

将blockchain应用于supply chain的好处
*  Ensure ownership, right to sell, etc are handled correctly
*  Reduce financial risk

***2.Money Transfers***
* 交易速度快
* 手续费少

## WEEK 2 Existing Blockchain Platforms

***Cryptography basics***

### Bitcoin

***1.公钥私钥加密***

用私钥签名,签名可以authentication(只要公钥能够解密)

***2.用hash algorithm(MD5,SHA)***

* Total supply: 21 million
* 在2016年开始的时候,incentive 是 50 BTC (reward for the miner)
* The reward is halving every 210,000 blocks.

***1.Linked list with hash pointer***

类似于linked list,后一节点的block里包含有前一节点的hash value,而第一个block叫block 0 (Genesis block)

***2.Merkle tree***

用Tree的数据结构来存储transcation的hash vlaue

这样可以在检查个别的hash时可以减少计算量,compare to the Hash list 

Ps : 这两个结构是在一起的,想象linked list的每一个块里面包含了很多transcations,而这些transaction用一个Merkle,所以每个block中都包含有一个Merkle tree

`tree来保证intergrity.`

***3.Store unspent transaction outputs (UTXO)***

这是一种表示账户余额的方式 :  the sum of UTXO 

现实中一般我们都会用coinbase的形式来表示,就是直接会显示余额在账户里面

因为 The Bitcoin blockchain platform has exactly two first-class elements: transactions and blocks. 

而UTXO是利用账单状态(spent)(unspent)来代表账户中的余额

* The account balance is therefore derived as the sum of unspent transaction outputs 

Ps: 在 Ethereum’s account/balance model里面every node has access to the full transaction history and thereby knows which account holds how much currency. 所以这里用的不是UTXO (这里account是匿名的)

***4.Orphan***

```
mempool: 保存transcation的地方
parents: referenced input transaction
```
Orphan : 没有找到父区块的区块。 在比特币协议中，最长的链被认为是绝对的正确。 如果一个块不是最长链的一部分，那么它被称为是“孤块”。

***5.Locktimes***

是用来设定a transaction can contain a parameter declaring it invalid until the block with a certain sequence number has been mined.

***6.Script***

Bitcoin是用script system来进行交易的

locking script: 是对output进行规则制定的,只有满足这些规则才能output

unlocking script : 是对input进行规则制定的,只有满足这些规则才能input(包含了发送方的siginature and public key)

To validate a transaction, the unlocking script and the locking script are combined and executed. If the result is true, the transaction is valid.

这里用stack的方法来解释Script – Stack-based Execution`ppt33`

上面总共做了两次检查:

1.检查公钥是否来自他所声称的那个人

2.检查签名(authentication)

` opcode: used to mark a transaction output as invalid.`


Script programs 不能引入外部状态, 但oracle可以(这个在后面会讲到,考试会考oracle pattern)

***7.Mining***

`Miners are always listening for new transactions and new blocks`

`core concept : 就是找到一个nonce,能够使得candidate计算出来的value等于blockchain设置的那个,然后把这个nonce加到block header里进行全网广播`


1.miner会监听所有的到达它这个node点的transcation,然后先通过Script中的locking unlocking script 来检查transcation的validity,通过了就放进mempool中,然后在propagate到网络中,使得其它node也能够同步.

2.对于miner来说,新到的block意味着,这轮已经有人比自己先解开puzzle(试出来那个nonce)并进行广播了,这时候就需要将new block中的transcation从自己的mempool中删除(因为这些transcation已经被别人打包且生成块了),然后在重新生成candidate block,计算Merkle,重新mining(计算nonce)

Ps:在每一次生成candidate的开始,有一笔coinbase transcation应该囊括其中,就是incentive,然后再把其他的交易包含进来(这样做的目的就是如果成功的mine到了这个块,奖励也就自动发放给miner了)


Once a solution is found, the result is inserted into the block header, and the new block is immediately propagated to the network. 


***8.Nakamoto Consensus***

1.Treat the longest history of blocks as the main chain

(有可能会出现同时解出nonce的情况,然后同时广播,但由于propgate需要时间,不同node之间到达的顺序并不一样,就有可能出现有的长有的短,但只有最长的那个是valid的)

2.wait for several blocks (5 blocks by default) to be added after first inclusion of the transaction

 `这种方法叫: X-Confirmation`

Commit only has a probabilistic guarantee(这里是说commit了但不能保证成功,需要等到5个块以后才算交易成功,因为有可能你commit的那个块不是最长链的一部分)

(等待5个块后,这个块才算是confirm了)

***9.Wallets and Exchanges***

1.wallet 就是保存了私钥在里面


### Ethereum

* Shorter inter-block time: 13-15 seconds (Bitcoin: 10 mins)
* Smaller blocks

   At most 380 transactions in a block (Bitcoin: 1,500 txs/block)

   Most blocks are under 2KB (Bitcoin: 1 MB)

* GHOST protocol (Greedy Heaviest Observed Subtree)

   The heaviest chain wins and uncles contribute to the weight(孤块在这里是叔块,且最重的链为有效链)

* smart contract

	use gas

	Code is deterministic and immutable once deployed

	Can invoke other smart contracts


为啥smart contract 是可以信赖的???

1.contract 的部署方式是以data的形式部署的,所以是无法改变的

2.code是deterministic

3.code的运行结果也是需要consensus来验证的,如果不一样会reject


## WEEK 3

### Taxonomy

一种科学的方法来分析不同blockchain之间的区别

***1.中心化***

* 完全中心化

   政府,法院,商业垄断


* 部分去中心化
    
    找一个看门大爷来给与进入网络的权利

***2.ledger structure***

* list

	Blockchain is a list of blocks under the logical view from a user’s perspecEve

* tree
	
	树状结构的blockchain

	   在bitcoin里有些分支会被丢弃,找最长的一个链
	   
	   在Ethereum里找叔块最多的一个树结构


***3.Consensus Protocol***

1. POW

用穷举的方法试出nonce,使得得到的hash vlaue和blockchain系统设置的要求有相同数目的0

2. POS

在这里资产的拥有量和被选为下一个miner的可能性成正相关,就是说资产越多,越有可能选为下一个miner

3.PracLcal ByzanLne Fault Tolerance (PBFT)

所有的副本组成的集合使用大写字母R表示，使用0到|R|-1的整数表示每一个副本。为了描述方便，通常假设故障节点数为f个，整个服务节点数为|R|=3f+1个，f是有可能失效的副本的最大个数。尽管可以存在多于3f+1个副本，但额外的副本除了降低性能外不能提高可靠性。


4. Bitcoin-NG

新的一种共识机制,能够缩短commit时间,同样用POW算法,但是是选出一个leader来进行确认transcation,只要有交易记录进来就放进mircoblock中立即进行广播


***4.Taxonomy Dimensions***

1.Gas limit (Ethereum): Limit the complexity of the contained transacEons

#### block size

1. 增大block size会导致Dos

	Flooding system with transacEons such that the block Eme interval is high

2. High block size increase the risk of empty blocks

	A tries to include many transactions and miner B tries to mine empty blocks. While A is processing transactions, B is already working on its proof-of-work, thereby increasing its relative chances to find a new block first. 

	It is economical to mine as many empty blocks as possible

	因为块size太大的话,在认证transcation是否合法上会花费很多时间,而mine空块的话,不需要认证,可以直接进行mining,这样就在时间上占据优势


3. Standard block propagaLon/Extreme Thinblock propagaLon



4. sidechain

侧链协议是指：可以让比特币安全地从比特币主链转移到其他区块链，又可以从其他区块链安全地返回比特币主链的一种协议。


* Problem

	1. Main chain can never be 100% sure if a sidechain transaction has been accepted by the
	network

	2. Neither does sidechain


5. Sharding 

Sharding means to divide the state of blockchain into pieces. The participating blockchain nodes only hold data of some shards instead of the complete blockchain data structure. There are two types of sharding, including:

* transaction sharding 
* state sharding

就是每个node不存储整个state,而是存储一部分transcation信息或者state信息

6. Incenctive

-  Join the network
-  Validate transacations
-  Generate blocks
-  Execute smart contract


## WEEK 4 Software Architecture 

### NFPs and design trade-offs

What is Software Architecture?

- Components, Connectors, Configuration
- Non-Functional Properties (NFPs)
- Models: Views and Viewpoints
- NFP Analysis and Trade-offs

Blockchain as Component, Connector, Configuration


**There are two kinds of requirements:**

* 1. Functional Requirements

	what are the inputs and outputs

* 2. Non-Functional Requirements

	Qualities

		“Performance” (latency, throughput, ... )

		“Security” (confidentiality, integrity, availability, privacy, ...)

		"avaiablity"

		"modifiablity" (flexibility)


***Non-Functional Properties arise from Architectural Design Choices***


1. ATAM: Architecture Trade-off Analysis Method

2. Two ways of storing data on blockchain:
	* Adding data into transactions
	* Adding data into contract storage

• Both ways store data through submitting transactions 
- Contain information of money transfer
- Together with optional other data

### Oracle

Summary Introducing the state of external systems into the closed blockchain execution environment.

因为blockchain本身只能执行很简单的逻辑操作,要想实现复杂的功能,就得要引进外部系统(external systems)

more detials : book p127

### Asset Management and Control Mechanism

1. Native token of the 1st generation of blockchain
	
	* 本地存储加密货币
	* 用加存储的加密货币data来代表加密货币
	* 由于存储空间有限,只能存储少量数据

2. Smart contract of the 2nd generation of blockchain
	* 可以存储高级数据结构
	* Flexibility for tokenizing a wider variety of assets

### Tokens

tokens 可以看做一个ticket,谁有这个ticket谁就能拥有这个ticket下的财产,如果你破产了,法院可以强制转换这个ticket的所有者

有两种token standards
• ERC20 for fungible tokens
• ERC841 for non-fungible tokens

注意: 有可以取代和不可取代两种


## WEEK 5 Design Process for Applica1ons on


**Evalua1on of Suitability**

1. Trusted authority is a single point of failure

在centrilize的authority中,如果他们的服务垮了,那么全部用户都会受到影响,这就是a single point of failure,但是这可以通过data redundancy来解决,就是一个挂了,还有另一个来服务(Technical single points of failure can be mitigated by using redundancy in conventional distributed systems architectures. ) 然而, 这只针对的是a single point of failure in `system`,如果是在 single points of organizational or business failure 就无解了.

2. Mul1-party Required

3. Trusted Authority Required

4. Is operation centralized?

5. Is Immutability Required?
	* Immutability of PoW-based blockchain is a long-run `probabilistic` durability
	* Blockchain using other consensus mechanism can offer stronger and more conventional immutability(例如拜占庭容错)

6. Is High Performance Required?
	* 高性能不是blockchain的属性,因为他比较慢(⚡️)
	* 和传统数据库的性能没法比
	
	但是....

	* 读取数据很快
	* 无网络延迟(因为每一个节点本地都包含所有数据)

	* 写就是一个不确定因素了,之前提过,因为区块链的commit是probabilistic的
	* Network delay of transaction propagation
	* Consensus process delay
	* Confirmation blocks on PoW-based blockchain increases write latency

7. Is Transparency Required?







