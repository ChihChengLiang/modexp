"""
https://github.com/ethereum/EIPs/blob/master/EIPS/eip-198.md
https://eips.ethereum.org/EIPS/eip-2565
https://eips.ethereum.org/EIPS/eip-2046
"""

import math

GQUADDIVISOR_198 = 20
GQUADDIVISOR_2565_OPTION2 = 3
STATICCALL_BEFORE_2046 = 700
STATICCALL_AFTER_2046 = 40

n = 0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD47


def mult_complexity_198(x):
    if x <= 64:
        return x ** 2
    elif x <= 1024:
        return x ** 2 // 4 + 96 * x - 3072
    else:
        return x ** 2 // 16 + 480 * x - 199680


def mult_complexity_2565(x):
    return math.ceil(x / 64) ^ 2


gas_cost_now = (
    math.floor(mult_complexity_198(max(32, 32)))
    * ((n + 1) // 4).bit_length()
    / GQUADDIVISOR_198
    + STATICCALL_BEFORE_2046
)

gas_cost_2565_option1_and_2046 = (
    max(100, math.floor(mult_complexity_2565(max(32, 32))))
    * ((n + 1) // 4).bit_length()
    / GQUADDIVISOR_198
    + STATICCALL_AFTER_2046
)

gas_cost_2565_option2_and_2046 = (
    max(100, mult_complexity_2565(max(32, 32)))
    * ((n + 1) // 4).bit_length()
    / GQUADDIVISOR_2565_OPTION2
    + STATICCALL_AFTER_2046
)

print("Precompile cost now:", gas_cost_now)
print("Precompile cost 2565-option-1 and 2046:", gas_cost_2565_option1_and_2046)
print("Precompile cost 2565-option-2 and 2046:", gas_cost_2565_option2_and_2046)
