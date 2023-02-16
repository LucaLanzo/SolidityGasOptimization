Optimized IR:
/// @use-src 0:"contracts/crowdfunding/CrowdfundingASM.sol"
object "CrowdfundingASM_53" {
    code {
        {
            /// @src 0:63:10302  "contract CrowdfundingASM {..."
            if callvalue() { revert(0, 0) }
            let programSize := datasize("CrowdfundingASM_53")
            let argSize := sub(codesize(), programSize)
            let newFreePtr := add(128, and(add(argSize, 31), not(31)))
            if or(gt(newFreePtr, sub(shl(64, 1), 1)), lt(newFreePtr, 128))
            {
                mstore(/** @src -1:-1:-1 */ 0, /** @src 0:63:10302  "contract CrowdfundingASM {..." */ shl(224, 0x4e487b71))
                mstore(4, 0x41)
                revert(/** @src -1:-1:-1 */ 0, /** @src 0:63:10302  "contract CrowdfundingASM {..." */ 0x24)
            }
            mstore(64, newFreePtr)
            codecopy(128, programSize, argSize)
            if slt(argSize, 64)
            {
                revert(/** @src -1:-1:-1 */ 0, 0)
            }
            /// @src 0:63:10302  "contract CrowdfundingASM {..."
            let value := mload(128)
            if iszero(eq(value, and(value, sub(shl(128, 1), 1))))
            {
                revert(/** @src -1:-1:-1 */ 0, 0)
            }
            /// @src 0:63:10302  "contract CrowdfundingASM {..."
            constructor_CrowdfundingASM(value, mload(160))
            let _1 := mload(64)
            let _2 := datasize("CrowdfundingASM_53_deployed")
            codecopy(_1, dataoffset("CrowdfundingASM_53_deployed"), _2)
            return(_1, _2)
        }
        /// @ast-id 37 @src 0:1324:2251  "constructor(uint128 _amountToRaise, uint256 _numberOfDaysUntilDeadline) {..."
        function constructor_CrowdfundingASM(var_amountToRaise, var_numberOfDaysUntilDeadline)
        {
            /// @src 0:1407:2244  "assembly {..."
            if iszero(var_amountToRaise)
            {
                mstore(0x80, 0x08c379a0)
                mstore(0x84, 32)
                mstore(0xA4, 30)
                mstore(0xC4, "Amount to raise smaller than 0")
                revert(0x80, 100)
            }
            sstore(0, caller())
            sstore(1, shl(128, var_amountToRaise))
            sstore(2, add(timestamp(), mul(var_numberOfDaysUntilDeadline, 86400)))
            sstore(3, timestamp())
        }
    }
    /// @use-src 0:"contracts/crowdfunding/CrowdfundingASM.sol"
    object "CrowdfundingASM_53_deployed" {
        code {
            {
                /// @src 0:63:10302  "contract CrowdfundingASM {..."
                let _1 := 128
                mstore(64, _1)
                if iszero(lt(calldatasize(), 4))
                {
                    let _2 := 0
                    switch shr(224, calldataload(_2))
                    case 0x590e1ae3 {
                        if callvalue() { revert(_2, _2) }
                        if slt(add(calldatasize(), not(3)), _2) { revert(_2, _2) }
                        /// @src 0:7944:10292  "assembly {..."
                        mstore(/** @src 0:63:10302  "contract CrowdfundingASM {..." */ _2, /** @src 0:7944:10292  "assembly {..." */ caller())
                        mstore(0x20, /** @src 0:63:10302  "contract CrowdfundingASM {..." */ 4)
                        /// @src 0:7944:10292  "assembly {..."
                        let usr$helper := keccak256(/** @src 0:63:10302  "contract CrowdfundingASM {..." */ _2, 64)
                        /// @src 0:7944:10292  "assembly {..."
                        let usr$individualAmountPaid := sload(usr$helper)
                        if iszero(usr$individualAmountPaid)
                        {
                            mstore(/** @src 0:63:10302  "contract CrowdfundingASM {..." */ _1, /** @src 0:7944:10292  "assembly {..." */ 0x08c379a0)
                            mstore(0x84, 0x20)
                            mstore(0xA4, 0x20)
                            mstore(0xC4, "Can't pay out you haven't funded")
                            revert(/** @src 0:63:10302  "contract CrowdfundingASM {..." */ _1, /** @src 0:7944:10292  "assembly {..." */ 100)
                        }
                        let usr$amountAndState := sload(1)
                        if and(gt(timestamp(), sload(2)), lt(selfbalance(), shr(/** @src 0:63:10302  "contract CrowdfundingASM {..." */ _1, /** @src 0:7944:10292  "assembly {..." */ usr$amountAndState)))
                        {
                            if xor(and(usr$amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 2)
                            {
                                usr$amountAndState := add(usr$amountAndState, 2)
                            }
                        }
                        if xor(and(usr$amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 2)
                        {
                            mstore(/** @src 0:63:10302  "contract CrowdfundingASM {..." */ _1, /** @src 0:7944:10292  "assembly {..." */ 0x08c379a0)
                            mstore(0x84, 0x20)
                            mstore(0xA4, 30)
                            mstore(0xC4, "The project hasn't expired yet")
                            revert(/** @src 0:63:10302  "contract CrowdfundingASM {..." */ _1, /** @src 0:7944:10292  "assembly {..." */ 100)
                        }
                        sstore(usr$helper, /** @src 0:63:10302  "contract CrowdfundingASM {..." */ _2)
                        /// @src 0:7944:10292  "assembly {..."
                        if iszero(call(/** @src 0:63:10302  "contract CrowdfundingASM {..." */ _2, /** @src 0:7944:10292  "assembly {..." */ caller(), usr$individualAmountPaid, /** @src 0:63:10302  "contract CrowdfundingASM {..." */ _2, _2, _2, _2))
                        /// @src 0:7944:10292  "assembly {..."
                        {
                            sstore(usr$helper, usr$individualAmountPaid)
                        }
                        if iszero(selfbalance())
                        {
                            sstore(1, add(usr$amountAndState, 1))
                        }
                        /// @src 0:63:10302  "contract CrowdfundingASM {..."
                        return(_2, _2)
                    }
                    case 0xb60d4288 { external_fun_fund() }
                    case 0xc2052403 { external_fun_payOut() }
                    case 0xca3c23c1 { external_fun_viewProject() }
                    case 0xf00b03d2 { external_fun_fundings() }
                }
                revert(0, 0)
            }
            function external_fun_fund()
            {
                let _1 := 0
                if slt(add(calldatasize(), not(3)), _1) { revert(_1, _1) }
                /// @src 0:2493:6045  "assembly {..."
                if iszero(callvalue())
                {
                    mstore(0x80, 0x08c379a0)
                    mstore(0x84, 32)
                    mstore(0xA4, 24)
                    mstore(0xC4, "Specify a funding amount")
                    revert(0x80, 100)
                }
                if eq(caller(), sload(/** @src 0:63:10302  "contract CrowdfundingASM {..." */ _1))
                /// @src 0:2493:6045  "assembly {..."
                {
                    mstore(0x80, 0x08c379a0)
                    mstore(0x84, 32)
                    mstore(0xA4, 27)
                    mstore(0xC4, "Project creators can't fund")
                    revert(0x80, 100)
                }
                let usr$amountAndState := sload(1)
                let usr$amountToRaiseVar := shr(128, usr$amountAndState)
                if and(gt(timestamp(), sload(2)), lt(selfbalance(), usr$amountToRaiseVar))
                {
                    if xor(and(usr$amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 2)
                    {
                        usr$amountAndState := add(usr$amountAndState, 2)
                    }
                }
                if and(usr$amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
                {
                    let usr$fmp := mload(0x40)
                    mstore(usr$fmp, 0x08c379a0)
                    mstore(add(usr$fmp, /** @src 0:63:10302  "contract CrowdfundingASM {..." */ 4), /** @src 0:2493:6045  "assembly {..." */ 32)
                    mstore(add(usr$fmp, 0x24), 32)
                    mstore(add(usr$fmp, 0x44), "The project is no longer raising")
                    revert(usr$fmp, 0x64)
                }
                mstore(/** @src 0:63:10302  "contract CrowdfundingASM {..." */ _1, /** @src 0:2493:6045  "assembly {..." */ caller())
                mstore(0x20, /** @src 0:63:10302  "contract CrowdfundingASM {..." */ 4)
                /// @src 0:2493:6045  "assembly {..."
                let usr$helper := keccak256(/** @src 0:63:10302  "contract CrowdfundingASM {..." */ _1, /** @src 0:2493:6045  "assembly {..." */ 0x40)
                sstore(usr$helper, add(sload(usr$helper), callvalue()))
                let usr$helper_1 := selfbalance()
                if gt(usr$helper_1, add(usr$amountToRaiseVar, not(0)))
                {
                    sstore(1, add(usr$amountAndState, 1))
                }
                /// @src 0:63:10302  "contract CrowdfundingASM {..."
                return(_1, _1)
            }
            function external_fun_payOut()
            {
                if callvalue() { revert(0, 0) }
                let _1 := 0
                if slt(add(calldatasize(), not(3)), _1) { revert(_1, _1) }
                /// @src 0:6211:7777  "assembly {..."
                let usr$owner := sload(/** @src 0:63:10302  "contract CrowdfundingASM {..." */ _1)
                /// @src 0:6211:7777  "assembly {..."
                if xor(caller(), usr$owner)
                {
                    mstore(0x80, 0x08c379a0)
                    mstore(0x84, 32)
                    mstore(0xA4, 32)
                    mstore(0xC4, "Only project creator can pay out")
                    revert(0x80, 100)
                }
                let usr$amountAndState := sload(1)
                if xor(and(usr$amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 1)
                {
                    mstore(0x80, 0x08c379a0)
                    mstore(0x84, 32)
                    mstore(0xA4, 29)
                    mstore(0xC4, "Not raised or project expired")
                    revert(0x80, 100)
                }
                if iszero(call(/** @src 0:63:10302  "contract CrowdfundingASM {..." */ _1, /** @src 0:6211:7777  "assembly {..." */ usr$owner, selfbalance(), /** @src 0:63:10302  "contract CrowdfundingASM {..." */ _1, _1, _1, _1))
                /// @src 0:6211:7777  "assembly {..."
                {
                    mstore(0x80, 0x08c379a0)
                    mstore(0x84, 32)
                    mstore(0xA4, 29)
                    mstore(0xC4, "Can't transfer funds to owner")
                    revert(0x80, 100)
                }
                sstore(1, add(usr$amountAndState, 3))
                /// @src 0:63:10302  "contract CrowdfundingASM {..."
                return(_1, _1)
            }
            function external_fun_viewProject()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), not(3)), 0) { revert(0, 0) }
                /// @src 0:818:1307  "assembly {..."
                let var_creator := sload(/** @src 0:63:10302  "contract CrowdfundingASM {..." */ 0)
                /// @src 0:818:1307  "assembly {..."
                let usr$amountAndState := sload(1)
                let var_deadline := sload(2)
                /// @src 0:63:10302  "contract CrowdfundingASM {..."
                let memPos := mload(64)
                mstore(memPos, and(var_creator, sub(shl(160, /** @src 0:7944:10292  "assembly {..." */ 1), 1)))
                /// @src 0:63:10302  "contract CrowdfundingASM {..."
                mstore(add(memPos, 32), /** @src 0:818:1307  "assembly {..." */ shr(128, usr$amountAndState))
                /// @src 0:63:10302  "contract CrowdfundingASM {..."
                mstore(add(memPos, 64), /** @src 0:818:1307  "assembly {..." */ and(usr$amountAndState, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
                /// @src 0:63:10302  "contract CrowdfundingASM {..."
                mstore(add(memPos, 96), var_deadline)
                return(memPos, /** @src 0:818:1307  "assembly {..." */ 128)
            }
            /// @src 0:63:10302  "contract CrowdfundingASM {..."
            function external_fun_fundings()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), not(3)), 32)
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 0:63:10302  "contract CrowdfundingASM {..."
                let value := calldataload(4)
                let _1 := and(value, sub(shl(160, /** @src 0:7944:10292  "assembly {..." */ 1), 1))
                /// @src 0:63:10302  "contract CrowdfundingASM {..."
                if iszero(eq(value, _1))
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 0:63:10302  "contract CrowdfundingASM {..."
                mstore(/** @src -1:-1:-1 */ 0, /** @src 0:63:10302  "contract CrowdfundingASM {..." */ _1)
                mstore(32, 4)
                let _2 := sload(keccak256(/** @src -1:-1:-1 */ 0, /** @src 0:63:10302  "contract CrowdfundingASM {..." */ 0x40))
                let memPos := mload(0x40)
                mstore(memPos, _2)
                return(memPos, 32)
            }
        }
        data ".metadata" hex"a26469706673582212207b53b48488c7b0b5c858091e9121496d523b574e36d659ecf6b35cac9cb4e4bd64736f6c63430008110033"
    }
}

