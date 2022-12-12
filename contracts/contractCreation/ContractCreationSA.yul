object "ContractCreationSA" {
    code {
        // deploy the main contract
        let ds := datasize("ContractCreationSAruntime")
        codecopy(0, dataoffset("ContractCreationSAruntime"), ds)
        return(0, ds)
    }

    object "ContractCreationSAruntime" {
        code {
            if eq(0x6cd5c39b, shr(224, calldataload(0))) /* --- deployContract() --- */ {
                let fmp := mload(0x40)

                let ds := datasize("CreatedContractSA")   

                // copy the contract code runtime to memory    
                datacopy(fmp, dataoffset("CreatedContractSA"), ds)

                if iszero(create(0, fmp, ds)) {
                    // create: deploy the contract and check for errors
                    returndatacopy(fmp, 0, returndatasize())
                    revert(fmp, returndatasize())
                }
                return(0, 0)
            }

            revert(0, 0)
        }
        
        object "CreatedContractSA" {
            code {            
                sstore(0, 0x00)

                let ds := datasize("CreatedContractSAruntime")
                codecopy(0, dataoffset("CreatedContractSAruntime"), ds)
                return(0, ds)            
            }

            object "CreatedContractSAruntime" {
                code {      
                    // every Yul contract needs to end with revert(0, 0) if nothing happens         
                    revert(0, 0)
                }
            }
        }
    }   
}