object "TransferFundsSA" {
    code {
        let ds := datasize("runtime")
        codecopy(0, dataoffset("runtime"), ds)
        return(0, ds)
    }

    object "runtime" {
        code {
            if eq(0x8b76b10a, shr(224, calldataload(0))) /* --- transferFundsYul --- */ {

                if iszero(call(0, and(calldataload(4), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), callvalue(), 0, 0, 0, 0)) {
                    revert(0, 0)
                }
                return(0, 0)
                
            }

            // default
            revert(0, 0)
        }
    }
}