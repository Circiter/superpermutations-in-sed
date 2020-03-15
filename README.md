# superpermutations-in-sed

A sed script to find a superpermutation of a given alphabet. It uses a greedy algorithm
closely resembling "The City Names Game", but taking the permutations of some alphabet
instead of cities and matching, if needed, more than one letter in cities' names.

Usage:
```bash
echo <alphabet> | ./superpermutations.sed
# E.g.:
echo xyz | ./superpermutations.sed
# Prints xyzxyxzyx.
```
See superpermutations.sed for details.

References:
- http://en.wikipedia.org/wiki/superpermutation
