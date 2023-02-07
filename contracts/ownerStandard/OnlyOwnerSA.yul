object "OnlyOwnerSA" {
    code {
        sstore(0, caller()) 

        let ds := datasize("runtime")
        codecopy(0, dataoffset("runtime"), ds)
        return(0, ds)
    }

    object "runtime" {
        code {
            if eq(0x682ef68d, shr(224, calldataload(0))) /* --- ownerTest --- */ {
                
                if xor(caller(), sload(0)) {
                    // the caller is not the stored owner, revert if xor() == 1
                    revert(0, 0)
                }
                return(0, 0)

            }

            // default
            revert(0, 0)
        }
    }
}