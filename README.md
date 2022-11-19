# Solidity Inline Assembly Gas Savings

This project is part of a Bachelor's Thesis which aims to find ways to optimize the gas costs for smart contracts on the Ethereum blockchain. 
The main aspect is the usage of Solidity's inline assembly feature, which gives a programmer the ability to program in the close-to-EVM-bytecode low-level language Yul.
  
Multiple basic operations are translated and compared from Solidity to Yul and lastly, a real use case of a decentralized Crowdfunding platform was implemented using all the operations which previously saved gas costs.
  
  
# Start the project

## Firstly, create a local blockchain
### - Infura Endpoint is used
### - Blockchain instance is saved locally
### - Keys are the same on every start
```
npx ganache -m 'exhibit air raven loop into fetch license iron manual surround hold east' -a 2 --database.dbPath '.\ganacheDB' --fork.url wss://:b812d5c70a6d441eacd94aa8d9e28f77@mainnet.infura.io/ws/v3/8033ae5519e74bc784ea038df242d8b8
```

<br>
<br>
  
## Now run the Ganache Block Explorer
```
go run router.go rpcRequestGo.go
``` 

<br>
<br> 

### Optionally you can compile directly to Yul:
```
solc --ir-optimized --optimize contracts/OnlyOwnerTestSolidity.sol > .\contracts\OnlyOwnerTestYul.yul
``` 

<br>
<br>

### More useful hardhat commands:
```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```

 