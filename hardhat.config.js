const { task } = require("hardhat/config");

require("@nomicfoundation/hardhat-toolbox");
require("@tovarishfin/hardhat-yul");
require("@nomiclabs/hardhat-ethers");


module.exports = {
    defaultNetwork: "localhost",
    networks: {
        hardhat: {
            chainId: 1337,
            forking: {
                url: "https://mainnet.infura.io/v3/8033ae5519e74bc784ea038df242d8b8",
                // blockNumber: 16046963 // 25.11.2022 - 13:21
            },
            gas: "auto",
            accounts: {
                mnemonic: "exhibit air raven loop into fetch license iron manual surround hold east",
                count: 2,
                accountsBalance: "1000000000000000000"
            },
            loggingEnabled: true // true by default on standalone hardhat node
        }
    },
    
    solidity: {
        version: '0.8.17',
        settings: {
            optimizer: {
                enabled: true,
                runs: 100000,
            },
        },
    },
}


task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
    const accounts = await hre.ethers.getSigners();
    const provider = hre.ethers.provider;

    for (const account of accounts) {
        console.log(
            "%s (%d ETH)",
            account.address,
            hre.ethers.utils.formatEther(
                // getBalance returns wei amount, format to ETH amount
                await provider.getBalance(account.address)
            )
        );
    }
});

