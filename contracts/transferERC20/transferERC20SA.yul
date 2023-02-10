object "transferERC20SA" {
    code {
        // deploy the main contract
        let ds := datasize("transferERC20SAruntime")
        codecopy(0, dataoffset("transferERC20SAruntime"), ds)
        return(0, ds)
    }

    object "transferERC20SAruntime" {
        code {
            switch (shr(224, calldataload(0))) {
                case 0x6cd5c39b {

                }

                default {
                    revert(0, 0)
                }
            }
        }
    }   
}