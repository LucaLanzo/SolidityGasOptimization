// require the Hardhat Runtime Environment explicitly
// optional, but useful for running script in standalone fashion through `node <script>`
const hre = require("hardhat");
const { loadContract, calculateGasSavings, writeToCSV } = require('./scriptHelpers.js');


async function main() {
    
    // load the contracts manually because of the constructor
    

    const CrowdfundingSA = await loadContract("CrowdfundingSA", 1, undefined, true, true)
    const crowdfundingSA = await CrowdfundingSA.deploy("CrowdfundingSA", "CrowdfundingSA descr", hre.ethers.utils.parseEther("100"), hre.ethers.utils.parseEther("3"))
    await crowdfundingSA.deployed();
    await crowdfundingSA.deployTransaction.wait();

    console.log(`CrowdfundingSA successfully deployed to ${crowdfundingSA.address}`);

    const crowdfundingSASecondAcc = await loadContract("CrowdfundingSA", 2, crowdfundingSA.address, true)
    

    // test the view method
    console.log("Calling view function ...")
    let transaction = await crowdfundingSA.viewProject()
    console.log(transaction)


    // test the funding
    console.log("Testing the funding function ...")
    transaction = await crowdfundingSASecondAcc.fund(
        { value: hre.ethers.utils.parseEther("0.05")}
    )
    // log gas costs
    let receipt = await transaction.wait()
    let gasUsed = receipt.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsed}`)
    
    
    // test the funding
    console.log("Testing the payOut function ...")
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
