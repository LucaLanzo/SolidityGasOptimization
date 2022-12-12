// require the Hardhat Runtime Environment explicitly
// optional, but useful for running script in standalone fashion through `node <script>`
const hre = require("hardhat");
const { loadContract, calculateGasSavings, writeToCSV } = require('./scriptHelpers.js');


async function main() {
    // #################
    // #### DEPLOY #####
    // #################
    
    // test the Sol deploy
    console.log("Deploy contract with Sol ...")
    const ContractCreation = await loadContract("ContractCreation", 0, undefined, false, true);
    const contractCreation = await ContractCreation.deploy()
    
    console.log(`ContractCreation successfully deployed to ${contractCreation.address}`);

    const gasUsedSol = contractCreation.deployTransaction.gasLimit
    console.log(`... done. Gas used: ${gasUsedSol}`)

    // test the SA deploy
    console.log("Deploy contract with SA ...")
    const ContractCreationSA = await loadContract("ContractCreationSA", 0, undefined, true, true);
    const contractCreationSA = await ContractCreationSA.deploy()

    console.log(`ContractCreationSA successfully deployed to ${contractCreationSA.address}`);

    const gasUsedSA = contractCreationSA.deployTransaction.gasLimit
    console.log(`... done. Gas used: ${gasUsedSA}`)


    // calculate gas savings and save to .csv
    console.log(`\nSA saved ${calculateGasSavings(gasUsedSol, gasUsedSA)}% gas.`)
    writeToCSV([["deploySol", String(gasUsedSol)], ["deploySA", String(gasUsedSA)]])
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
