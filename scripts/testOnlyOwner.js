// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");


async function main() {
    const argv = process.argv.slice(2)
    // if the contract should not be redeployed, the command line arguments need at least a contract address
    if (argv.length < 2) {
        console.log("No deploy statement or contract address has been provided");
        return
    }

    // load the contracts
    const onlyOwnerTestSol = await loadContract(argv[0], "OnlyOwnerTestSol");
    const onlyOwnerTestYul = await loadContract(argv[1], "OnlyOwnerTestYul")
    
    
    // test the Sol method
    console.log("Calling empty onlyOwner solidity method ...")
    const transactionSol = await onlyOwnerTestSol.ownerTest()
    // log gas costs
    const receiptSol = await transactionSol.wait()
    const gasUsedSol = receiptSol.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsedSol}`)


    // test the Yul method
    console.log("\n\nCalling empty onlyOwner yul method ...")
    const transactionYul = await onlyOwnerTestYul.ownerTest()
    // log gas costs
    const receiptYul = await transactionYul.wait()
    const gasUsedYul = receiptYul.cumulativeGasUsed;
    
    console.log(`.. done. Gas used: ${gasUsedYul}`)

    console.log(`\nYul saved ${calculateGasSavings(gasUsedSol, gasUsedYul)}% gas.`)
}


async function loadContract(argv, abi) {
    // get all signed accounts in the network and choose the first test account
    const accounts = await hre.ethers.getSigners()
    const testAccount1 = accounts[0];

    
    // check the command line arguments whether the contract should be redeployed or not
    if (argv.toString() == "deploy" || argv.toString() == "d") {      
        // get the abi of the contract and deploy it
        const Contract = await hre.ethers.getContractFactory(abi, testAccount1)
        const contract = await Contract.deploy()
        
        await contract.deployed();
        await contract.deployTransaction.wait();

        console.log(`${abi} successfully deployed to ${contract.address}`);

        return contract;
    } else {
        // load the specified contract from the first test account
        const contract = await hre.ethers.getContractAt(abi, argv.toString(), testAccount1)
        
        return contract;
    }
}


function calculateGasSavings(gasUsedSol, gasUsedYul) {
    // calculate the gas savings in percent: delta * 100 / base
    const percentage = (gasUsedSol-gasUsedYul) * 100 / gasUsedSol

    // before returning the percentage, round to the two nearest decimals
    return Math.round((percentage + Number.EPSILON) * 100) / 100
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
