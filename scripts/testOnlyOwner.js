// require the Hardhat Runtime Environment explicitly
// optional, but useful for running script in standalone fashion through `node <script>`
const hre = require("hardhat");
import { loadContract, calculateGasSavings } from './scriptHelpers.js'


async function main() {
    
    const argv = process.argv.slice(2)
    // if the contract should not be redeployed, the command line arguments need at least a contract address
    if (argv.length < 2) {
        console.log("No deploy statement or contract address has been provided.\nProvide args with 'd' to deploy or give an existing contract address.");
        return
    }

    // load the contracts
    const onlyOwnerSol = await loadContract(argv[0], "OnlyOwnerSol", 0, 0);
    const onlyOwnerYul = await loadContract(argv[1], "OnlyOwnerYul", 0, 1)
    
    
    // test the Sol method
    console.log("Calling empty onlyOwner solidity method ...")
    const transactionSol = await onlyOwnerSol.ownerTest()
    // log gas costs
    const receiptSol = await transactionSol.wait()
    const gasUsedSol = receiptSol.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsedSol}`)


    // test the Yul method
    console.log("\n\nCalling empty onlyOwner yul method ...")
    const transactionYul = await onlyOwnerYul.ownerTest()
    // log gas costs
    const receiptYul = await transactionYul.wait()
    const gasUsedYul = receiptYul.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsedYul}`)

    console.log(`\nYul saved ${calculateGasSavings(gasUsedSol, gasUsedYul)}% gas.`)
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
