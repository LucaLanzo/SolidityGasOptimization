Optimized IR:
/// @use-src 0:"contracts/crowdfunding/Crowdfunding.sol"
object "Crowdfunding_295" {
    code {
        {
            /// @src 0:63:3721  "contract Crowdfunding {..."
            let _1 := memoryguard(0x80)
            if callvalue() { revert(0, 0) }
            let programSize := datasize("Crowdfunding_295")
            let argSize := sub(codesize(), programSize)
            let newFreePtr := add(_1, and(add(argSize, 31), not(31)))
            if or(gt(newFreePtr, sub(shl(64, 1), 1)), lt(newFreePtr, _1))
            {
                mstore(/** @src -1:-1:-1 */ 0, /** @src 0:63:3721  "contract Crowdfunding {..." */ shl(224, 0x4e487b71))
                mstore(4, 0x41)
                revert(/** @src -1:-1:-1 */ 0, /** @src 0:63:3721  "contract Crowdfunding {..." */ 0x24)
            }
            mstore(64, newFreePtr)
            codecopy(_1, programSize, argSize)
            if slt(sub(add(_1, argSize), _1), 64)
            {
                revert(/** @src -1:-1:-1 */ 0, 0)
            }
            /// @src 0:63:3721  "contract Crowdfunding {..."
            let value := mload(_1)
            let _2 := and(value, sub(shl(128, 1), 1))
            if iszero(eq(value, _2))
            {
                revert(/** @src -1:-1:-1 */ 0, 0)
            }
            /// @src 0:63:3721  "contract Crowdfunding {..."
            let value_1 := mload(add(_1, 32))
            if /** @src 0:882:900  "_amountToRaise > 0" */ iszero(/** @src 0:63:3721  "contract Crowdfunding {..." */ _2)
            {
                let memPtr := mload(64)
                mstore(memPtr, shl(229, 4594637))
                mstore(add(memPtr, 4), 32)
                mstore(add(memPtr, 36), 30)
                mstore(add(memPtr, 68), "Amount to raise smaller than 0")
                revert(memPtr, 100)
            }
            /// @src -1:-1:-1
            let _3 := 0
            /// @src 0:63:3721  "contract Crowdfunding {..."
            sstore(/** @src -1:-1:-1 */ _3, /** @src 0:63:3721  "contract Crowdfunding {..." */ or(and(sload(/** @src -1:-1:-1 */ _3), /** @src 0:63:3721  "contract Crowdfunding {..." */ not(sub(shl(160, 1), 1))), /** @src 0:966:976  "msg.sender" */ caller()))
            /// @src 0:63:3721  "contract Crowdfunding {..."
            let _4 := sload(/** @src 0:988:1018  "amountToRaise = _amountToRaise" */ 0x03)
            /// @src 0:63:3721  "contract Crowdfunding {..."
            sstore(/** @src 0:988:1018  "amountToRaise = _amountToRaise" */ 0x03, /** @src 0:63:3721  "contract Crowdfunding {..." */ or(and(_4, not(sub(shl(136, 1), 1))), and(shl(8, value), sub(shl(136, 1), 256))))
            /// @src 0:1127:1133  "1 days"
            let _5 := 0x015180
            /// @src 0:63:3721  "contract Crowdfunding {..."
            let product := mul(value_1, /** @src 0:1127:1133  "1 days" */ _5)
            /// @src 0:63:3721  "contract Crowdfunding {..."
            if iszero(or(iszero(value_1), eq(/** @src 0:1127:1133  "1 days" */ _5, /** @src 0:63:3721  "contract Crowdfunding {..." */ div(product, value_1))))
            {
                mstore(/** @src -1:-1:-1 */ _3, /** @src 0:63:3721  "contract Crowdfunding {..." */ shl(224, 0x4e487b71))
                mstore(4, 0x11)
                revert(/** @src -1:-1:-1 */ _3, /** @src 0:63:3721  "contract Crowdfunding {..." */ 0x24)
            }
            let sum := add(/** @src 0:1079:1094  "block.timestamp" */ timestamp(), /** @src 0:63:3721  "contract Crowdfunding {..." */ product)
            if gt(/** @src 0:1079:1094  "block.timestamp" */ timestamp(), /** @src 0:63:3721  "contract Crowdfunding {..." */ sum)
            {
                mstore(/** @src -1:-1:-1 */ _3, /** @src 0:63:3721  "contract Crowdfunding {..." */ shl(224, 0x4e487b71))
                mstore(4, 0x11)
                revert(/** @src -1:-1:-1 */ _3, /** @src 0:63:3721  "contract Crowdfunding {..." */ 0x24)
            }
            sstore(1, sum)
            sstore(/** @src 0:1145:1172  "startedAt = block.timestamp" */ 0x02, /** @src 0:1079:1094  "block.timestamp" */ timestamp())
            /// @src 0:63:3721  "contract Crowdfunding {..."
            let _6 := mload(64)
            let _7 := datasize("Crowdfunding_295_deployed")
            codecopy(_6, dataoffset("Crowdfunding_295_deployed"), _7)
            return(_6, _7)
        }
    }
    /// @use-src 0:"contracts/crowdfunding/Crowdfunding.sol"
    object "Crowdfunding_295_deployed" {
        code {
            {
                /// @src 0:63:3721  "contract Crowdfunding {..."
                let _1 := memoryguard(0x80)
                let _2 := 64
                mstore(_2, _1)
                let _3 := 4
                if iszero(lt(calldatasize(), _3))
                {
                    let _4 := 0
                    switch shr(224, calldataload(_4))
                    case 0x2eb1f29f {
                        if callvalue() { revert(_4, _4) }
                        if slt(add(calldatasize(), not(3)), _4) { revert(_4, _4) }
                        fun_checkForExpiration()
                        return(_4, _4)
                    }
                    case 0x590e1ae3 {
                        if callvalue() { revert(_4, _4) }
                        if slt(add(calldatasize(), not(3)), _4) { revert(_4, _4) }
                        mstore(_4, /** @src 0:2748:2758  "msg.sender" */ caller())
                        /// @src 0:63:3721  "contract Crowdfunding {..."
                        let _5 := 0x20
                        mstore(_5, _3)
                        if /** @src 0:2739:2763  "fundings[msg.sender] > 0" */ iszero(/** @src 0:63:3721  "contract Crowdfunding {..." */ sload(keccak256(_4, _2)))
                        {
                            mstore(_1, shl(229, 4594637))
                            mstore(add(_1, _3), _5)
                            mstore(add(_1, 36), _5)
                            mstore(add(_1, 68), "Can't pay out you haven't funded")
                            revert(_1, 100)
                        }
                        /// @src 0:2731:2800  "require(fundings[msg.sender] > 0, \"Can't pay out you haven't funded\")"
                        fun_checkForExpiration()
                        /// @src 0:63:3721  "contract Crowdfunding {..."
                        let value := and(sload(/** @src 0:2897:2902  "state" */ 0x03), /** @src 0:63:3721  "contract Crowdfunding {..." */ 0xff)
                        if iszero(lt(value, 5))
                        {
                            mstore(_4, shl(224, 0x4e487b71))
                            mstore(_3, 0x21)
                            revert(_4, 0x24)
                        }
                        if iszero(/** @src 0:2897:2926  "state == ProjectState.EXPIRED" */ eq(value, /** @src 0:2906:2926  "ProjectState.EXPIRED" */ 2))
                        /// @src 0:63:3721  "contract Crowdfunding {..."
                        {
                            let memPtr := mload(_2)
                            mstore(memPtr, shl(229, 4594637))
                            mstore(add(memPtr, _3), _5)
                            mstore(add(memPtr, 36), 26)
                            mstore(add(memPtr, 68), "The project hasn't expired")
                            revert(memPtr, 100)
                        }
                        mstore(_4, /** @src 0:2748:2758  "msg.sender" */ caller())
                        /// @src 0:63:3721  "contract Crowdfunding {..."
                        mstore(_5, _3)
                        let _6 := sload(keccak256(_4, _2))
                        sstore(keccak256(_4, _2), _4)
                        /// @src 0:3077:3139  "payable(msg.sender).call{ gas: 0, value: _amountToRefund }(\"\")"
                        let expr_component := call(/** @src 0:63:3721  "contract Crowdfunding {..." */ _4, /** @src 0:2748:2758  "msg.sender" */ caller(), /** @src 0:3077:3139  "payable(msg.sender).call{ gas: 0, value: _amountToRefund }(\"\")" */ _6, /** @src 0:63:3721  "contract Crowdfunding {..." */ _4, _4, _4, _4)
                        /// @src 0:3077:3139  "payable(msg.sender).call{ gas: 0, value: _amountToRefund }(\"\")"
                        pop(extract_returndata())
                        /// @src 0:3152:3251  "if (!sent) {..."
                        if /** @src 0:3156:3161  "!sent" */ iszero(expr_component)
                        /// @src 0:3152:3251  "if (!sent) {..."
                        {
                            /// @src 0:63:3721  "contract Crowdfunding {..."
                            mstore(_4, /** @src 0:2748:2758  "msg.sender" */ caller())
                            /// @src 0:63:3721  "contract Crowdfunding {..."
                            mstore(_5, _3)
                            sstore(keccak256(_4, _2), _6)
                        }
                        /// @src 0:3263:3351  "if (address(this).balance == 0) {..."
                        if /** @src 0:3267:3293  "address(this).balance == 0" */ iszero(/** @src 0:3267:3288  "address(this).balance" */ selfbalance())
                        /// @src 0:3263:3351  "if (address(this).balance == 0) {..."
                        {
                            /// @src 0:63:3721  "contract Crowdfunding {..."
                            sstore(/** @src 0:2897:2902  "state" */ 0x03, /** @src 0:63:3721  "contract Crowdfunding {..." */ or(and(sload(/** @src 0:2897:2902  "state" */ 0x03), /** @src 0:63:3721  "contract Crowdfunding {..." */ not(255)), /** @src 0:2897:2902  "state" */ 0x03))
                        }
                        /// @src 0:63:3721  "contract Crowdfunding {..."
                        return(_4, _4)
                    }
                    case 0xb60d4288 {
                        if slt(add(calldatasize(), not(3)), _4) { revert(_4, _4) }
                        if /** @src 0:1430:1443  "msg.value > 0" */ iszero(/** @src 0:1430:1439  "msg.value" */ callvalue())
                        /// @src 0:63:3721  "contract Crowdfunding {..."
                        {
                            let memPtr_1 := mload(_2)
                            mstore(memPtr_1, shl(229, 4594637))
                            mstore(add(memPtr_1, _3), 32)
                            mstore(add(memPtr_1, 36), 24)
                            mstore(add(memPtr_1, 68), "Specify a funding amount")
                            revert(memPtr_1, 100)
                        }
                        if /** @src 0:1491:1512  "msg.sender != creator" */ eq(/** @src 0:1491:1501  "msg.sender" */ caller(), /** @src 0:63:3721  "contract Crowdfunding {..." */ and(sload(_4), sub(shl(160, 1), 1)))
                        {
                            let memPtr_2 := mload(_2)
                            mstore(memPtr_2, shl(229, 4594637))
                            mstore(add(memPtr_2, _3), 32)
                            mstore(add(memPtr_2, 36), 27)
                            mstore(add(memPtr_2, 68), "Project creators can't fund")
                            revert(memPtr_2, 100)
                        }
                        /// @src 0:1483:1544  "require(msg.sender != creator, \"Project creators can't fund\")"
                        fun_checkForExpiration()
                        /// @src 0:63:3721  "contract Crowdfunding {..."
                        let value_1 := and(sload(/** @src 0:1607:1612  "state" */ 0x03), /** @src 0:63:3721  "contract Crowdfunding {..." */ 0xff)
                        if iszero(lt(value_1, 5))
                        {
                            mstore(_4, shl(224, 0x4e487b71))
                            mstore(_3, 0x21)
                            revert(_4, 0x24)
                        }
                        if iszero(/** @src 0:1607:1636  "state == ProjectState.RAISING" */ iszero(value_1))
                        /// @src 0:63:3721  "contract Crowdfunding {..."
                        {
                            let memPtr_3 := mload(_2)
                            mstore(memPtr_3, shl(229, 4594637))
                            mstore(add(memPtr_3, _3), 32)
                            mstore(add(memPtr_3, 36), 32)
                            mstore(add(memPtr_3, 68), "The project is no longer raising")
                            revert(memPtr_3, 100)
                        }
                        mstore(_4, /** @src 0:1491:1501  "msg.sender" */ caller())
                        /// @src 0:63:3721  "contract Crowdfunding {..."
                        mstore(0x20, _3)
                        let dataSlot := keccak256(_4, _2)
                        let _7 := sload(/** @src 0:1703:1736  "fundings[msg.sender] += msg.value" */ dataSlot)
                        /// @src 0:63:3721  "contract Crowdfunding {..."
                        let sum := add(_7, /** @src 0:1430:1439  "msg.value" */ callvalue())
                        /// @src 0:63:3721  "contract Crowdfunding {..."
                        if gt(_7, sum)
                        {
                            mstore(_4, shl(224, 0x4e487b71))
                            mstore(_3, 0x11)
                            revert(_4, 0x24)
                        }
                        sstore(dataSlot, sum)
                        /// @src 0:1752:1773  "address(this).balance"
                        let expr := selfbalance()
                        /// @src 0:63:3721  "contract Crowdfunding {..."
                        let _8 := sload(/** @src 0:1607:1612  "state" */ 0x03)
                        /// @src 0:1749:1846  "if(address(this).balance >= amountToRaise) {..."
                        if /** @src 0:1752:1790  "address(this).balance >= amountToRaise" */ iszero(lt(expr, /** @src 0:63:3721  "contract Crowdfunding {..." */ and(shr(8, _8), 0xffffffffffffffffffffffffffffffff)))
                        /// @src 0:1749:1846  "if(address(this).balance >= amountToRaise) {..."
                        {
                            /// @src 0:63:3721  "contract Crowdfunding {..."
                            sstore(/** @src 0:1607:1612  "state" */ 0x03, /** @src 0:63:3721  "contract Crowdfunding {..." */ or(and(_8, not(255)), /** @src 0:1815:1834  "ProjectState.RAISED" */ 1))
                        }
                        /// @src 0:63:3721  "contract Crowdfunding {..."
                        return(_4, _4)
                    }
                    case 0xc2052403 {
                        if callvalue() { revert(_4, _4) }
                        if slt(add(calldatasize(), not(3)), _4) { revert(_4, _4) }
                        let value_2 := and(sload(_4), sub(shl(160, 1), 1))
                        if iszero(/** @src 0:2020:2041  "msg.sender == creator" */ eq(/** @src 0:2020:2030  "msg.sender" */ caller(), /** @src 0:2020:2041  "msg.sender == creator" */ value_2))
                        /// @src 0:63:3721  "contract Crowdfunding {..."
                        {
                            let memPtr_4 := mload(_2)
                            mstore(memPtr_4, shl(229, 4594637))
                            mstore(add(memPtr_4, _3), 32)
                            mstore(add(memPtr_4, 36), 32)
                            mstore(add(memPtr_4, 68), "Only project creator can pay out")
                            revert(memPtr_4, 100)
                        }
                        let value_3 := and(sload(/** @src 0:2097:2102  "state" */ 0x03), /** @src 0:63:3721  "contract Crowdfunding {..." */ 0xff)
                        if iszero(lt(value_3, 5))
                        {
                            mstore(_4, shl(224, 0x4e487b71))
                            mstore(_3, 0x21)
                            revert(_4, 0x24)
                        }
                        if iszero(/** @src 0:2097:2125  "state == ProjectState.RAISED" */ eq(value_3, /** @src 0:2106:2125  "ProjectState.RAISED" */ 1))
                        /// @src 0:63:3721  "contract Crowdfunding {..."
                        {
                            let memPtr_5 := mload(_2)
                            mstore(memPtr_5, shl(229, 4594637))
                            mstore(add(memPtr_5, _3), 32)
                            mstore(add(memPtr_5, 36), 29)
                            mstore(add(memPtr_5, 68), "Not raised or project expired")
                            revert(memPtr_5, 100)
                        }
                        /// @src 0:2359:2415  "creator.call{ gas: 0, value: address(this).balance }(\"\")"
                        let expr_component_1 := call(/** @src 0:63:3721  "contract Crowdfunding {..." */ _4, /** @src 0:2359:2415  "creator.call{ gas: 0, value: address(this).balance }(\"\")" */ value_2, /** @src 0:2388:2409  "address(this).balance" */ selfbalance(), /** @src 0:63:3721  "contract Crowdfunding {..." */ _4, _4, _4, _4)
                        /// @src 0:2359:2415  "creator.call{ gas: 0, value: address(this).balance }(\"\")"
                        pop(extract_returndata())
                        /// @src 0:2428:2490  "if (sent) {..."
                        if expr_component_1
                        {
                            /// @src 0:63:3721  "contract Crowdfunding {..."
                            sstore(/** @src 0:2097:2102  "state" */ 0x03, /** @src 0:63:3721  "contract Crowdfunding {..." */ or(and(sload(/** @src 0:2097:2102  "state" */ 0x03), /** @src 0:63:3721  "contract Crowdfunding {..." */ not(255)), _3))
                        }
                        return(_4, _4)
                    }
                    case 0xca3c23c1 {
                        if callvalue() { revert(_4, _4) }
                        if slt(add(calldatasize(), not(3)), _4) { revert(_4, _4) }
                        let value_4 := and(sload(_4), sub(shl(160, 1), 1))
                        let _9 := sload(/** @src 0:704:717  "amountToRaise" */ 0x03)
                        /// @src 0:63:3721  "contract Crowdfunding {..."
                        let value_5 := and(_9, 0xff)
                        let _10 := sload(/** @src 0:765:773  "deadline" */ 0x01)
                        /// @src 0:63:3721  "contract Crowdfunding {..."
                        let memPos := mload(_2)
                        mstore(memPos, value_4)
                        mstore(add(memPos, 32), and(shr(8, _9), 0xffffffffffffffffffffffffffffffff))
                        if iszero(lt(value_5, 5))
                        {
                            mstore(_4, shl(224, 0x4e487b71))
                            mstore(_3, 0x21)
                            revert(_4, 0x24)
                        }
                        mstore(add(memPos, _2), value_5)
                        mstore(add(memPos, 96), _10)
                        return(memPos, 128)
                    }
                    case 0xf00b03d2 {
                        if callvalue() { revert(_4, _4) }
                        if slt(add(calldatasize(), not(3)), 32) { revert(_4, _4) }
                        let value_6 := calldataload(_3)
                        let _11 := and(value_6, sub(shl(160, 1), 1))
                        if iszero(eq(value_6, _11)) { revert(_4, _4) }
                        mstore(_4, _11)
                        mstore(32, _3)
                        let _12 := sload(keccak256(_4, _2))
                        let memPos_1 := mload(_2)
                        mstore(memPos_1, _12)
                        return(memPos_1, 32)
                    }
                }
                revert(0, 0)
            }
            function extract_returndata() -> data
            {
                switch returndatasize()
                case 0 { data := 96 }
                default {
                    let _1 := returndatasize()
                    let _2 := 0xffffffffffffffff
                    if gt(_1, _2)
                    {
                        mstore(/** @src -1:-1:-1 */ 0, /** @src 0:63:3721  "contract Crowdfunding {..." */ shl(224, 0x4e487b71))
                        mstore(4, 0x41)
                        revert(/** @src -1:-1:-1 */ 0, /** @src 0:63:3721  "contract Crowdfunding {..." */ 0x24)
                    }
                    let _3 := not(31)
                    let memPtr := mload(64)
                    let newFreePtr := add(memPtr, and(add(and(add(_1, 31), _3), 63), _3))
                    if or(gt(newFreePtr, _2), lt(newFreePtr, memPtr))
                    {
                        mstore(/** @src -1:-1:-1 */ 0, /** @src 0:63:3721  "contract Crowdfunding {..." */ shl(224, 0x4e487b71))
                        mstore(4, 0x41)
                        revert(/** @src -1:-1:-1 */ 0, /** @src 0:63:3721  "contract Crowdfunding {..." */ 0x24)
                    }
                    mstore(64, newFreePtr)
                    mstore(memPtr, _1)
                    data := memPtr
                    returndatacopy(add(memPtr, 0x20), /** @src -1:-1:-1 */ 0, /** @src 0:63:3721  "contract Crowdfunding {..." */ returndatasize())
                }
            }
            /// @ast-id 294 @src 0:3535:3718  "function checkForExpiration() public {..."
            function fun_checkForExpiration()
            {
                /// @src 0:3587:3654  "block.timestamp > deadline && address(this).balance < amountToRaise"
                let expr := /** @src 0:3587:3613  "block.timestamp > deadline" */ gt(/** @src 0:3587:3602  "block.timestamp" */ timestamp(), /** @src 0:63:3721  "contract Crowdfunding {..." */ sload(/** @src 0:3605:3613  "deadline" */ 0x01))
                /// @src 0:3587:3654  "block.timestamp > deadline && address(this).balance < amountToRaise"
                if expr
                {
                    /// @src 0:3617:3638  "address(this).balance"
                    let expr_1 := selfbalance()
                    /// @src 0:3587:3654  "block.timestamp > deadline && address(this).balance < amountToRaise"
                    expr := /** @src 0:3617:3654  "address(this).balance < amountToRaise" */ lt(expr_1, /** @src 0:63:3721  "contract Crowdfunding {..." */ and(shr(8, sload(/** @src 0:3641:3654  "amountToRaise" */ 0x03)), /** @src 0:63:3721  "contract Crowdfunding {..." */ 0xffffffffffffffffffffffffffffffff))
                }
                /// @src 0:3583:3711  "if (block.timestamp > deadline && address(this).balance < amountToRaise) {..."
                if expr
                {
                    /// @src 0:63:3721  "contract Crowdfunding {..."
                    sstore(/** @src 0:3671:3699  "state = ProjectState.EXPIRED" */ 0x03, /** @src 0:63:3721  "contract Crowdfunding {..." */ or(and(sload(/** @src 0:3671:3699  "state = ProjectState.EXPIRED" */ 0x03), /** @src 0:63:3721  "contract Crowdfunding {..." */ not(255)), /** @src 0:3679:3699  "ProjectState.EXPIRED" */ 2))
                }
            }
        }
        data ".metadata" hex"a26469706673582212208c87f8cce95872ae247096d1f4712c5977987c83d1c42e2b8f7f7bec5681a50964736f6c63430008110033"
    }
}

