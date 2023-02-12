# Solidity to Yul transformation - Possible gas Savings

This project is part of a Bachelor's Thesis which aims to find ways to optimize the gas costs for smart contracts on the Ethereum blockchain. 
The main aspect is the conversion to Solidity's inline assembly feature, which gives a programmer the ability to program in the close-to-EVM-bytecode low-level language Yul. Another part of the experiment involves a complete conversion to Yul by writing a smart contract in standalone Yul.
  
Multiple basic operations are translated and compared from Solidity to Yul and lastly, a real use case of a decentralized Crowdfunding platform was implemented using all the operations which previously saved gas costs.  
    
<br>
<br> 
  
# Start the project

### Firstly, create a local blockchain:
Infura is used to fork mainnet and a hardhat node should be run locally where ...  
... the keys are the same on every start  
... other configurations are set in the hardhat.config.js
```
npx hardhat compile // or 'npm run c'
node .\compile\compileYul.js <folder> <yulFileWithoutExtension> // to compile yul file
npx hardhat node // or 'npm run s'
```

<br> 

### To run the test programs, compile everything and run the following .js script
```
node .\deploy\arithmetics\testArithmetics.js
```
Be aware that this will append the gas usage to the respective results/arithmetics/gasCostsArithmetics.csv file every file.

<br>
<br>

# Optional commands
### Optionally you can compile directly to Yul/compile to Yul with a (OpenZeppelin) library import:
```
solc --ir-optimized --optimize .\contracts\arithmetics\Arithmetics.sol > .\contracts\arithmetics\ArithmeticsOutput.yul

solc --ir-optimized --optimize --base-path '/' --include-path 'node_modules/'  .\contracts\ownerStandard\OnlyOwner.sol > .\contracts\ownerStandard\OnlyOwnerOutput.sol
``` 

<br>

### It is also possible to optimize self-written Yul contracts during compilation:
```
solc --strict-assembly --optimize --optimize-runs 1500 .\contracts\arithmetics\ArithmeticsSA.yul > .\contracts\arithmetics\ArithmeticsSAOutput.bytecode.json
``` 

<br>


### More useful hardhat commands:
```shell
npx hardhat help
npx hardhat test
npx hardhat accounts
npx hardhat node
npx hardhat run deploy/xxx.js
```

 