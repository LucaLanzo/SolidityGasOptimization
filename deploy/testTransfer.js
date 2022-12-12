// require the Hardhat Runtime Environment explicitly
// optional, but useful for running script in standalone fashion through `node <script>`
const hre = require("hardhat");
const { loadContract, calculateGasSavings, writeToCSV } = require('./scriptHelpers.js');

async function main() { 
       
    const accounts = await hre.ethers.getSigners()
    const to = accounts[1];

    // load the contract
    // loadContract(abi, account, customAddress=undefined, deployYul=false, constructorArgs=false)
    const transferFunds = await loadContract("TransferFunds", 0, undefined, false, false);
    const transferFundsASM = await loadContract("TransferFundsASM", 0, undefined, false, false);
    const transferFundsSA = await loadContract("TransferFundsSA", 0, undefined, true, false);


    // ##################
    // #### TRANSFER ####
    // ##################

    // test the Sol transfer
    console.log("Transfering ETH using Sol ...")
    const transactionSol = await transferFunds.transferFunds(to.address, 
        { value: hre.ethers.utils.parseEther("0.05")}
    )
    // log gas costs
    const receiptSol = await transactionSol.wait()
    const gasUsedSol = receiptSol.cumulativeGasUsed;

    console.log(`... done. Gas used: ${gasUsedSol}`)
    
    
    // test the ASM transfer
    console.log("\n\nTransfering ETH using ASM ...")
    const transactionASM = await transferFundsASM.transferFundsASM(to.address, 
        { value: hre.ethers.utils.parseEther("0.05")}
    )
    // log gas costs
    const receiptASM = await transactionASM.wait()
    const gasUsedASM = receiptASM.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedASM}`)
     
    

    // test the SA transfer
    console.log("\n\nTransfering ETH using SA ...")
    const transactionSA = await transferFundsSA.transferFundsYul(to.address, 
        { value: hre.ethers.utils.parseEther("0.05")}
    )
    // log gas costs
    const receiptSA = await transactionSA.wait()
    const gasUsedSA = receiptSA.cumulativeGasUsed;

    console.log(`... done. Gas used: ${gasUsedSA}`)
     

    
    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`) 
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`) 
    writeToCSV([["transferSol", String(gasUsedSol)], ["transferASM", String(gasUsedASM)], ["transferSA", String(gasUsedSA)]])
}


main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
