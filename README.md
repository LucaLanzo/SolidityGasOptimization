# Solidity Inline Assembly Gas Savings

This project is part of a Bachelor's Thesis which aims to find ways to optimize the gas costs for smart contracts on the Ethereum blockchain. 
The main aspect is the usage of Solidity's inline assembly feature, which gives a programmer the ability to program in the close-to-EVM-bytecode low-level language Yul.
  
Multiple basic operations are translated and compared from Solidity to Yul and lastly, a real use case of a decentralized Crowdfunding platform was implemented using all the operations which previously saved gas costs.
  
  
# Start the project

## Firstly, create a local blockchain
### - Infura is used to fork mainnet
### - A hardhat node should be run locally where ...
### - ... the keys are the same on every start
### - ... other configurations are set in the hardhat.config.js
```
npx hardhat compile // or 'npm run c'
npx hardhat node // or 'npm run s'
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

 