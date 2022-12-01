// require the Hardhat Runtime Environment explicitly
// optional, but useful for running script in standalone fashion through `node <script>`
const hre = require("hardhat");
import { loadContract } from './scriptHelpers.js'


async function main() {
    console.log(await hre.ethers.provider.getBlockNumber())

    const argv = process.argv.slice(2)
    // if the contract should not be redeployed, the command line arguments need at least a contract address
    if (argv.length == 0) {
        console.log("No deploy statement or contract address has been provided.\nProvide args with 'd' to deploy or give an existing contract address.");
        return
    }
    
    // load the contract
    const yul = await loadContract(argv[0], "Yul", 0);
    // console.log(await yulTest.deployed())


    // test
    let number = await yul.getNumber();
    console.log(`Number reads: ${number}`)
    
    let message = await yul.getMessage()
    console.log(`Message reads: ${message}`)
    
    const receipt = await yul.change()
    console.log(`Change used up ${(await receipt.wait()).cumulativeGasUsed} gas`)
   
    number = await yul.getNumber()
    console.log(`Number now reads: ${number}`)

    message = await yul.getMessage()
    console.log(`Message now reads: ${message}`)
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
