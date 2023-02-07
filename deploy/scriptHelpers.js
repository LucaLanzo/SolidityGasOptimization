const hre = require("hardhat")
const fileWriter = require('fs')
const buffer = require('buffer')

async function loadContract(abi, account, customAddress=undefined, deployYul=false, constructorArgs=false) {
    // skip the first two default args
    var argumentsList = process.argv.slice(2)

    // get all signed accounts in the network and choose the first test account
    const accounts = await hre.ethers.getSigners()
    const testAccount = accounts[account-1];

    // check the command line arguments whether the contract should be redeployed or not
    if (argumentsList.length == 0 && customAddress === undefined) {      
        
        let Contract;
        
        if (!deployYul) {
            Contract = await hre.ethers.getContractFactory(abi, testAccount)
        } else {
            let abiFile = require(`../build/${abi}.abi.json`)
            let bytecode = require(`../build/${abi}.bytecode.json`)

            Contract = await hre.ethers.getContractFactory(abiFile, bytecode, testAccount)
        }

        // if a constructor needs to be specified, return the contract factory to the deploy file
        if (constructorArgs) { return Contract }

        const contract = await Contract.deploy()
        
        await contract.deployed();
        await contract.deployTransaction.wait();

        console.log(`${abi} successfully deployed to ${contract.address}`);

        return contract;

    } else {

        // load the specified contract from the first test account
        let contract;
        let address;

        // if it shouldn't be deployed, get the contract address from argv or through the custom address
        if (customAddress === undefined) {
            address = argumentsList[0].toString();
        } else {
            address = customAddress;
        }

        if (!deployYul) {
            contract = await hre.ethers.getContractAt(abi, address, testAccount)
        } else {
            let abiFile = require(`../build/${abi}.abi.json`)

            contract = await hre.ethers.getContractAt(abiFile, address, testAccount)
        }
        
        return contract;

    }
    
}



function calculateGasSavings(gasUsedSol, gasUsedYul) {
    // calculate the gas savings in percent: delta * 100 / base
    const percentage = ((gasUsedSol-21000)-(gasUsedYul-21000)) * 100 / (gasUsedSol-21000)

    // before returning the percentage, round to the two nearest decimals
    return Math.round((percentage + Number.EPSILON) * 100) / 100
}


function writeToCSV(data) {
    let csv = "";

    data.forEach( array => {
        csv += array.join(",")+"\n";
    });

    fileWriter.writeFile('./results/globalGasCosts.csv', csv, { flag: 'a+'}, err => {
        if (err) {
          console.error(err);
        } else {
            console.log("Write to CSV successful");
        }
    });
}

module.exports = { loadContract, calculateGasSavings, writeToCSV };