require("@nomicfoundation/hardhat-toolbox");
require("@tovarishfin/hardhat-yul");
require("@nomiclabs/hardhat-ethers");

module.exports = {
    defaultNetwork: "ganache",
    networks: {
        ganache: {
            url: 'http://127.0.0.1:8545',
            chain_id: 1337
        }
    },
    
    solidity: {
        version: '0.8.17',
        settings: {
            optimizer: {
                enabled: true,
                runs: 800,
            },
        },
    },
}
