// require the Hardhat Runtime Environment explicitly
// optional, but useful for running script in standalone fashion through `node <script>`
const hre = require("hardhat");
const { loadContract, calculateGasSavings, writeToCSV } = require('../scriptHelpers.js');


async function main() {
    // load two transferToken contracts manually
    let TransferTokenSol = await loadContract("TransferToken", 1, undefined, false, true)
    let transferTokenSol = await TransferTokenSol.deploy(100) // initialize with 100 tokens
    await transferTokenSol.deployed()
    await transferTokenSol.deployTransaction.wait()
    console.log(`TransferToken successfully deployed to ${transferTokenSol.address}`);
    let transferTokenSolSec = await loadContract("TransferToken", 3, transferTokenSol.address, false, false)
    

    // load two transferTokenASM contracts manually
    let TransferTokenASM = await loadContract("TransferTokenASM", 1, undefined, false, true)
    let transferTokenASM = await TransferTokenASM.deploy(100) // initialize with 100 tokens
    await transferTokenASM.deployed()
    await transferTokenASM.deployTransaction.wait()
    console.log(`TransferTokenASM successfully deployed to ${transferTokenASM.address}`);
    let transferTokenASMSec = await loadContract("TransferTokenASM", 3, transferTokenASM.address, false, false)


    // load two transferTokenSA contracts manually
    let TransferTokenSA = await loadContract("TransferTokenSA", 1, undefined, true, true)
    let transferTokenSA = await TransferTokenSA.deploy(100) // initialize with 100 tokens
    await transferTokenSA.deployed()
    await transferTokenSA.deployTransaction.wait()
    console.log(`TransferTokenSA successfully deployed to ${transferTokenSA.address}`);
    let transferTokenSASec = await loadContract("TransferTokenSA", 3, transferTokenSA.address, true, false)
    
    
    // first acc: 0x553719253E4E83B4743b74Ab156da388C5cd91F7
    // sec acc:   0xFa0FB3Ac08917d6415262742F59d031113D31284
    // third acc: 0x9bb9b0Aa744539FBdF72Fb18C79D236cc7c31D16


    // ####################
    // ##### TRANSFER #####
    // ####################

    console.log("\nCalling TransferToken Sol transfer function ...")
    
    let transactionSol = await transferTokenSol.transfer("0xFa0FB3Ac08917d6415262742F59d031113D31284", 50)
    // log gas costs
    let receiptSol = await transactionSol.wait()
    let gasUsedSol = receiptSol.cumulativeGasUsed;
    console.log(`Gas used: ${gasUsedSol}`)

    transactionSol = await transferTokenSol.balanceOf("0x553719253E4E83B4743b74Ab156da388C5cd91F7")
    console.log(transactionSol.toString())

    transactionSol = await transferTokenSol.balanceOf("0xFa0FB3Ac08917d6415262742F59d031113D31284")
    console.log(transactionSol.toString())




    // ####################
    // ##### TRANSFER #####
    // ####################

    console.log("\n\nCalling TransferToken ASM transfer function ...")

    let transactionASM = await transferTokenASM.transfer("0xFa0FB3Ac08917d6415262742F59d031113D31284", 50) 
    // log gas costs
    let receiptASM = await transactionASM.wait()
    let gasUsedASM = receiptASM.cumulativeGasUsed;
    console.log(`Gas used: ${gasUsedASM}`)

    transactionASM = await transferTokenASM.balanceOf("0x553719253E4E83B4743b74Ab156da388C5cd91F7")
    console.log(transactionASM.toString())

    transactionASM = await transferTokenASM.balanceOf("0xFa0FB3Ac08917d6415262742F59d031113D31284")
    console.log(transactionASM.toString())




    // ####################
    // ##### TRANSFER #####
    // ####################

    console.log("\nCalling TransferToken SA transfer function ...")
    
    let transactionSA = await transferTokenSA.transfer("0xFa0FB3Ac08917d6415262742F59d031113D31284", 50)
    // log gas costs
    let receiptSA = await transactionSA.wait()
    let gasUsedSA = receiptSA.cumulativeGasUsed;
    console.log(`Gas used: ${gasUsedSA}`)

    transactionSA = await transferTokenSA.balanceOf("0x553719253E4E83B4743b74Ab156da388C5cd91F7")
    console.log(transactionSA.toString())

    transactionSA = await transferTokenSA.balanceOf("0xFa0FB3Ac08917d6415262742F59d031113D31284")
    console.log(transactionSA.toString())


    

    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`) 
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`) 
    writeToCSV([["Solidity", String(gasUsedSol)], ["Inline assembly", String(gasUsedASM)], ["Standalone Yul", String(gasUsedSA)]], category="transferToken", filename="transferToken/gasCostsTokenTransfer")






    // ########################
    // ##### TRANSFERFROM #####
    // ########################

    console.log("\nCalling TransferToken Sol transferFrom function ...")
    
    transactionSol = await transferTokenSol.approve("0x9bb9b0Aa744539FBdF72Fb18C79D236cc7c31D16", 50)  // first approves third for 50 
    // log gas costs
    receiptSol = await transactionSol.wait()
    let gasUsedApproveSol = receiptSol.cumulativeGasUsed;
    console.log(`Gas used: ${gasUsedApproveSol}`)


    transactionSol = await transferTokenSolSec.transferFrom("0x553719253E4E83B4743b74Ab156da388C5cd91F7", "0xFa0FB3Ac08917d6415262742F59d031113D31284", 50)  // third: transfer rest 50 from first to sec
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = receiptSol.cumulativeGasUsed;
    console.log(`Gas used: ${gasUsedSol}`)


    transactionSol = await transferTokenSol.balanceOf("0x553719253E4E83B4743b74Ab156da388C5cd91F7") // now 0
    console.log(transactionSol.toString())

    transactionSol = await transferTokenSol.balanceOf("0xFa0FB3Ac08917d6415262742F59d031113D31284") // now 100
    console.log(transactionSol.toString())




    // ########################
    // ##### TRANSFERFROM #####
    // ########################

    console.log("\nCalling TransferToken ASM transferFrom function ...")
    
    transactionASM = await transferTokenASM.approve("0x9bb9b0Aa744539FBdF72Fb18C79D236cc7c31D16", 50)  // first approves third for 50 
    // log gas costs
    receiptASM = await transactionASM.wait()
    let gasUsedApproveASM = receiptASM.cumulativeGasUsed;
    console.log(`Gas used: ${gasUsedApproveASM}`)


    transactionASM = await transferTokenASMSec.transferFrom("0x553719253E4E83B4743b74Ab156da388C5cd91F7", "0xFa0FB3Ac08917d6415262742F59d031113D31284", 50)  // third: transfer rest 50 from first to sec
    // log gas costs
    receiptASM = await transactionASM.wait()
    gasUsedASM = receiptASM.cumulativeGasUsed;
    console.log(`Gas used: ${gasUsedASM}`)


    transactionASM = await transferTokenASM.balanceOf("0x553719253E4E83B4743b74Ab156da388C5cd91F7") // now 0
    console.log(transactionASM.toString())

    transactionASM = await transferTokenASM.balanceOf("0xFa0FB3Ac08917d6415262742F59d031113D31284") // now 100
    console.log(transactionASM.toString())




    // ########################
    // ##### TRANSFERFROM #####
    // ########################

    console.log("\nCalling TransferToken SA transferFrom function ...")
    
    transactionSA = await transferTokenSA.approve("0x9bb9b0Aa744539FBdF72Fb18C79D236cc7c31D16", 50)  // first approves third for 50 
    // log gas costs
    receiptSA = await transactionSA.wait()
    let gasUsedApproveSA = receiptSA.cumulativeGasUsed;
    console.log(`Gas used: ${gasUsedApproveSA}`)


    transactionSA = await transferTokenSASec.transferFrom("0x553719253E4E83B4743b74Ab156da388C5cd91F7", "0xFa0FB3Ac08917d6415262742F59d031113D31284", 50)  // third: transfer rest 50 from first to sec
    // log gas costs
    receiptSA = await transactionSA.wait()
    gasUsedSA = receiptSA.cumulativeGasUsed;
    console.log(`Gas used: ${gasUsedSA}`)


    transactionSA = await transferTokenSA.balanceOf("0x553719253E4E83B4743b74Ab156da388C5cd91F7") // now 0
    console.log(transactionSA.toString())

    transactionSA = await transferTokenSA.balanceOf("0xFa0FB3Ac08917d6415262742F59d031113D31284") // now 100
    console.log(transactionSA.toString())


    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`) 
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`) 
    writeToCSV([["Solidity", String(gasUsedApproveSol)], ["Inline assembly", String(gasUsedApproveASM)], ["Standalone Yul", String(gasUsedApproveSA)]], category="approve", filename="transferToken/gasCostsTokenTransfer")


    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`) 
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`) 
    writeToCSV([["Solidity", String(gasUsedSol)], ["Inline assembly", String(gasUsedASM)], ["Standalone Yul", String(gasUsedSA)]], category="transferFromToken", filename="transferToken/gasCostsTokenTransfer")
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
