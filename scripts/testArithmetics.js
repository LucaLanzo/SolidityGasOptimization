const hre = require("hardhat");


async function main() {
    const argv = process.argv.slice(2)
    // if the contract should not be redeployed, the command line arguments need at least a contract address
    if (argv.length == 0) {
        console.log("No deploy statement or contract address has been provided");
        return
    }

    // load the contract
    const arithmeticTest = await loadContract(argv[0], "Arithmetics");



    // ### ADDITION ###

    // test the Sol add method
    console.log("Add Solidity ...")
    let transactionSol = await arithmeticTest.addSol(6, 3)
    // log gas costs
    let receiptSol = await transactionSol.wait()
    let gasUsedSol = receiptSol.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedSol}`)

    // test the Yul add method
    console.log("\nAdd Yul ...")
    let transactionYul = await arithmeticTest.addYul(6, 3)
    // log gas costs
    let receiptYul = await transactionYul.wait()
    let gasUsedYul = receiptYul.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedYul}`)

    console.log(`\nYul saved ${calculateGasSavings(gasUsedSol, gasUsedYul)}% gas.`)


    
    // ### SUBTRACTION ###

    // test the Sol sub method
    console.log("\n\nSub Solidity ...")
    transactionSol = await arithmeticTest.subSol(6, 3)
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = receiptSol.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedSol}`)

    
    // test the Yul sub method
    console.log("\nSub Yul ...")
    transactionYul = await arithmeticTest.subYul(6, 3)
    // log gas costs
    receiptYul = await transactionYul.wait()
    gasUsedYul = receiptYul.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedYul}`)

    console.log(`\nYul saved ${calculateGasSavings(gasUsedSol, gasUsedYul)}% gas.`)
    


    // ### MULTIPLICATION ###

    // test the Sol mul method
    console.log("\n\nMul Solidity ...")
    transactionSol = await arithmeticTest.mulSol(6, 3)
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = receiptSol.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedSol}`)

    
    // test the Yul mul method
    console.log("\nMul Yul ...")
    transactionYul = await arithmeticTest.mulYul(6, 3)
    // log gas costs
    receiptYul = await transactionYul.wait()
    gasUsedYul = receiptYul.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedYul}`)

    console.log(`\nYul saved ${calculateGasSavings(gasUsedSol, gasUsedYul)}% gas.`)



    // ### DIVISION ###

    // test the Sol div method
    console.log("\n\nDiv Solidity ...")
    transactionSol = await arithmeticTest.divSol(6, 3)
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = receiptSol.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedSol}`)

    
    // test the Yul div method
    console.log("\nDiv Yul ...")
    transactionYul = await arithmeticTest.divYul(6, 3)
    // log gas costs
    receiptYul = await transactionYul.wait()
    gasUsedYul = receiptYul.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedYul}`)

    console.log(`\nYul saved ${calculateGasSavings(gasUsedSol, gasUsedYul)}% gas.`)



    // ### EXPONENTIATION ###

    // test the Sol exp method
    console.log("\n\nExp Solidity ...")
    transactionSol = await arithmeticTest.expSol(6, 3)
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = receiptSol.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedSol}`)

    
    // test the Yul exp method
    console.log("\nExp Yul ...")
    transactionYul = await arithmeticTest.expYul(6, 3)
    // log gas costs
    receiptYul = await transactionYul.wait()
    gasUsedYul = receiptYul.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedYul}`)

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
