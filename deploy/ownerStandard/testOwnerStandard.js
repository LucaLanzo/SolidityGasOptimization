// require the Hardhat Runtime Environment explicitly
// optional, but useful for running script in standalone fashion through `node <script>`
const hre = require("hardhat");
const { loadContract, calculateGasSavings, writeToCSV } = require('../scriptHelpers.js');


async function main() {
    
    // load the contracts
    const onlyOwnerSol = await loadContract("OnlyOwnerSol", 0, undefined, false, false);
    const onlyOwnerASM = await loadContract("OnlyOwnerASM", 0, undefined, false, false);
    const onlyOwnerSA = await loadContract("OnlyOwnerSA", 0, undefined, true, false)
    
    
    // ###############
    // ### TESTING ###
    // ###############

    // test the Sol method
    console.log("Calling empty onlyOwner solidity method ...")
    const transactionSol = await onlyOwnerSol.ownerTest()
    // log gas costs
    const receiptSol = await transactionSol.wait()
    const gasUsedSol = receiptSol.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsedSol}`)
    
    
    // test the ASM method
    console.log("\n\nCalling empty onlyOwner ASM method ...")
    const transactionASM = await onlyOwnerASM.ownerTest()
    // log gas costs
    const receiptASM = await transactionASM.wait()
    const gasUsedASM = receiptASM.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsedASM}`)


    // test the SA method
    console.log("\n\nCalling empty onlyOwner SA method ...")
    const transactionSA = await onlyOwnerSA.ownerTest()
    // log gas costs
    const receiptSA = await transactionSA.wait()
    const gasUsedSA = receiptSA.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsedSA}`)
    
    
    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`)
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`)
    writeToCSV([["onlyOwnerSol", String(gasUsedSol)], ["onlyOwnerASM", String(gasUsedASM)], ["onlyOwnerSA", String(gasUsedSA)]])
}


main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
