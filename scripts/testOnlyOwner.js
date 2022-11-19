// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");


async function main() {
    const accounts = await hre.ethers.getSigners()
    const testAccount1 = accounts[0];
    
    const OnlyOwnerTestSol = await hre.ethers.getContractFactory("OnlyOwnerTestSol")
    const onlyOwnerTestSol = await OnlyOwnerTestSol.deploy()

    const OnlyOwnerTestYul = await hre.ethers.getContractFactory("OnlyOwnerTestYul")
    const onlyOwnerTestYul = await OnlyOwnerTestYul.deploy();
    
    // deploy both contracts
    await onlyOwnerTestSol.deployed();
    await onlyOwnerTestYul.deployed();

    console.log(`OnlyOwnerTestSol successfully deployed to ${onlyOwnerTestSol.address}`);
    console.log(`OnlyOwnerTestYul successfully deployed to ${onlyOwnerTestYul.address}`);
  

    // listen to the event which logs the number 1 if the method was successful
    onlyOwnerTestSol.on("Successful", (number) => {
        console.log(`onlyOwnerTestSol successful: ${number}`);
    });

    // listen to the event which logs the number 1 if the method was successful
    onlyOwnerTestYul.on("Successful", (number) => {
        console.log(`onlyOwnerTestYul successful: ${number}`);
    })
    

    // test the Sol method
    console.log("###\nCalling empty onlyOwner solidity method ...")
    const transactionSol = await onlyOwnerTestSol.ownerTest()
    // log gas costs
    const receiptSol = await transactionSol.wait()
    const gasUsedSol = BigInt(receiptSol.cumulativeGasUsed) * BigInt(receiptSol.effectiveGasPrice);
    
    console.log(`.. done. Gas used: ${gasUsedSol}`)


    // test the Yul method
    console.log("\n\n###\nCalling empty onlyOwner yul method ...")
    const transactionYul = await onlyOwnerTestYul.ownerTest()
    // log gas costs
    const receiptYul = await transactionYul.wait()
    const gasUsedYul = BigInt(receiptYul.cumulativeGasUsed) * BigInt(receiptYul.effectiveGasPrice);
    
    console.log(`.. done. Gas used: ${gasUsedYul}`)
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
