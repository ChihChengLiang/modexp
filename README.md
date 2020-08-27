# ModExp in Solidity

```bash
> npm run test
  ModExp
Avg cost 38673
    ✓ modexp 1: Naive Solidity (806ms)
Avg cost 30470
    ✓ modexp 2: Naive inline assembly (517ms)
Avg cost 23981
    ✓ modexp 3: Loop unroll (461ms)
Avg cost 22847
    ✓ modexp 4: Minor optimize (362ms)
Avg cost 21179
    ✓ modexp 5: Unroll more (350ms)
Avg cost 21021
    ✓ modexp 6: Remove if statement (355ms)
Avg cost 26489
    ✓ modexp 7: Reproduce historical result (334ms)
```
