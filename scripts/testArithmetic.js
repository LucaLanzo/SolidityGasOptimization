const hre = require("hardhat");


async function main() {
    const accounts = await hre.ethers.getSigners()
    const testAccount1 = accounts[0];
    
    const ArithmeticTest = await hre.ethers.getContractFactory("ArithmeticTest")
    const arithmeticTest = await ArithmeticTest.deploy()
    
    // deploy the contract
    await arithmeticTest.deployed();

    console.log(`ArithmeticTest successfully deployed to ${arithmeticTest.address}`);
  

    // listen to the event trigger which
    arithmeticTest.on("Successful", (number) => {
        console.log(`onlyOwnerTestSol successful: ${number}`);
    });

    const a = 6;
    const b = 3;

    // test the Sol add method
    console.log("###\nAdd Solidity ...")
    let transactionSol = await arithmeticTest.addSol(a, b)
    // log gas costs
    let receiptSol = await transactionSol.wait()
    let gasUsedSol = BigInt(receiptSol.cumulativeGasUsed) * BigInt(receiptSol.effectiveGasPrice);
    
    console.log(`... done. Gas used: ${gasUsedSol}`)


    // test the Yul add method
    console.log("\n\n###\nAdd Yul ...")
    let transactionYul = await onlyOwnerTestYul.addYul(a, b)
    // log gas costs
    let receiptYul = await transactionYul.wait()
    let gasUsedYul = BigInt(receiptYul.cumulativeGasUsed) * BigInt(receiptYul.effectiveGasPrice);
    
    console.log(`... done. Gas used: ${gasUsedYul}`)


    // test the Sol method
    console.log("###\nSub Solidity ...")
    transactionSol = await addTest.subSol(a, b)
    // log gas costs
    receiptSol = await transactionSol.wait()
    gasUsedSol = BigInt(receiptSol.cumulativeGasUsed) * BigInt(receiptSol.effectiveGasPrice);
    
    console.log(`... done. Gas used: ${gasUsedSol}`)


    // test the Yul method
    console.log("\n\n###\nSub Yul ...")
    transactionYul = await onlyOwnerTestYul.subYul(a, b)
    // log gas costs
    receiptYul = await transactionYul.wait()
    gasUsedYul = BigInt(receiptYul.cumulativeGasUsed) * BigInt(receiptYul.effectiveGasPrice);
    
    console.log(`... done. Gas used: ${gasUsedYul}`)
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
