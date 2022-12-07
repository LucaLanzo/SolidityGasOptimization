// require the Hardhat Runtime Environment explicitly
// optional, but useful for running script in standalone fashion through `node <script>`
const hre = require("hardhat");
const { loadContract, calculateGasSavings, writeToCSV } = require('./scriptHelpers.js');

async function main() { 
       
    const accounts = await hre.ethers.getSigners()
    const from = 1;
    const to = accounts[0];


    // load the contract
    const transferFunds = await loadContract("TransferFunds", from);
    if (transferFunds == undefined) return;    


    // test the Solidity transfer
    console.log("Transfering ETH using Solidity ...")
    const transactionSol = await transferFunds.transferFundsSol(to.address, 
        { value: hre.ethers.utils.parseEther("0.05")}
    )
    
    // log gas costs
    const receiptSol = await transactionSol.wait()
    const gasUsedSol = receiptSol.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedSol}`)
    
    
    // test the Yul transfer
    console.log("\n\nTransfering ETH using Yul ...")
    const transactionYul = await transferFunds.transferFundsYul(to.address, 
        { value: hre.ethers.utils.parseEther("0.05")}
    )

    // log gas costs
    const receiptYul = await transactionYul.wait()
    const gasUsedYul = receiptYul.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedYul}`)
    
    console.log(`\nYul saved ${calculateGasSavings(gasUsedSol, gasUsedYul)}% gas.`)  
    
    
    // save the results into the csv file
    writeToCSV([["transferSol", String(gasUsedSol)], ["transferYul", String(gasUsedYul)]])
}


main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
