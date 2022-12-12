// require the Hardhat Runtime Environment explicitly
// optional, but useful for running script in standalone fashion through `node <script>`
const hre = require("hardhat");
const { loadContract, calculateGasSavings, writeToCSV } = require('./scriptHelpers.js');


async function main() {
    // load the contracts
    const arithmetics = await loadContract("Arithmetics", 0, undefined, false, false);
    const arithmeticsASM = await loadContract("ArithmeticsASM", 0, undefined, false, false);
    const arithmeticsSA = await loadContract("ArithmeticsSA", 0, undefined, true, false)


    // ###################
    // #### ADDITION #####
    // ###################

    // test the Sol add method
    console.log("Add Sol ...")
    let transactionSol = await arithmetics.addSol(6, 3)
    // log gas costs
    let receiptSol = await transactionSol.wait()
    let gasUsedSol = receiptSol.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedSol}`)

    // test the ASM add method
    console.log("\nAdd ASM ...")
    let transactionASM = await arithmeticsASM.addASM(6, 3)
    // log gas costs
    let receiptASM = await transactionASM.wait()
    let gasUsedASM = receiptASM.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedASM}`)

    // test the SA add method
    console.log("\nAdd SA ...")
    let transactionSA = await arithmeticsSA.addYul(6, 3)
    // log gas costs
    let receiptSA = await transactionSA.wait()
    let gasUsedSA = receiptSA.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedSA}`)

    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`)
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`)
    writeToCSV([["addSol", String(gasUsedSol)], ["addASM", String(gasUsedASM)], ["addSA", String(gasUsedSA)]])




    // ######################
    // #### SUBTRACTION #####
    // ######################

    // test the Sol sub method
    console.log("\nSub Sol ...")
    transactionSol = await arithmetics.subSol(6, 3)
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = receiptSol.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedSol}`)

    // test the ASM sub method
    console.log("\nSub ASM ...")
    transactionASM = await arithmeticsASM.subASM(6, 3)
    // log gas costs
    receiptASM = await transactionASM.wait()
    gasUsedASM = receiptASM.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedASM}`)

    // test the SA sub method
    console.log("\nSub SA ...")
    transactionSA = await arithmeticsSA.subYul(6, 3)
    // log gas costs
    receiptSA = await transactionSA.wait()
    gasUsedSA = receiptSA.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedSA}`)

    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`)
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`)
    writeToCSV([["subSol", String(gasUsedSol)], ["subASM", String(gasUsedASM)], ["subSA", String(gasUsedSA)]])




    // #########################
    // #### MULTIPLICATION #####
    // #########################

    // test the Sol mul method
    console.log("\nMul Sol ...")
    transactionSol = await arithmetics.mulSol(6, 3)
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = receiptSol.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedSol}`)

    // test the ASM sub method
    console.log("\nMul ASM ...")
    transactionASM = await arithmeticsASM.subASM(6, 3)
    // log gas costs
    receiptASM = await transactionASM.wait()
    gasUsedASM = receiptASM.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedASM}`)

    // test the SA sub method
    console.log("\nMul SA ...")
    transactionSA = await arithmeticsSA.subYul(6, 3)
    // log gas costs
    receiptSA = await transactionSA.wait()
    gasUsedSA = receiptSA.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedSA}`)

    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`)
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`)
    writeToCSV([["mulSol", String(gasUsedSol)], ["mulASM", String(gasUsedASM)], ["mulSA", String(gasUsedSA)]])
    



    // ###################
    // #### DIVISION #####
    // ###################

    // test the Sol div method
    console.log("\nDiv Sol ...")
    transactionSol = await arithmetics.divSol(6, 3)
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = receiptSol.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedSol}`)

    // test the ASM div method
    console.log("\nDiv ASM ...")
    transactionASM = await arithmeticsASM.divASM(6, 3)
    // log gas costs
    receiptASM = await transactionASM.wait()
    gasUsedASM = receiptASM.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedASM}`)

    // test the SA sub method
    console.log("\nDiv SA ...")
    transactionSA = await arithmeticsSA.divYul(6, 3)
    // log gas costs
    receiptSA = await transactionSA.wait()
    gasUsedSA = receiptSA.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedSA}`)

    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`)
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`)
    writeToCSV([["divSol", String(gasUsedSol)], ["divASM", String(gasUsedASM)], ["divSA", String(gasUsedSA)]])
    



    // #########################
    // #### EXPONENTIATION #####
    // #########################

    // test the Sol exp method
    console.log("\nExp Sol ...")
    transactionSol = await arithmetics.expSol(6, 3)
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = receiptSol.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedSol}`)

    // test the ASM exp method
    console.log("\nExp ASM ...")
    transactionASM = await arithmeticsASM.expASM(6, 3)
    // log gas costs
    receiptASM = await transactionASM.wait()
    gasUsedASM = receiptASM.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedASM}`)

    // test the SA sub method
    console.log("\nExp SA ...")
    transactionSA = await arithmeticsSA.expYul(6, 3)
    // log gas costs
    receiptSA = await transactionSA.wait()
    gasUsedSA = receiptSA.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedSA}`)

    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`)
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`)
    writeToCSV([["expSol", String(gasUsedSol)], ["expASM", String(gasUsedASM)], ["expSA", String(gasUsedSA)]])
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
