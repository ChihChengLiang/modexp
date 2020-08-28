// SPDX-License-Identifier: MIT
pragma solidity ^0.6.8;

contract Monster {
    function test_modexp(uint256 x) public view returns (uint256 xx, uint256 gasCost) {
        gasCost = gasleft();
        xx = modexp(x);
        gasCost = gasCost - gasleft();
    }

    // go get -u github.com/mmcloughlin/addchain/cmd/addchain
    // addchain search '5472060717959818805561601436314318772174077789324455915672259473661306552146'
    function modexp(uint256 x) internal pure returns (uint256 xx) {
        assembly {
            xx := 1
            let n := 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

            let _10 := mulmod(x, x, n)
            let _11 := mulmod(x, _10, n)
            let _101 := mulmod(_10, _11, n)
            let _110 := mulmod(x, _101, n)
            let _111 := mulmod(x, _110, n)
            let _1011 := mulmod(_101, _110, n)
            let _1100 := mulmod(x, _1011, n)
            let _1101 := mulmod(x, _1100, n)
            let _1111 := mulmod(_10, _1101, n)
            let _10001 := mulmod(_10, _1111, n)
            let _10111 := mulmod(_110, _10001, n)
            let _11001 := mulmod(_10, _10111, n)
            let _11011 := mulmod(_10, _11001, n)
            let _100111 := mulmod(_1100, _11011, n)
            let _101001 := mulmod(_10, _100111, n)
            let _101011 := mulmod(_10, _101001, n)
            let _101101 := mulmod(_10, _101011, n)
            let _111001 := mulmod(_1100, _101101, n)

            // _1100000
            let s := mulmod(_100111, _111001, n)

            // i46      = ((_1100000 << 5 + _11001) << 9 + _100111) << 8
            // s = _1100000 << 5
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // s = (_1100000 << 5 + _11001) << 9
            s := mulmod(s, _11001, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // s = (_1100000 << 5 + _11001) << 9 + _100111) << 8
            s := mulmod(s, _100111, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // i46
            s := mulmod(s, s, n)

            // i62      = ((_111001 + i46) << 4 + _111) << 9 + _10011
            // s = (_111001 + i46) << 4
            s := mulmod(_111001, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // s = (_111001 + i46) << 4 + _111) << 9
            s := mulmod(s, _111, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // i62
            s := mulmod(s, mulmod(_10, _10001, n), n)

            // i89      = ((i62 << 7 + _1101) << 13 + _101001) << 5
            // s = i62 << 7
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // s = (i62 << 7 + _1101) << 13
            s := mulmod(s, _1101, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // s = (i62 << 7 + _1101) << 13 + _101001) << 5
            s := mulmod(s, _101001, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            // i89
            s := mulmod(s, s, n)

            // i109     = ((_10111 + i89) << 7 + _101) << 10 + _10001
            // s = (_10111 + i89) << 7
            s := mulmod(_10111, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // s = (_10111 + i89) << 7 + _101) << 10
            s := mulmod(s, _101, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)

            // i109
            s := mulmod(s, _10001, n)

            // i130     = ((i109 << 6 + _11011) << 5 + _1101) << 8
            // s = i109 << 6
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)

            // s = (i109 << 6 + _11011) << 5
            s := mulmod(s, _11011, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // s =  ((i109 << 6 + _11011) << 5 + _1101) << 8
            s := mulmod(s, _1101, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            // i130
            s := mulmod(s, s, n)

            // i154     = ((_11 + i130) << 12 + _101011) << 9 + _10111
            // s = (_11 + i130) << 12
            s := mulmod(_11, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // s = (_11 + i130) << 12 + _101011) << 9
            s := mulmod(s, _101011, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // i154
            s := mulmod(s, _10111, n)

            // i179     = ((i154 << 6 + _11001) << 5 + _1111) << 12
            // s = i154 << 6
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            // s = (i154 << 6 + _11001) << 5
            s := mulmod(s, _11001, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // s = ((i154 << 6 + _11001) << 5 + _1111) << 12
            s := mulmod(s, _1111, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            // i179
            s := mulmod(s, s, n)

            // i198     = ((_101101 + i179) << 7 + _101001) << 9 + _101101
            // s = (_101101 + i179) << 7
            s := mulmod(_101101, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // s= (_101101 + i179) << 7 + _101001) << 9
            s := mulmod(s, _101001, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // i198
            s := mulmod(s, _101101, n)

            // i220     = ((i198 << 7 + _111) << 9 + _111001) << 4
            // s = i198 << 7
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // s = (i198 << 7 + _111) << 9
            s := mulmod(s, _111, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // s = ((i198 << 7 + _111) << 9 + _111001) << 4
            s := mulmod(s, _111001, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            // i220
            s := mulmod(s, s, n)

            // i236     = ((_101 + i220) << 7 + _1101) << 6 + _1111
            // s = (_101 + i220) << 7
            s := mulmod(_101, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // s = (_101 + i220) << 7 + _1101) << 6
            s := mulmod(s, _1101, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)

            // i236
            s := mulmod(s, _1111, n)

            // i265     = ((i236 << 5 + 1) << 11 + _100011) << 11
            // s = i236 << 5
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // s = (i236 << 5 + 1) << 11
            s := mulmod(s, x, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // s = ((i236 << 5 + 1) << 11 + _100011) << 11
            s := mulmod(s, mulmod(_1100, _10111, n), n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            // i265
            s := mulmod(s, s, n)

            // i281     = ((_101101 + i265) << 4 + _1011) << 9 + _11111
            // s = (_101101 + i265) << 4
            s := mulmod(_101101, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // s = (_101101 + i265) << 4 + _1011) << 9
            s := mulmod(s, _1011, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // i281
            s := mulmod(s, mulmod(_110, _11001, n), n)

            // i299     = (i281 << 8 + _110 + _111001) << 7 + _101001
            // s = i281 << 8
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // s = (i281 << 8 + _110 + _111001) << 7
            s := mulmod(s, _110, n)
            s := mulmod(s, _111001, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            s := mulmod(s, s, n)
            s := mulmod(s, s, n)

            // i299
            s := mulmod(s, _101001, n)

            xx := mulmod(s, s, n)
        }
    }
}
