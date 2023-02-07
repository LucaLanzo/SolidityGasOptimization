Optimized IR:
/// @use-src 0:"contracts/arithmetics/Arithmetics.sol"
object "Arithmetics_167" {
    code {
        {
            /// @src 0:97:1541  "contract Arithmetics {..."
            let _1 := memoryguard(0x80)
            mstore(64, _1)
            if callvalue() { revert(0, 0) }
            let _2 := datasize("Arithmetics_167_deployed")
            codecopy(_1, dataoffset("Arithmetics_167_deployed"), _2)
            return(_1, _2)
        }
    }
    /// @use-src 0:"contracts/arithmetics/Arithmetics.sol"
    object "Arithmetics_167_deployed" {
        code {
            {
                /// @src 0:97:1541  "contract Arithmetics {..."
                let _1 := memoryguard(0x80)
                let _2 := 64
                mstore(_2, _1)
                if iszero(lt(calldatasize(), 4))
                {
                    let _3 := 0
                    switch shr(224, calldataload(_3))
                    case 0x1a42ef35 {
                        if callvalue() { revert(_3, _3) }
                        if slt(add(calldatasize(), not(3)), _2) { revert(_3, _3) }
                        let value0 := abi_decode_uint8()
                        let sum := add(and(value0, 0xff), and(abi_decode_uint8_1503(), 0xff))
                        if gt(sum, 0xff)
                        {
                            mstore(_3, shl(224, 0x4e487b71))
                            mstore(4, 0x11)
                            revert(_3, 36)
                        }
                        mstore(_1, and(sum, 0xff))
                        return(_1, 32)
                    }
                    case 0x361d555c {
                        if callvalue() { revert(_3, _3) }
                        if slt(add(calldatasize(), not(3)), _2) { revert(_3, _3) }
                        let value0_1 := abi_decode_uint8()
                        let sum_1 := and(add(value0_1, abi_decode_uint8_1503()), 0xff)
                        let memPos := mload(_2)
                        mstore(memPos, sum_1)
                        return(memPos, 32)
                    }
                    case 0x3e504755 {
                        if callvalue() { revert(_3, _3) }
                        if slt(add(calldatasize(), not(3)), _2) { revert(_3, _3) }
                        let value0_2 := abi_decode_uint8()
                        let diff := and(sub(value0_2, abi_decode_uint8_1503()), 0xff)
                        let memPos_1 := mload(_2)
                        mstore(memPos_1, diff)
                        return(memPos_1, 32)
                    }
                    case 0x575eb27d {
                        if callvalue() { revert(_3, _3) }
                        if slt(add(calldatasize(), not(3)), _2) { revert(_3, _3) }
                        let value0_3 := abi_decode_uint8()
                        let value1 := abi_decode_uint8_1503()
                        let memPos_2 := mload(_2)
                        mstore(memPos_2, and(exp(and(value0_3, 0xff), and(value1, 0xff)), 0xff))
                        return(memPos_2, 32)
                    }
                    case 0x761dac6b { external_fun_divSol() }
                    case 0x8116ec3b {
                        if callvalue() { revert(_3, _3) }
                        if slt(add(calldatasize(), not(3)), _2) { revert(_3, _3) }
                        let value0_4 := abi_decode_uint8()
                        let diff_1 := sub(and(value0_4, 0xff), and(abi_decode_uint8_1503(), 0xff))
                        if gt(diff_1, 0xff)
                        {
                            mstore(_3, shl(224, 0x4e487b71))
                            mstore(4, 0x11)
                            revert(_3, 36)
                        }
                        let memPos_3 := mload(_2)
                        mstore(memPos_3, and(diff_1, 0xff))
                        return(memPos_3, 32)
                    }
                    case 0x9549a0a9 {
                        if callvalue() { revert(_3, _3) }
                        if slt(add(calldatasize(), not(3)), _2) { revert(_3, _3) }
                        let value0_5 := abi_decode_uint8()
                        let power := checked_exp_unsigned(and(value0_5, 0xff), and(abi_decode_uint8_1503(), 0xff))
                        let memPos_4 := mload(_2)
                        mstore(memPos_4, and(power, 0xff))
                        return(memPos_4, 32)
                    }
                    case 0xa6538d18 { external_fun_divSol() }
                    case 0xbf1a9aa0 {
                        if callvalue() { revert(_3, _3) }
                        if slt(add(calldatasize(), not(3)), _2) { revert(_3, _3) }
                        let value0_6 := abi_decode_uint8()
                        let product := and(mul(value0_6, abi_decode_uint8_1503()), 0xff)
                        let memPos_5 := mload(_2)
                        mstore(memPos_5, product)
                        return(memPos_5, 32)
                    }
                    case 0xef946e6d {
                        if callvalue() { revert(_3, _3) }
                        if slt(add(calldatasize(), not(3)), _2) { revert(_3, _3) }
                        let value0_7 := abi_decode_uint8()
                        let product_raw := mul(and(value0_7, 0xff), and(abi_decode_uint8_1503(), 0xff))
                        let product_1 := and(product_raw, 0xff)
                        if iszero(eq(product_1, product_raw))
                        {
                            mstore(_3, shl(224, 0x4e487b71))
                            mstore(4, 0x11)
                            revert(_3, 36)
                        }
                        let memPos_6 := mload(_2)
                        mstore(memPos_6, product_1)
                        return(memPos_6, 32)
                    }
                }
                revert(0, 0)
            }
            function abi_decode_uint8() -> value
            {
                value := calldataload(4)
                if iszero(eq(value, and(value, 0xff))) { revert(0, 0) }
            }
            function abi_decode_uint8_1503() -> value
            {
                value := calldataload(36)
                if iszero(eq(value, and(value, 0xff))) { revert(0, 0) }
            }
            function external_fun_divSol()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), not(3)), 64)
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 0:97:1541  "contract Arithmetics {..."
                let value0 := abi_decode_uint8()
                let y := and(abi_decode_uint8_1503(), 0xff)
                if iszero(y)
                {
                    mstore(/** @src -1:-1:-1 */ 0, /** @src 0:97:1541  "contract Arithmetics {..." */ shl(224, 0x4e487b71))
                    mstore(4, 0x12)
                    revert(/** @src -1:-1:-1 */ 0, /** @src 0:97:1541  "contract Arithmetics {..." */ 0x24)
                }
                let memPos := mload(64)
                mstore(memPos, and(div(and(value0, 0xff), y), 0xff))
                return(memPos, 32)
            }
            function checked_exp_unsigned(base, exponent) -> power
            {
                if iszero(exponent)
                {
                    power := 1
                    leave
                }
                if iszero(base)
                {
                    power := 0
                    leave
                }
                switch base
                case 1 {
                    power := 1
                    leave
                }
                case 2 {
                    if gt(exponent, 0xff)
                    {
                        mstore(0, shl(224, 0x4e487b71))
                        mstore(4, 0x11)
                        revert(0, 0x24)
                    }
                    power := shl(exponent, 1)
                    if gt(power, 0xff)
                    {
                        mstore(0, shl(224, 0x4e487b71))
                        mstore(4, 0x11)
                        revert(0, 0x24)
                    }
                    leave
                }
                if or(and(lt(base, 11), lt(exponent, 78)), and(lt(base, 307), lt(exponent, 32)))
                {
                    power := exp(base, exponent)
                    if gt(power, 0xff)
                    {
                        mstore(0, shl(224, 0x4e487b71))
                        mstore(4, 0x11)
                        revert(0, 0x24)
                    }
                    leave
                }
                let exponent_1 := exponent
                let power_1 := /** @src -1:-1:-1 */ 0
                /// @src 0:97:1541  "contract Arithmetics {..."
                let base_1 := /** @src -1:-1:-1 */ power_1
                /// @src 0:97:1541  "contract Arithmetics {..."
                let power_2 := 1
                power_1 := power_2
                base_1 := base
                for { } gt(exponent_1, power_2) { }
                {
                    if gt(base_1, div(0xff, base_1))
                    {
                        mstore(/** @src -1:-1:-1 */ 0, /** @src 0:97:1541  "contract Arithmetics {..." */ shl(224, 0x4e487b71))
                        mstore(4, 0x11)
                        revert(/** @src -1:-1:-1 */ 0, /** @src 0:97:1541  "contract Arithmetics {..." */ 0x24)
                    }
                    if and(exponent_1, power_2)
                    {
                        power_1 := mul(power_1, base_1)
                    }
                    base_1 := mul(base_1, base_1)
                    exponent_1 := shr(power_2, exponent_1)
                }
                if gt(power_1, div(0xff, base_1))
                {
                    mstore(/** @src -1:-1:-1 */ 0, /** @src 0:97:1541  "contract Arithmetics {..." */ shl(224, 0x4e487b71))
                    mstore(4, 0x11)
                    revert(/** @src -1:-1:-1 */ 0, /** @src 0:97:1541  "contract Arithmetics {..." */ 0x24)
                }
                power := mul(power_1, base_1)
            }
        }
        data ".metadata" hex"a2646970667358221220debc02863e963367e49de1e0a1bb6ecad9811fa6c18c09ed7b68a2810352d58864736f6c63430008110033"
    }
}

