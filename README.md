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

# Review     🤪 

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

(现实中一般我们都会用coinbase的形式来表示,就是直接会显示余额在账户里面)

但是比特币中所有挖到的块第一笔交易是coinbase的,这是miner根据当前的奖励金额自己加到自己block里面的,只要block成为有效块,奖励就会到miner的账户里(注意,这个时候bitcoin中的总比特币就会增加,而且这比coinbase交易是没有input的只有output,这个output就是unspent transcation✨)

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

   * The heaviest chain wins and uncles contribute to the weight(孤块在这里是叔块,且最重的链为有效链)
   * https://segmentfault.com/a/1190000017411084
   ![image text]https://github.com/US579/COMP6452-19T1/image/uncle)

* smart contract

	* use gas

	* Code is deterministic and immutable once deployed

	* Can invoke other smart contracts


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

新的一种共识机制,能够缩短commit时间,同样用POW算法,但是是选出一个leader来进行确认transcation,只要有交易记录进来就放进microblock中立即进行广播


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

2. Multi-party Required

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
* Data transparency means data is available and accessible to by other parties
* Blockchain provides a neutral plamorm where all participants can see and audit

8. Three cases
* Supply Chain
* Electronic Health Records
   *  blockchain can not used to store patient records, even in encrypted form

  问题: 既然不能存患者信息,那health record里面应该存什么?

  不在链上存储患者信息,将patient records存在auxiliary database里面,只在链上存储hash(logs of accesses)或者是E(logs of accesses)

  MedRec stores a pointer to patients’ data in the blockchain and allows patients to choose when and with whom to share their data.

* Identity Management

   * plaintext identity information for users is not normally stored directly on a blockchain. 

* Stock Market 
   * blockchain technology might not be suitable for this use case until the performance of blockchain can match up with current conventional technologies. (主要是能够实时更新)


9. Design Process for Blockchain-based Systems

* Trade-off Analysis
   * Encrypting data before storing it on a blockchain
      * 提高confidentiality,降低performance
   * Storing only a hash of data on-chain and keeping the contents off-chain
      * 提高confidentiality and performance
      * undermine the benefit of blockchains in providing distributed turst
      * single point of failure

   * Using private blockchain instead of public blockchain
      * 不是fully 去中心化了

   * Higher number of confirmation blocks
      * 提高了对交易的可信度
      * 很高的延迟



* 存储数据的方式
   * Raw data off-chain
   * On-chain just meta-data, small critical data and hashes of the raw data

* Store data in Bitcoin
   * OP_RETURN (limited to 40 bytes,四种)
      * writing in a coinbase transaction
      * using the nSequence field
      * using a fake account address
      * using unreachable script code defined through if and else conditions

* Store data in Ethereum
   * Storing arbitrary data in transaction
      * Transaction size is limited by the maximum size of a block

   * Storing data in smart contract
      * As `variable` in a smart contract
      * As `log event` of smart contract
      * Variable is more efficient to manipulate, but less flexible due to the constraints of language


#### Computation

* Bitcoin only allows simple scripts and conditions
* Ethereum provides a Turing complete programming language
* Benefit of on-chain computation
   * Immutability of the program code once deployed
   * Neutrality of execu=on environment
   * Inherent interoperability among the systems built on the same blockchain network

10. Cost

* Storing Data in Smart Contract
   * 1 sstore operation 花费2000,从 zero 到 non-zero
   * Every transaction has a fixed cost of 21,000 gas
   * Data payload costs extra gas(68 per byte,总共32bytes in total)

* Storing data as a log event in a smart contract
   * 1 log topic costs 375gas
   * Every byte of data costs an extra 8 gas
   * Transaction as the carrier costs a base 21,000 gas

* Contract Creation Cost
C_create = transcation cost(21000) + allocating address cost(32000) +  the function definition cost + payload (in bytes) × C_gas/byte

payload cost : 
   * 68 gas/non-zero byte
   * 4 gas/zero byte
   * 200 gas/contract byte


contract里面还可以创建contract,这时候就不需要transcation cost了

11. SWF(Simple Workflow Service) provided by AWS


need to know : 什么是SWF?

Amazon Simple Workflow Service (Amazon SWF) 可轻松的用于构建在分布式组件上协同工作的应用程序。在 Amazon SWF 中，一个任务表示的是由您的应用程序组件所执行之工作的一个逻辑单位。跨越应用程序协作任务依据应用逻辑流程涉及有任务间依赖关系的管理、排定和并发性协调。Amazon SWF 可使您完全控制任务的执行和协作，无需担心跟踪任务进度和维持任务状态等底层复杂性。

***Base Cost of Workflow Instance***
* cost = instance的数量 *  每个instance的单价

***Cost of Scheduling Tasks***
* cost = (activity tasks的数量 + decision tasks的数量) * 每个task的单价

***Cost of Signals***
* cost =  signals * 每个signal的单价

***Cost of Data Retention and Transfer***
* cost_Retention = (user规定的时间 + workflow执行的时间) * 单位价格
* cost_transfer = payload * 每byte的单价

***Coordina1on Cost***

上面cost的sum

问题: swf 和 blockchain 有啥关系,为什么能比较,week5 ppt86

12. Cost vs. Maintainability

不同的deploy方式会影响cost

1. One smart contract with two functions
	* needs to pay transcation cost and address cost twice
	* 任意一个fun出问题,需要全部deploy,维护性差

2. Two smaller contracts, each implementing one function
	* 只用付一次transcation cost and address cost 
	* fun1 有问题可以只重新deploy 第一个contract

## WEEK6 Performance (NF2) 

### latency

不同的结构对latency的影响

1. gas控制结构

   * 降低脚本执行复杂度,latency减小

2. 选择不同的consensus algorithm

   * nakamoto consensus 有孤块出现的可能,虽然被include了,但也有可能被其他链超越


3. interblcok time
* 指的是txn到达miner开始  到  txn is observed in new block之间的时间

4. Predicting Latency

* For a single transaction on public blockchain
   * latency = 1.5 * interblock time
* For sequence of n > 1 transactions on public blockchain
   * latency = 1.5 * interblock time + (n-1) * 2 interblock time





Blockchains have high latency and high variability of latency
* Number of confirmation blocks are a risk-based decision
需要用x-confirmation(这里是指即使commit了,也不能完全确认,但要等带6个块以后,才确认(因为有可能其他链变成最长的,自己就会discard))



### Throughput

1. Transactions per block * blocks per second = Transactions per second

## WEEK 7 Dependability and Security (NFPs2)

1. Functionality

2. Security
* Integrity
* Confidentiality
* Non-repudiation
* Accountability
* Authenticity

	问题: Blockchain anomaly 是啥

	***double spending***

	你付了一个商家一比特币，然后马上再次签名，并把这一比特币发给另外一个地址。
	两笔交易都会到达一个待确认交易池。但是只有第一比交易可以得到确认，并且被矿工在下一个区块签名验证。你的第二币交易会被矿工判定无效，进而被从网络中删除。
	但如果两个矿工同时从待确认池取走了这两笔交易，那么拿到最多确认的交易讲会被记入账本，另一比将会被忽略.
	聪明的你可能会发现，这个做法对商家来说是不公平的，因为付给商家的交易有可能会被网络忽略或者回滚。这就是为什么，我们建议商家等待要至少六轮的确认。每轮确认都会有一个新的区块被加入到账本中。也就是说，商家要等待 6个新的区块被加入账本才能确保交易不会被回滚或是被修改，进而确定消费者无法发动双重支付。

3. Reliability

* Reliability
   * 在特定时间特定情况下,能不能实现特定的功能
* Availability
   * 当需要他的时候他在不在
* Recoverability
   * 从failure中恢复的能力
* Maturity
   * 在正常操作下,其reliability的程度
* Fault-Tolerance
   * 在系统出错情况下,其服务不failure


How to Abort a Transaction in Ethereum?

* send 0 Ether to yourself, or invoke a smart contract to raise an exception
* Higher fee means it has different hash value, so will be seen as “different”


we propose a mechanism to artificially abort Ethereum transactions by superseding them with an idempotent or counteracting transaction. (幂等或抵消交易,就是用相同的交易内容进行略微的修改,再次交易,是的两个交易发生冲突,回滚或者撤销其中一个,所以并不是能100%成功)


## WEEK 8 Architectural Patterns for Blockchain

```
神马是oracle?? 不是那个甲骨文数据库,这玩意在这里叫 预言机(🐔)

是 An oracle is a trusted third-party that provides smart contracts with information about the external world. 

就是一个能让外界与blockchain交互的类似于APi的东西
```
1. Centralized Oracle(考试重点)

* 一个外部系统可以和区块链这种封闭环境进行交互,Centralized Oracle就是这两个系统交互中间的api
   * context : 因为blockchain内部是immutable的once commited,但是有时候区块链需要和外界交互来验证transcation,因为外部状态是随时间而改变的.

   * problem
      * blockchain is a self-cotained execution environment(类似于沙盒)
      * smart contract are pure function that can not access from external system
   * solution
      * oracle会帮助分析不能在smart contract中expressed的情况
      * Oracle injects the result to the blockchain in a transaction signed using its own key pair(使用oracle的私钥签名)
      * Validation of transactions is based on the authentication of the oracle

   * pros
      * Connectivity : 与外界的联通性(就是说在验证的时候不是封闭环境了,可以在执行逻辑流的时候与外界信息进行交互验证,这可就提高了一个level啊)
   * cons
      * Trust: Oracle is trusted by all the participants (orcale 必须被所有的node信任才行)
      * Validity: External states injected into the transactions can not be fully validated by miners(外部状态的注入并不能被miner完全验证,因为外部状态信息的验证是有orcale来进行的,因为miner信任orcale,所有他也信任从orcale里获取的数据,但这也是一个vulnerablity)
      * Long-term availability and validity: 虽然说链上的信息是不可变得,但是在orcale里的信息是可变的,如果说信息已经onchain了,oracle里面的又变了,这就煞笔了.....


2. Decentralized Oracle 
	* problem
	  * A centralized oracle introduces a single trusted third party
	  * Centralized oracle is a single point of failure
	  * Variety of data sources
	* solution
	  * Decentralized oracle based on multiple servers and multiple data sources(多数据源多servers)
	  * Consensus on the external status(在oracle内部还有共识机制,对他们收集的data进行共识匹配)
	     * k-out-of-n property. A verifier can only be convinced that a signature was produced by the collaboration of at least k anonymous signers among n signers(就是在一个有n个人的group中如果至少有K个人签名了,这份签名就有效https://eprint.iacr.org/2018/728.pdf)

	* pros
	   * Risk is reduced from a single point of failure
	   * Improves the likelihood of gedng accurate external data
	* cons
	   * Time: Get required informaGon from mulGple data sources and reach a consensus for the final result
(time-consuming)
	   * Cost: increase with the number of oracles being used(多个server花费越多)
	   * Trust: All the oracles that verify the external state are trusted by all participants involved in transactions
	   问题: 都信任了为啥是drawback

3. Voting
* Voting is a method for a group of blockchain users of a decentralized oracle to make a collective decision or to achieve a consensus
   * Context
      * Public access of blockchain provides equal rights
      * Participant has the same ability to access and manipulate the blockchain
   *  Problem
      * Participants have different preference
   * 要voting的动机
      * Decentralization
      * Consensus
   * solution
      * Vote through sending transacGon through blockchain account
      * Voting transaction is signed by the private key
         * Represent the right to make decision(transcation就代表了投票)
         * Might be weighted by the owned resource(会根据每个人拥有的资源不同设置不同的投票比重)
   * pros
      * Equality: ParGcipants use their right to make decision
      * consensus: partcitipant with different opinions can reach consensus
   * cons
      * Collusion: (有人会一起合谋来获取利益)
      * Permission grant:匿名的设置可以让一个人注册多个账户,然后就拥有了更多的投票权
      * Time: Long voting/dispute time window(这个应该是如果有争议会很耗时)
      问题: 这个time到底指的是什么


### Data Management (4)

1. Encrypting On-chain Data

Ensure confidentiality of the data stored on blockchain by encrypting it
* context
   * Commercially critical data that is only accessible to the involved participants(在商业中不能啥数据都给别人看,需要加密)
   * Problem
     * Data privacy is a limitaGon of blockchain(blockchain生来就是透明的)

   * 动机
     * 只要是在blockchain上的就是谁都能看的,这可不行
     * 缺少机密性
   * solution
     * 给onchain data 加密
     * 用对称或者不对称秘钥加密

   * pros
      * 没有key没人能推出raw data
   * cons
      * key丢了,就没有办法保证机密性了
      * Access revocation: 永久可以访问加密信息(blockchain的性质immutable)
      * Immutable data: Subject to brute force decryption attack(永久都在链上的话,随着科技的发展,可能会有办法解密eg.
      量子计算机)
      * Key sharing: 谁有key谁就能看链上的信息

2. Off-chain Data Storage

Using hashing to ensure the integrity of arbitrarily large datasets

* Context
   * Using blockchain to guarantee the integrity of large amounts of data
* Problem
   * Limited storage capacity: 链上不能存储很多信息
   * Limited size of the block: Storing large amounts of data within a transacGon is impossible
      * Block gas limit in Ethereum
   * Data cannot take advantage of immutability or integrity guarantees without being stored on-chain(如果data不上链,那么就没办法发挥blockchian的优势来)

* Solution
   * Data of big size
      * Data that is bigger than its hash value
   * Hash value of the data is stored on blockchain

* pros
   * Integrity
      * Blockchain guarantees integrity of the hash value
      * Hash value guarantees integrity of the raw data
   * Cost: Fixed low cost for integrity of data with arbitrary size
* cons
   * Integrity
      * Raw data might be changed without authorization(只要存在链下就有被篡改的可能)
      * Detectable but unrecoverable(虽然能发现,但是不能恢复)
   * Data loss: Off-chain raw data may be deleted or lost

3. State Channel
Micro-payments exchanged off-chain and periodically recordingse Elements for larger amounts on chain

问题: state channel是把这些小的交易收集起来然后等到数额够大了交易还是?

* context
   * Micro-payments are payments that can beas small as a few cents(就是转的钱太少了,不值得放到blockchain上)
* Problem
   * Long commit time
   * high transcation fee
* sloution
   * Establish a payment channel between two participants
   * Deposit from one or both sides locked up(存款从一方或双方锁定)
   * Payment channel keeps the intermediate states
   * Only the finalized payment is on chain
   * Frequency of seElement depends on use cases(就是特殊情况特殊对待)
* pros
   * Speed:在线下transcation很快
   * Throughput:不被区块链的吞吐量限制
   * Privacy:中间状态不被显示
   * Cost: 只有最后的commit才会被charge 交易费
* cons
   * Trustworthiness:Micro-payment transacGons are not immutable and can be lost aWer the channel is closed
   * Reduced liquidity: Locked up security deposit reduces liquidity of channel participants(中间小的流水就看不到了)


### Security (4)

1. Multiple Authorization
A set of blockchain addresses which can authorize a transaction is predefined. Only a subset of the addresses is required to authorize transactions.

多人授权: 和银行的差不多,办理业务的时候需要好几个人来授权,这里用pre-define 的 address来授权

* problem
   * The actual addresses that authorize an acGvity might not be able to be decided due to availability(授权的人可能不在)
* Solution
   * The set of blockchain addresses for authorization are not decided before the transaction being submitted to blockchain network
   * an M-of-N multi-signature can be used to define that M out of N private keys are required to authorize the transaction. 
* pros
   * Flexibility: Enable flexible binding of authoriGes based on availability(谁在线谁来授权)
   * Lost key tolerant.
      * Threshold-based authorized update(法定人数quorum设置)
      * One participant can own more than one blockchain address to reduce the risk of losing control over their smart contracts due to a lost private key. 问题: 这是为啥

* cons
   * Pre-defined authorities: All the possible authorities need to be known in advance(需要知道有哪些人在线,再来选)
   * Lost key: At least M among N private keys should be safely kept to avoid losing control
   * 如果使用公共区块链，则更新权限列表需要花费金钱(加密货币)，为多个权限部署逻辑也是如此。与只存储一个地址相比，存储多个地址的成本更高。

验证过程应该是这样,这个transcation把data分别用选中address的公钥加密,然后在commit,通过选中address人的私钥解密来授权

2. Dynamic Authorization

动态授权采用来hash加密的方式,用一个hash(secret)来验证授权,将这个hash vlaue放在deploy的contract里面,然后只要将这个secret给鉴权的人
,就可以对transcation进行鉴权.

Using a hash created off-chain to dynamically bind authority for a transaction.

* context 
   * Activities might need to be authorized by multiple blockchain addresses(需要多个address来授权)


* problem
   * 在将第二个事务添加到区块链之前，必须在第一个事务中定义所有能够授权第二个事务的帐户。如果没有定义就无法授权
   * No dynamic binding with an address of a participant

* Solution
  * Off-chain secret used to enable dynamic authorization
  * Transaction is “locked” by hash of an off-chain secret(用hash(a random string, called pre-image)来和链下的hash( random string)进行比较)
  * Whoever receives the secret off-chain can authorize the transaction(比较match就算验证成功,可以给与权限)

* pros
   * Dynamism: Enable dynamic binding of unknown authorities
   * Lost key tolerance: No specific key is required to authorize transacGon
   * Routability
   * Interoperability: Enable interacGon between other systems and blockchain
* cons
   * One-off secret: Secret is not reusable after being revealed
   * Lost secret: TransacGon is “locked” forever if the secret is lost


3. Factory Contract 

On-chain template contract is used as a factory that generates contract instances from the
template(就是smart contract的模板)

The template can be stored off-chain in a code repository, or on-chain, within its own smart contract.

* Problem
   * Off-chain contract template cannot guarantee consistency 模板相同并不能保证从这个相同模板创建的不同smart contract的一致性,因为在线下的时候,代码是可以被修改的

   * Solution
      *  Smart contract are created from a contract factory on blockchain(存储的是smart contract 的 class)
      *  Factory contract is deployed once from off-chain source code
        问题: 这句话啥意思
      *  Smart contract instances are generated by passing parameters to the contract factory to instanGate customized instances(contract通过class创建实例,传入参数)
      * 在链上的class内代码是不能被修改的,所以 This contract instance (the object) will maintain its own properties independently of the other instances,but with a structure consistent with its original template(class).

* pros
   * Security: On-chain factory contract guarantees consistency
   * Efficiency: Smart contract instances are generated by calling a funcGon
* cons
   * Cost on public blockchain(创建实例的时候需要花费gas)
      * Deployment
      * FuncGon call for smart contract instance creation On-chain deploy once


## WEEK 9 Model-Driven Engineering

1. modelling levels

* Low-level models: production code can be directly derived from the models(直接用模型的code)
* High-level models: means of communication between business owners and developers implementing a system(需要通过双方的交流来生成production)
* Intermediate levels can support model-based system analysis or system management tools


2. MDE vs. MDD vs. MDA

* Model-driven development (MDD) vs. MDE:
   * MDD适合于软件开发 
   * MDE是code generation


`UML (Unified Modeling Language) is a standard language for specifying, visualizing, constructing, and documenting the artifacts of software systems. `

* Model-driven architecture (MDA) vs. MDD/MDE:
   * standred using UML
   * Does not cover all aspects of an architecture, but architecture-centric models
   * 就是以模型为导向的各种架构



3. Advantages of MDE in the blockchain context

* Code generation can implement best practices and well-tested building blocks(code可以写在blockcahin内部)
* Improved productivity, especially for novices in a particular technology(code都写在里面了,就相当于模板,新手能够直接调用)
* Models can be independent of specific blockchain technologies or platforms(model可以不依赖于blockchain技术和平台)
* Models are often easier to understand than code

4. Fungible and Non-fungible Tokens
* 详细解说: https://www.unitimes.io/auther/11747/?lang=zh
* 简单来说,可替代tokens就是没有自己独一无二的特性,所以的这类token都一样,就像钱,你给别人你的100,别人在还给你另外一张100,没有任何区别,而且可替代tokens还是可分的,比如你花掉100中的10,但是,不可替换token,每一个token都有自己独一无二的特征,世界上只有这一个token,且其不可分.

5. Lorikeet
* 一个tool,模板,可以直接生产 contract,类似于事先定义的class,然后实例化一个,方便简洁

Translator
* Translate subset of BPMN elements to Solidity(就是把BPMN的流程转化为code)



# Summary


* A blockchain is a distributed ledger that is struc- tured into a linked list of blocks.

* A (distributed ledger)分布式账本 is an append-only store of transactions which is distributed across many machines.(注意这里是append-only)







