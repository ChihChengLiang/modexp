# ModExp in Solidity

![Node.js CI](https://github.com/ChihChengLiang/modexp/workflows/Node.js%20CI/badge.svg)

The modular exponentiation is a function that calculates the math expression `a^b % n`. For example, let a=5, b=3, and c=4, the expression evaluates `5^3 % 4 = 125 % 4 = 1`.

We explore the case that given the exponent `b` and the modulus `n` are fixed known numbers, how good we can perform in Solidity language. This is useful when we need to perform the hash to curve operation to validate the aggregated signature on chain.

We use the parameters of BN254 curve throughout the examples. In its hash to curve operation, we check if an input `x` has a square root on the G1 subgroup. A modexp is calculated with exponent `(n+1)/4` and modulus `n` known before the contract is deployed.

```python
n = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

def modexp(x):
    return pow(x, (n + 1) // 4, n)
```

## Test and Benchmark

```bash
> npm run test

  Ts implementation
    ✓ works at some inputs (50ms)

  ModExp
Deployment gas 628448
Avg cost 13750
    ✓ baseline: Calling EIP-198 precompile (426ms)
Avg cost 38673
    ✓ modexp 1: Naive Solidity (1203ms)
Avg cost 30470
    ✓ modexp 2: Naive inline assembly (551ms)
Avg cost 23981
    ✓ modexp 3: Loop unroll (489ms)
Avg cost 22847
    ✓ modexp 4: Minor optimize (373ms)
Avg cost 21179
    ✓ modexp 5: Unroll more (358ms)
Avg cost 21021
    ✓ modexp 6: Remove if statement (355ms)
Avg cost 26489
    ✓ modexp 7: Reproduce historical result (342ms)

  ModExp Monster code
Deployment gas 504279
Avg cost 7133
    ✓ modexp 8: monster code (257ms)

  ModExp AddChainLong
Deployment gas 499965
Avg cost 6744
    ✓ modexp 9: add chain long (233ms)
```
