// SPDX-License-Identifier: MIT
pragma solidity ^0.6.8;

library ModExp {
    // Baseline: calling EIP-198 precompile
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-198.md
    // The precompile is located at the address 0x00......05
    // and has inputs of the following format
    // <length_of_BASE> <length_of_EXPONENT> <length_of_MODULUS> <BASE> <EXPONENT> <MODULUS>
    function baseline(uint256 x) internal view returns (uint256 xx) {
        assembly {
            let freemem := mload(0x40)
            // length_of_BASE: 32 bytes
            mstore(freemem, 0x20)
            // length_of_EXPONENT: 32 bytes
            mstore(add(freemem, 0x20), 0x20)
            // length_of_MODULUS: 32 bytes
            mstore(add(freemem, 0x40), 0x20)
            // BASE: The input x
            mstore(add(freemem, 0x60), x)
            // EXPONENT: (N + 1) / 4 = 0xc19139cb84c680a6e14116da060561765e05aa45a1c72a34f082305b61f3f52
            mstore(add(freemem, 0x80), 0xc19139cb84c680a6e14116da060561765e05aa45a1c72a34f082305b61f3f52)
            // MODULUS: N = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            mstore(add(freemem, 0xA0), 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47)
            let success := staticcall(
                sub(gas(), 2000),
                // call the address 0x00......05
                5,
                // loads the 6 * 32 bytes inputs from <freemem>
                freemem,
                0xC0,
                // stores the 32 bytes return at <freemem>
                freemem,
                0x20
            )
            xx := mload(freemem)
        }
    }

    // Naive Solidity implementation of square and multiply
    function modexp(uint256 x) internal pure returns (uint256) {
        uint256 sq = x;
        uint256 xx = 1;
        uint256 n = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47;
        // (N + 1) / 4 = 0xc19139cb84c680a6e14116da060561765e05aa45a1c72a34f082305b61f3f52
        uint256 v = 0xc19139cb84c680a6e14116da060561765e05aa45a1c72a34f082305b61f3f52;
        for (uint256 i = 0; i < 252; i++) {
            if ((v >> i) & 1 == 1) {
                xx = mulmod(xx, sq, n);
            }
            sq = mulmod(sq, sq, n);
        }
        return xx;
    }

    // Improve with inline assembly
    function modexp2(uint256 x) internal pure returns (uint256 xx) {
        assembly {
            xx := 1
            let n := 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            let v := 0xc19139cb84c680a6e14116da060561765e05aa45a1c72a34f082305b61f3f52
            for {
                let i := 0
            } lt(i, 252) {
                i := add(i, 1)
            } {
                if eq(and(shr(i, v), 1), 1) {
                    xx := mulmod(xx, x, n)
                }
                x := mulmod(x, x, n)
            }
        }
    }

    // Use loop unrolling
    function modexp3(uint256 x) internal pure returns (uint256 xx) {
        assembly {
            xx := 1
            let n := 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            let v := 0xc19139cb84c680a6e14116da060561765e05aa45a1c72a34f082305b61f3f52
            for {
                let i := 0
            } lt(i, 63) {
                i := add(i, 1)
            } {
                if eq(and(shr(mul(i, 4), v), 1), 1) {
                    xx := mulmod(xx, x, n)
                }
                x := mulmod(x, x, n)
                if eq(and(shr(add(mul(i, 4), 1), v), 1), 1) {
                    xx := mulmod(xx, x, n)
                }
                x := mulmod(x, x, n)
                if eq(and(shr(add(mul(i, 4), 2), v), 1), 1) {
                    xx := mulmod(xx, x, n)
                }
                x := mulmod(x, x, n)
                if eq(and(shr(add(mul(i, 4), 3), v), 1), 1) {
                    xx := mulmod(xx, x, n)
                }
                x := mulmod(x, x, n)
            }
        }
    }

    // Minor optimize
    function modexp4(uint256 x) internal pure returns (uint256 xx) {
        assembly {
            xx := 1

            let n := 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            let v := 0xc19139cb84c680a6e14116da060561765e05aa45a1c72a34f082305b61f3f52
            for {
                let i := 0
            } lt(i, 63) {
                i := add(i, 1)
            } {
                if eq(and(v, 1), 1) {
                    xx := mulmod(xx, x, n)
                }
                x := mulmod(x, x, n)
                v := shr(1, v)
                if eq(and(v, 1), 1) {
                    xx := mulmod(xx, x, n)
                }
                x := mulmod(x, x, n)
                v := shr(1, v)
                if eq(and(v, 1), 1) {
                    xx := mulmod(xx, x, n)
                }
                x := mulmod(x, x, n)
                v := shr(1, v)
                if eq(and(v, 1), 1) {
                    xx := mulmod(xx, x, n)
                }
                x := mulmod(x, x, n)
                v := shr(1, v)
            }
        }
    }

    // Unroll more
    function modexp5(uint256 x) internal pure returns (uint256 xx) {
        assembly {
            xx := 1
            let i := 0
            let n := 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            let v := 0xc19139cb84c680a6e14116da060561765e05aa45a1c72a34f082305b61f3f52
            for {

            } lt(i, 31) {

            } {
                if eq(and(v, 1), 1) {
                    xx := mulmod(xx, x, n)
                }
                x := mulmod(x, x, n)
                v := shr(1, v)
                if eq(and(v, 1), 1) {
                    xx := mulmod(xx, x, n)
                }
                x := mulmod(x, x, n)
                v := shr(1, v)
                if eq(and(v, 1), 1) {
                    xx := mulmod(xx, x, n)
                }
                x := mulmod(x, x, n)
                v := shr(1, v)
                if eq(and(v, 1), 1) {
                    xx := mulmod(xx, x, n)
                }
                x := mulmod(x, x, n)
                v := shr(1, v)
                if eq(and(v, 1), 1) {
                    xx := mulmod(xx, x, n)
                }
                x := mulmod(x, x, n)
                v := shr(1, v)
                if eq(and(v, 1), 1) {
                    xx := mulmod(xx, x, n)
                }
                x := mulmod(x, x, n)
                v := shr(1, v)
                if eq(and(v, 1), 1) {
                    xx := mulmod(xx, x, n)
                }
                x := mulmod(x, x, n)
                v := shr(1, v)
                if eq(and(v, 1), 1) {
                    xx := mulmod(xx, x, n)
                }
                x := mulmod(x, x, n)
                v := shr(1, v)
                i := add(i, 1)
            }
            if eq(and(v, 1), 1) {
                xx := mulmod(xx, x, n)
            }
            x := mulmod(x, x, n)
            v := shr(1, v)
            if eq(and(v, 1), 1) {
                xx := mulmod(xx, x, n)
            }
            x := mulmod(x, x, n)
            v := shr(1, v)
            if eq(and(v, 1), 1) {
                xx := mulmod(xx, x, n)
            }

            x := mulmod(x, x, n)
            v := shr(1, v)
            if eq(and(v, 1), 1) {
                xx := mulmod(xx, x, n)
            }
        }
    }

    // Remove if statement
    function modexp6(uint256 x) internal pure returns (uint256 xx) {
        assembly {
            xx := 1
            let n := 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            let v := 0xc19139cb84c680a6e14116da060561765e05aa45a1c72a34f082305b61f3f52
            for {
                let i := 0
            } lt(i, 31) {
                i := add(i, 1)
            } {
                xx := mulmod(xx, add(1, mul(sub(x, 1), and(v, 1))), n)
                x := mulmod(x, x, n)
                xx := mulmod(xx, add(1, mul(sub(x, 1), shr(1, and(v, 2)))), n)
                x := mulmod(x, x, n)
                xx := mulmod(xx, add(1, mul(sub(x, 1), shr(2, and(v, 4)))), n)
                x := mulmod(x, x, n)
                xx := mulmod(xx, add(1, mul(sub(x, 1), shr(3, and(v, 8)))), n)
                x := mulmod(x, x, n)
                xx := mulmod(xx, add(1, mul(sub(x, 1), shr(4, and(v, 16)))), n)
                x := mulmod(x, x, n)
                xx := mulmod(xx, add(1, mul(sub(x, 1), shr(5, and(v, 32)))), n)
                x := mulmod(x, x, n)
                xx := mulmod(xx, add(1, mul(sub(x, 1), shr(6, and(v, 64)))), n)
                x := mulmod(x, x, n)
                xx := mulmod(xx, add(1, mul(sub(x, 1), shr(7, and(v, 128)))), n)
                x := mulmod(x, x, n)
                v := shr(8, v)
            }
            xx := mulmod(xx, add(1, mul(sub(x, 1), and(v, 1))), n)
            x := mulmod(x, x, n)
            xx := mulmod(xx, add(1, mul(sub(x, 1), shr(1, and(v, 2)))), n)
            x := mulmod(x, x, n)
            xx := mulmod(xx, add(1, mul(sub(x, 1), shr(2, and(v, 4)))), n)
            x := mulmod(x, x, n)
            xx := mulmod(xx, x, n)
        }
    }

    // Reproduce historical result
    // https://github.com/ethereum/serpent/blob/develop/examples/ecc/modexp.se
    function modexp7(uint256 x) internal pure returns (uint256 xx) {
        assembly {
            xx := 1
            let n := 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            let v := 0xc19139cb84c680a6e14116da060561765e05aa45a1c72a34f082305b61f3f52
            let mask := shl(255, 1)
            for {
                let i := 0
            } lt(i, 64) {
                i := add(i, 1)
            } {
                xx := mulmod(mulmod(xx, xx, n), exp(x, iszero(iszero(and(v, mask)))), n)
                xx := mulmod(mulmod(xx, xx, n), exp(x, iszero(iszero(and(v, shr(1, mask))))), n)
                xx := mulmod(mulmod(xx, xx, n), exp(x, iszero(iszero(and(v, shr(2, mask))))), n)
                xx := mulmod(mulmod(xx, xx, n), exp(x, iszero(iszero(and(v, shr(3, mask))))), n)
                mask := shr(4, mask)
            }
        }
    }
}
