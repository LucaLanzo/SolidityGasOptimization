// Custom YUL compiler

const path = require("path");
const fs = require("fs");
const solc = require("solc");

const outputPath = path.resolve(__dirname, "..", "build", "CrowdfundingSA.bytecode.json");

const inputPath = path.resolve(__dirname, "..", "contracts", "crowdfunding", "CrowdfundingSA.sol");
const source = fs.readFileSync(inputPath, "utf-8");

var input = {
    language: 'Yul',
    sources: {
        'CrowdfundingSA.sol' : {
            content: source
        }
    },
    settings: {
        outputSelection: {
            '*': {
                '*': [ "evm.bytecode" ]
            }
        }
    }
};

const compiledContract = solc.compile(JSON.stringify(input));

const bytecode = JSON.parse(compiledContract).contracts["CrowdfundingSA.sol"].CrowdfundingSA.evm.bytecode.object;

fs.writeFile(outputPath, JSON.stringify(bytecode), (err) => { console.log(compiledContract)});

console.log("Compile setup done.");
