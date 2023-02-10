// require the Hardhat Runtime Environment explicitly
// optional, but useful for running script in standalone fashion through `node <script>`
const hre = require("hardhat");
const { loadContract, calculateGasSavings, writeToCSV } = require('../scriptHelpers.js');


async function main() {
    // load two crowdfunding contracts manually
    let Crowdfunding = await loadContract("Crowdfunding", 1, undefined, false, true)
    let crowdfunding = await Crowdfunding.deploy(100, 3)
    await crowdfunding.deployed()
    await crowdfunding.deployTransaction.wait()
    console.log(`Crowdfunding successfully deployed to ${crowdfunding.address}`);
    let crowdfundingSec = await loadContract("Crowdfunding", 2, crowdfunding.address, false, false)
    
    
    // load two ASM crowdfunding contracts manually
    let CrowdfundingASM = await loadContract("CrowdfundingASM", 1, undefined, false, true)
    let crowdfundingASM = await CrowdfundingASM.deploy(100, 3)
    await crowdfundingASM.deployed()
    await crowdfundingASM.deployTransaction.wait()
    console.log(`CrowdfundingASM successfully deployed to ${crowdfundingASM.address}`);
    let crowdfundingASMSec = await loadContract("CrowdfundingASM", 2, crowdfundingASM.address, false, false)
    
    
    // load two SA crowdfunding contracts manually
    let CrowdfundingSA = await loadContract("CrowdfundingSA", 1, undefined, true, true)
    let crowdfundingSA = await CrowdfundingSA.deploy(100, 3)
    await crowdfundingSA.deployed();
    await crowdfundingSA.deployTransaction.wait();
    console.log(`CrowdfundingSA successfully deployed to ${crowdfundingSA.address}`);
    let crowdfundingSASec = await loadContract("CrowdfundingSA", 2, crowdfundingSA.address, true)
    


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
    writeToCSV([["Solidity", String(gasUsedSol)], ["Inline assembly", String(gasUsedASM)], ["Standalone Yul", String(gasUsedSA)]], category="Funding", fileName="crowdfunding/gasCostsCrowdfunding")



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
    writeToCSV([["Solidity", String(gasUsedSol)], ["Inline assembly", String(gasUsedASM)], ["Standalone Yul", String(gasUsedSA)]], category="Pay out", fileName="crowdfunding/gasCostsCrowdfunding")




    // #################
    // #### REFUND #####
    // #################

    // For the refund, another set of crowdfunding have to be created, as the pay out and refund functions can't be called in the
    // same context
    // load two crowdfunding contracts manually
    Crowdfunding = await loadContract("Crowdfunding", 1, undefined, false, true)
    crowdfunding = await Crowdfunding.deploy(1000000000000000, 1)
    await crowdfunding.deployed()
    await crowdfunding.deployTransaction.wait()
    console.log(`Crowdfunding successfully deployed to ${crowdfunding.address}`);
    crowdfundingSec = await loadContract("Crowdfunding", 2, crowdfunding.address, false, false)
    
    
    // load two ASM crowdfunding contracts manually
    CrowdfundingASM = await loadContract("CrowdfundingASM", 1, undefined, false, true)
    crowdfundingASM = await CrowdfundingASM.deploy(1000000000000000, 1)
    await crowdfundingASM.deployed()
    await crowdfundingASM.deployTransaction.wait()
    console.log(`CrowdfundingASM successfully deployed to ${crowdfundingASM.address}`);
    crowdfundingASMSec = await loadContract("CrowdfundingASM", 2, crowdfundingASM.address, false, false)
    
    
    // load two SA crowdfunding contracts manually
    CrowdfundingSA = await loadContract("CrowdfundingSA", 1, undefined, true, true)
    crowdfundingSA = await CrowdfundingSA.deploy(1000000000000000, 1)
    await crowdfundingSA.deployed();
    await crowdfundingSA.deployTransaction.wait();
    console.log(`CrowdfundingSA successfully deployed to ${crowdfundingSA.address}`);
    crowdfundingSASec = await loadContract("CrowdfundingSA", 2, crowdfundingSA.address, true)

        

    // fund all three contracts again
    transactionSol = await crowdfundingSec.fund(
        { value: hre.ethers.utils.parseEther("0.0005")}
    )
    transactionASM = await crowdfundingASMSec.fund(
        { value: hre.ethers.utils.parseEther("0.0005")}
    )
    transactionSA = await crowdfundingSASec.fund(
        { value: hre.ethers.utils.parseEther("0.0005")}
    )

    
    await sleep(15) // sleep for 15 seconds until the project has expired


    // test the Sol refund
    console.log("\nTesting the Sol refund function ...")
    transactionSol = await crowdfundingSec.refund()
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = receiptSol.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsedSol}`)


    // test the ASM refund
    console.log("\nTesting the ASM refund function ...")
    transactionASM = await crowdfundingASMSec.refund()
    // log gas costs
    receiptASM = await transactionASM.wait()
    gasUsedASM = receiptASM.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsedASM}`)


    // test the SA refund
    console.log("\nTesting the SA refund function ...")
    transactionSA = await crowdfundingSASec.refund()
    // log gas costs
    receiptSA = await transactionSA.wait()
    gasUsedSA = receiptSA.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsedSA}`)
    

    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`)
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`)
    writeToCSV([["Solidity", String(gasUsedSol)], ["Inline assembly", String(gasUsedASM)], ["Standalone Yul", String(gasUsedSA)]], category="Refund", fileName="crowdfunding/gasCostsCrowdfunding")
}


main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});


function sleep(seconds) {
    // sleep for set amount of time
    return new Promise(resolve => setTimeout(resolve, seconds*1000));
}