// require the Hardhat Runtime Environment explicitly
// optional, but useful for running script in standalone fashion through `node <script>`
const hre = require("hardhat");
const { loadContract, calculateGasSavings, writeToCSV } = require('../scriptHelpers.js');


async function main() {
    // load the contracts
    const arithmetics = await loadContract("Arithmetics", 1, undefined, false, false);
    const arithmeticsASM = await loadContract("ArithmeticsASM", 1, undefined, false, false);
    const arithmeticsSA = await loadContract("ArithmeticsSA", 1, undefined, true, false)


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

    // test the Sol unchecked add method
    console.log("\nAdd Sol unchecked ...")
    let transactionSolUnchecked = await arithmetics.addSolUnchecked(6, 3)
    // log gas costs
    let receiptSolUnchecked = await transactionSolUnchecked.wait()
    let gasUsedSolUnchecked = receiptSolUnchecked.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedSolUnchecked}`)

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
    writeToCSV([["Solidity", String(gasUsedSol)], ["Solidity unchecked", String(gasUsedSolUnchecked)], ["Inline assembly", String(gasUsedASM)], ["Standalone Yul", String(gasUsedSA)]], category="Addition", fileName="arithmetics/gasCostsArithmetics")




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

    // test the Sol unchecked sub method
    console.log("\nSub Sol unchecked ...")
    transactionSolUnchecked = await arithmetics.subSolUnchecked(6, 3)
    // log gas costs
    receiptSolUnchecked = await transactionSolUnchecked.wait()
    gasUsedSolUnchecked = receiptSolUnchecked.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedSolUnchecked}`)

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
    writeToCSV([["Solidity", String(gasUsedSol)], ["Solidity unchecked", String(gasUsedSolUnchecked)], ["Inline assembly", String(gasUsedASM)], ["Standalone Yul", String(gasUsedSA)]], category="Subtraction", fileName="arithmetics/gasCostsArithmetics")




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

    // test the Sol unchecked mul method
    console.log("\nMul Sol unchecked ...")
    transactionSolUnchecked = await arithmetics.mulSolUnchecked(6, 3)
    // log gas costs
    receiptSolUnchecked = await transactionSolUnchecked.wait()
    gasUsedSolUnchecked = receiptSolUnchecked.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedSolUnchecked}`)

    // test the ASM mul method
    console.log("\nMul ASM ...")
    transactionASM = await arithmeticsASM.mulASM(6, 3)
    // log gas costs
    receiptASM = await transactionASM.wait()
    gasUsedASM = receiptASM.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedASM}`)

    // test the SA mul method
    console.log("\nMul SA ...")
    transactionSA = await arithmeticsSA.mulYul(6, 3)
    // log gas costs
    receiptSA = await transactionSA.wait()
    gasUsedSA = receiptSA.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedSA}`)

    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`)
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`)
    writeToCSV([["Solidity", String(gasUsedSol)], ["Solidity unchecked", String(gasUsedSolUnchecked)], ["Inline assembly", String(gasUsedASM)], ["Standalone Yul", String(gasUsedSA)]], category="Multiplication", fileName="arithmetics/gasCostsArithmetics")




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

    // test the Sol unchecked div method
    console.log("\nDiv Sol unchecked ...")
    transactionSolUnchecked = await arithmetics.divSolUnchecked(6, 3)
    // log gas costs
    receiptSolUnchecked = await transactionSolUnchecked.wait()
    gasUsedSolUnchecked = receiptSolUnchecked.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedSolUnchecked}`)

    // test the ASM div method
    console.log("\nDiv ASM ...")
    transactionASM = await arithmeticsASM.divASM(6, 3)
    // log gas costs
    receiptASM = await transactionASM.wait()
    gasUsedASM = receiptASM.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedASM}`)

    // test the SA div method
    console.log("\nDiv SA ...")
    transactionSA = await arithmeticsSA.divYul(6, 3)
    // log gas costs
    receiptSA = await transactionSA.wait()
    gasUsedSA = receiptSA.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedSA}`)

    // calculate gas savings and save to .csv
    console.log(`\nASM saved ${calculateGasSavings(gasUsedSol, gasUsedASM)}% gas.`)
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`)
    writeToCSV([["Solidity", String(gasUsedSol)], ["Solidity unchecked", String(gasUsedSolUnchecked)], ["Inline assembly", String(gasUsedASM)], ["Standalone Yul", String(gasUsedSA)]], category="Division", fileName="arithmetics/gasCostsArithmetics")




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

    // test the Sol unchecked exp method
    console.log("\nExp Sol unchecked ...")
    transactionSolUnchecked = await arithmetics.expSolUnchecked(6, 3)
    // log gas costs
    receiptSolUnchecked = await transactionSolUnchecked.wait()
    gasUsedSolUnchecked = receiptSolUnchecked.cumulativeGasUsed;
    console.log(`... done. Gas used: ${gasUsedSolUnchecked}`)

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
    writeToCSV([["Solidity", String(gasUsedSol)], ["Solidity unchecked", String(gasUsedSolUnchecked)], ["Inline assembly", String(gasUsedASM)], ["Standalone Yul", String(gasUsedSA)]], category="Exponentiation", fileName="arithmetics/gasCostsArithmetics")

}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
