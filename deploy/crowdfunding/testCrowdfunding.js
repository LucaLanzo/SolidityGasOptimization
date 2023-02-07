// require the Hardhat Runtime Environment explicitly
// optional, but useful for running script in standalone fashion through `node <script>`
const hre = require("hardhat");
const { loadContract, calculateGasSavings, writeToCSV } = require('../scriptHelpers.js');


async function main() {
    // load two crowdfunding contracts manually
    const Crowdfunding = await loadContract("Crowdfunding", 1, undefined, false, true)
    const crowdfunding = await Crowdfunding.deploy(100, 3)
    await crowdfunding.deployed()
    await crowdfunding.deployTransaction.wait()
    console.log(`Crowdfunding successfully deployed to ${crowdfunding.address}`);
    const crowdfundingSec = await loadContract("Crowdfunding", 2, crowdfunding.address, false, false)
    
    
    // load two ASM crowdfunding contracts manually
    const CrowdfundingASM = await loadContract("CrowdfundingASM", 1, undefined, false, true)
    const crowdfundingASM = await CrowdfundingASM.deploy(100, 3)
    await crowdfundingASM.deployed()
    await crowdfundingASM.deployTransaction.wait()
    console.log(`CrowdfundingASM successfully deployed to ${crowdfundingASM.address}`);
    const crowdfundingASMSec = await loadContract("CrowdfundingASM", 2, crowdfundingASM.address, false, false)
    
    
    // load two SA crowdfunding contracts manually
    const CrowdfundingSA = await loadContract("CrowdfundingSA", 1, undefined, true, true)
    const crowdfundingSA = await CrowdfundingSA.deploy(100, 3)
    await crowdfundingSA.deployed();
    await crowdfundingSA.deployTransaction.wait();
    console.log(`CrowdfundingSA successfully deployed to ${crowdfundingSA.address}`);
    const crowdfundingSASec = await loadContract("CrowdfundingSA", 2, crowdfundingSA.address, true)
    


    // ###############
    // #### VIEW #####
    // ###############

    // test the Sol view method
    console.log("\nCalling Sol view function ...")
    let transactionSol = await crowdfunding.viewProject()
    console.log(transactionSol.toString())


    // test the ASM view method
    console.log("\nCalling ASM view function ...")
    let transactionASM = await crowdfundingASM.viewProject()
    console.log(transactionASM.toString())


    // test the SA view method
    console.log("\nCalling SA view function ...")
    let transactionSA = await crowdfundingSA.viewProject()
    console.log(transactionSA.toString())



    // ##################
    // #### FUNDING #####
    // ##################

    // test the Sol funding
    console.log("\nTesting the Sol funding function ...")
    transactionSol = await crowdfundingSec.fund(
        { value: hre.ethers.utils.parseEther("0.05")}
    )
    // log gas costs
    let receiptSol = await transactionSol.wait()
    let gasUsedSol = receiptSol.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsedSol}`)


    // test the ASM funding
    console.log("\nTesting the ASM funding function ...")
    transactionASM = await crowdfundingASMSec.fund(
        { value: hre.ethers.utils.parseEther("0.05")}
    )
    // log gas costs
    let receiptASM = await transactionASM.wait()
    let gasUsedASM = receiptASM.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsedASM}`)


    // test the SA funding
    console.log("\nTesting the SA funding function ...")
    transactionSA = await crowdfundingSASec.fund(
        { value: hre.ethers.utils.parseEther("0.05")}
    )
    // log gas costs
    let receiptSA = await transactionSA.wait()
    let gasUsedSA = receiptSA.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsedSA}`)
    
    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`)
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`)
    writeToCSV([["crowdfundingFundSol", String(gasUsedSol)], ["crowdfundingFundASM", String(gasUsedASM)], ["crowdfundingFundSA", String(gasUsedSA)]])



    // #################
    // #### PAYOUT #####
    // #################
    
    // test the Sol payOut
    console.log("\nTesting the Sol payOut function ...")
    transactionSol = await crowdfunding.payOut()
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = receiptSol.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsedSol}`)


    // test the ASM payOut
    console.log("\nTesting the ASM payOut function ...")
    transactionASM = await crowdfundingASM.payOut()
    // log gas costs
    receiptASM = await transactionASM.wait()
    gasUsedASM = receiptASM.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsedASM}`)


    // test the SA payOut
    console.log("\nTesting the SA payOut function ...")
    transactionSA = await crowdfundingSA.payOut()
    // log gas costs
    receiptSA = await transactionSA.wait()
    gasUsedSA = receiptSA.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsedSA}`)
    

    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`)
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`)
    writeToCSV([["crowdfundingPayoutSol", String(gasUsedSol)], ["crowdfundingPayoutASM", String(gasUsedASM)], ["crowdfundingPayoutSA", String(gasUsedSA)]])
}


main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
