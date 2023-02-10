// require the Hardhat Runtime Environment explicitly
// optional, but useful for running script in standalone fashion through `node <script>`
const hre = require("hardhat");
const { loadContract, calculateGasSavings, writeToCSV } = require('../scriptHelpers.js');

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
    let transactionSol = await transferFunds.transferFundsTransfer(to.address, 
        { value: hre.ethers.utils.parseEther("0.00005")}
    )
    // log gas costs
    let receiptSol = await transactionSol.wait()
    let gasUsedSol = receiptSol.cumulativeGasUsed;

    console.log(`... done. Gas used: ${gasUsedSol}`)
    
    
    // test the ASM transfer
    console.log("\n\nTransfering ETH using ASM ...")
    let transactionASM = await transferFundsASM.transferFundsASMTransfer(to.address, 
        { value: hre.ethers.utils.parseEther("0.00005")}
    )
    // log gas costs
    let receiptASM = await transactionASM.wait()
    let gasUsedASM = receiptASM.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedASM}`)
     
    

    // test the SA transfer
    console.log("\n\nTransfering ETH using SA ...")
    let transactionSA = await transferFundsSA.transferFundsYulTransfer(to.address, 
        { value: hre.ethers.utils.parseEther("0.00005")}
    )
    // log gas costs
    let receiptSA = await transactionSA.wait()
    let gasUsedSA = receiptSA.cumulativeGasUsed;

    console.log(`... done. Gas used: ${gasUsedSA}`)
     

    
    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`) 
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`) 
    writeToCSV([["Solidity", String(gasUsedSol)], ["Inline assembly", String(gasUsedASM)], ["Standalone Yul", String(gasUsedSA)]], category="transfer", filename="transfer/gasCostsTransfer")



    

    // ##################
    // ###### SEND ######
    // ##################

    // test the Sol send
    console.log("Sending ETH using Sol ...")
    transactionSol = await transferFunds.transferFundsSend(to.address, 
        { value: hre.ethers.utils.parseEther("0.00005")}
    )
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = receiptSol.cumulativeGasUsed;

    console.log(`... done. Gas used: ${gasUsedSol}`)
    
    
    // test the ASM send
    console.log("\n\nSend ETH using ASM ...")
    transactionASM = await transferFundsASM.transferFundsASMSend(to.address, 
        { value: hre.ethers.utils.parseEther("0.00005")}
    )
    // log gas costs
    receiptASM = await transactionASM.wait()
    gasUsedASM = receiptASM.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedASM}`)
     
    

    // test the SA send
    console.log("\n\nSending ETH using SA ...")
    transactionSA = await transferFundsSA.transferFundsYulSend(to.address, 
        { value: hre.ethers.utils.parseEther("0.00005")}
    )
    // log gas costs
    receiptSA = await transactionSA.wait()
    gasUsedSA = receiptSA.cumulativeGasUsed;

    console.log(`... done. Gas used: ${gasUsedSA}`)
     

    
    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`) 
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`) 
    writeToCSV([["Solidity", String(gasUsedSol)], ["Inline assembly", String(gasUsedASM)], ["Standalone Yul", String(gasUsedSA)]], category="send", filename="transfer/gasCostsTransfer")

    





    // ##################
    // ###### CALL ######
    // ##################

    // test the Sol call
    console.log("Calling ETH using Sol ...")
    transactionSol = await transferFunds.transferFundsCall(to.address, 
        { value: hre.ethers.utils.parseEther("0.00005")}
    )
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = receiptSol.cumulativeGasUsed;

    console.log(`... done. Gas used: ${gasUsedSol}`)
    
    
    // test the ASM call
    console.log("\n\nCalling ETH using ASM ...")
    transactionASM = await transferFundsASM.transferFundsASMCall(to.address, 
        { value: hre.ethers.utils.parseEther("0.00005")}
    )
    // log gas costs
    receiptASM = await transactionASM.wait()
    gasUsedASM = receiptASM.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedASM}`)
     
    

    // test the SA call
    console.log("\n\nCalling ETH using SA ...")
    transactionSA = await transferFundsSA.transferFundsYulCall(to.address, 
        { value: hre.ethers.utils.parseEther("0.00005")}
    )
    // log gas costs
    receiptSA = await transactionSA.wait()
    gasUsedSA = receiptSA.cumulativeGasUsed;

    console.log(`... done. Gas used: ${gasUsedSA}`)
     

    
    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`) 
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`) 
    writeToCSV([["Solidity", String(gasUsedSol)], ["Inline assembly", String(gasUsedASM)], ["Standalone Yul", String(gasUsedSA)]], category="call", filename="transfer/gasCostsTransfer")
}


main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
