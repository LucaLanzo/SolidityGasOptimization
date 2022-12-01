
export async function loadContract(argv, abi, account, argvNumber = 0) {
    // skip the first two default args
    const argv = process.argv.slice(2)
    
    // if the contract should not be redeployed, the command line arguments need at least a contract address
    if (argv.length == 0) {
        console.log("No deploy statement or contract address has been provided.\nProvide args with 'd' to deploy or give an existing contract address.");
        return
    }
    

    // get all signed accounts in the network and choose the first test account
    const accounts = await hre.ethers.getSigners()
    const testAccount1 = accounts[account];


    // check the command line arguments whether the contract should be redeployed or not
    if (argv[argvNumber].toString() == "deploy" || argv[argvNumber].toString() == "d") {      
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


export function calculateGasSavings(gasUsedSol, gasUsedYul) {
    // calculate the gas savings in percent: delta * 100 / base
    const percentage = (gasUsedSol-gasUsedYul) * 100 / gasUsedSol

    // before returning the percentage, round to the two nearest decimals
    return Math.round((percentage + Number.EPSILON) * 100) / 100
}