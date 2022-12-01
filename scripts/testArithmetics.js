// require the Hardhat Runtime Environment explicitly
// optional, but useful for running script in standalone fashion through `node <script>`
const hre = require("hardhat");
import { loadContract, calculateGasSavings } from './scriptHelpers.js'


async function main() {
    
    const argv = process.argv.slice(2)
    // if the contract should not be redeployed, the command line arguments need at least a contract address
    if (argv.length == 0) {
        console.log("No deploy statement or contract address has been provided");
        return
    }

    // load the contract
    const arithmetics = await loadContract(argv[0], "Arithmetics", 0);



    // ### ADDITION ###

    // test the Sol add method
    console.log("Add Solidity ...")
    let transactionSol = await arithmetics.addSol(6, 3)
    // log gas costs
    let receiptSol = await transactionSol.wait()
    let gasUsedSol = receiptSol.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedSol}`)

    // test the Yul add method
    console.log("\nAdd Yul ...")
    let transactionYul = await arithmetics.addYul(6, 3)
    // log gas costs
    let receiptYul = await transactionYul.wait()
    let gasUsedYul = receiptYul.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedYul}`)

    console.log(`\nYul saved ${calculateGasSavings(gasUsedSol, gasUsedYul)}% gas.`)


    
    // ### SUBTRACTION ###

    // test the Sol sub method
    console.log("\n\nSub Solidity ...")
    transactionSol = await arithmetics.subSol(6, 3)
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = receiptSol.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedSol}`)

    
    // test the Yul sub method
    console.log("\nSub Yul ...")
    transactionYul = await arithmetics.subYul(6, 3)
    // log gas costs
    receiptYul = await transactionYul.wait()
    gasUsedYul = receiptYul.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedYul}`)

    console.log(`\nYul saved ${calculateGasSavings(gasUsedSol, gasUsedYul)}% gas.`)
    


    // ### MULTIPLICATION ###

    // test the Sol mul method
    console.log("\n\nMul Solidity ...")
    transactionSol = await arithmetics.mulSol(6, 3)
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = receiptSol.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedSol}`)

    
    // test the Yul mul method
    console.log("\nMul Yul ...")
    transactionYul = await arithmetics.mulYul(6, 3)
    // log gas costs
    receiptYul = await transactionYul.wait()
    gasUsedYul = receiptYul.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedYul}`)

    console.log(`\nYul saved ${calculateGasSavings(gasUsedSol, gasUsedYul)}% gas.`)



    // ### DIVISION ###

    // test the Sol div method
    console.log("\n\nDiv Solidity ...")
    transactionSol = await arithmetics.divSol(6, 3)
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = receiptSol.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedSol}`)

    
    // test the Yul div method
    console.log("\nDiv Yul ...")
    transactionYul = await arithmetics.divYul(6, 3)
    // log gas costs
    receiptYul = await transactionYul.wait()
    gasUsedYul = receiptYul.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedYul}`)

    console.log(`\nYul saved ${calculateGasSavings(gasUsedSol, gasUsedYul)}% gas.`)



    // ### EXPONENTIATION ###

    // test the Sol exp method
    console.log("\n\nExp Solidity ...")
    transactionSol = await arithmetics.expSol(6, 3)
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = receiptSol.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedSol}`)

    
    // test the Yul exp method
    console.log("\nExp Yul ...")
    transactionYul = await arithmetics.expYul(6, 3)
    // log gas costs
    receiptYul = await transactionYul.wait()
    gasUsedYul = receiptYul.cumulativeGasUsed;
    
    console.log(`... done. Gas used: ${gasUsedYul}`)

    console.log(`\nYul saved ${calculateGasSavings(gasUsedSol, gasUsedYul)}% gas.`)
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
