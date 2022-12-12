// Custom YUL compiler

var argumentsList = process.argv.slice(2)
if (argumentsList.length == 0) { console.log("Please specify in args: '<directory>' '<filenameWithoutExtension'."); return }
const filePath = argumentsList[0]
const fileName = argumentsList[1]
const fileNameWExt = argumentsList[1] + ".yul"

const path = require("path");
const fs = require("fs");
const solc = require("solc");

const outputPath = path.resolve(__dirname, "..", "build", `${fileName}.bytecode.json`);

const inputPath = path.resolve(__dirname, "..", "contracts", filePath, fileNameWExt);
const source = fs.readFileSync(inputPath, "utf-8");

console.log(source)

var input = {
    language: 'Yul',
    sources: {
        [fileNameWExt] : {
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

console.log(compiledContract)

const bytecode = JSON.parse(compiledContract).contracts[fileNameWExt][fileName].evm.bytecode.object;

fs.writeFile(outputPath, JSON.stringify(bytecode), (err) => { });

console.log("Compile setup done.");

