// require the Hardhat Runtime Environment explicitly
// optional, but useful for running script in standalone fashion through `node <script>`
const hre = require("hardhat");
const { loadContract, calculateGasSavings, writeToCSV } = require('./scriptHelpers.js');


async function main() {
    
    // load the contracts
    const onlyOwnerSol = await loadContract("OnlyOwnerSol", 0, argvNumber=0);
    const onlyOwnerYul = await loadContract("OnlyOwnerYul", 0, argvNumber=1)
    
    
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

    // save the results into the csv file
    writeToCSV([["onlyOwnerSol", String(gasUsedSol)], ["onlyOwnerYul", String(gasUsedYul)]])
}


main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
