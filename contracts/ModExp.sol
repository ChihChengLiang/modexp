// SPDX-License-Identifier: MIT
pragma solidity ^0.6.8;

library ModExp {
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
