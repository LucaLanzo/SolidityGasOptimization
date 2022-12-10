// require the Hardhat Runtime Environment explicitly
// optional, but useful for running script in standalone fashion through `node <script>`
const hre = require("hardhat");
const { loadContract, calculateGasSavings, writeToCSV } = require('./scriptHelpers.js');


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

    // test the view method
    console.log("\nCalling view function ...")
    let transaction = await crowdfunding.viewProject()
    console.log(transaction.toString())

    // test the ASM view method
    console.log("\nCalling ASM view function ...")
    transaction = await crowdfundingASM.viewProject()
    console.log(transaction.toString())

    // test the SA view method
    console.log("\nCalling SA view function ...")
    transaction = await crowdfundingSA.viewProject()
    console.log(transaction.toString())



    // ##################
    // #### FUNDING #####
    // ##################

    // test the funding
    console.log("\nTesting the funding function ...")
    transaction = await crowdfundingSec.fund(
        { value: hre.ethers.utils.parseEther("0.05")}
    )
    // log gas costs
    let receipt = await transaction.wait()
    let gasUsed = receipt.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsed}`)

    // test the ASM funding
    console.log("\nTesting the ASM funding function ...")
    transaction = await crowdfundingASMSec.fund(
        { value: hre.ethers.utils.parseEther("0.05")}
    )
    // log gas costs
    receipt = await transaction.wait()
    gasUsed = receipt.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsed}`)

    // test the SA funding
    console.log("\nTesting the SA funding function ...")
    transaction = await crowdfundingSASec.fund(
        { value: hre.ethers.utils.parseEther("0.05")}
    )
    // log gas costs
    receipt = await transaction.wait()
    gasUsed = receipt.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsed}`)
    


    // #################
    // #### PAYOUT #####
    // #################
    
    // test the payOut
    console.log("\nTesting the payOut function ...")
    transaction = await crowdfunding.payOut()
    // log gas costs
    receipt = await transaction.wait()
    gasUsed = receipt.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsed}`)

    // test the ASM payOut
    console.log("\nTesting the ASM payOut function ...")
    transaction = await crowdfundingASM.payOut()
    // log gas costs
    receipt = await transaction.wait()
    gasUsed = receipt.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsed}`)

    // test the SA payOut
    console.log("\nTesting the SA payOut function ...")
    transaction = await crowdfundingSA.payOut()
    // log gas costs
    receipt = await transaction.wait()
    gasUsed = receipt.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsed}`)
    

    // console.log(`\nYul saved ${calculateGasSavings(gasUsedSol, gasUsedYul)}% gas.`)

    // save the results into the csv file
    // writeToCSV([["onlyOwnerSol", String(gasUsedSol)], ["onlyOwnerYul", String(gasUsedYul)]])
}


main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
