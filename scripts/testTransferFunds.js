// require the Hardhat Runtime Environment explicitly
// optional, but useful for running script in standalone fashion through `node <script>`
const hre = require("hardhat");
import { loadContract, calculateGasSavings } from './scriptHelpers.js'


async function main() {    

    // load the contract
    const transferFunds = await loadContract(argv, "Yul", 0);
    // console.log(await yulTest.deployed())


    // test
    
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
