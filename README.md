# ModExp in Solidity

```bash
> npm run test

  Ts implementation
    ✓ works at some inputs (50ms)

  ModExp
Deployment gas 628448
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
