module.exports = {
    defaultNetwork: "ganache",
    networks: {
        hardhat: {
            allowUnlimitedContractSize: false,
        },
        ganache: {
            url: 'http://127.0.0.1:8545',
            chain_id: 1337,
            accounts: [
                '0xde10decc97b284f25bb8a93eda59cbdd8880d016b060fd06fc066debffed4654',
                '0xcf8d6d6403571476f27bac645e7e8a5ea2a7bf1e7ffe0b54a3e4f4513bd4224e'
            ]
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
