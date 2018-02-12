# Finite Automata

## Turing Machines

* Theoretical model for computation
* Machine with infinite state (tape), the ability to respond to current state, and the ability to move forwards and backwards on the tape
* Introduced in 1936; was quickly noted that this model does not account for runtime complexity. In the 1960s, time and space complexity were formally described in computational complexity theory.

### Turing machines vs. FSMs

* Turing machines are FSMs with the addition of memory (the "tape")
* FSMs can *sort of* be seen as having a tape as well (but it will be read-only, and can only proceed in one direction).
  * In other words, FSM's "memory" is limited to the current symbol, i.e. the current state.
* FSMs can parse regular expressions, but not arbitrarily recursive expressions. Turing machinese can parse recursive languages (and, well, anything that's computable).
* A Turing machine with a finite-length tape is equivalent to a FSM.
  * TM future state is a function of current tape. With a finite alphabet and finite length, there is a finite number of combinations; i.e., a finite number of states.

## Example applications of FSMs

* Regex engines
  * `^[a-z][0-9]*$`
  * Initial state: first character
  * If state is first character and current character is in set a-z, set state to subsequent characters and move to next character else error
  * If state is subsequent character and current character is in set 0-9, move to next character else error
  * If no more characters, halt
* Circuits
  * Combination of circuits leads to arbitrary finite combination of states

## Formal Languages

Formal languages are a set of strings:

* Finite vocabulary (aka an "alphabet")
  * Empty set is regular
  * Set with empty string is regular
  * Set `{ a }` is regular for all a in some finite alphabet
* Set of string-combining operations describe generation of regular languages for other regular languagues (i.e. two regular languages combined using below operations is also a regular language):
  * Concatenation: L1 concatenated with L2 = set of strings where start is a member of L1 and end is a member of L2; `L1 . L2 = {xy|x in L1, y in L2}`
  * Union: set union
  * Kleene closure: L* = L0 U L1 U L2... where Li = L concatenated with L i times. If L is a language where only character is `a`, `L* = (a|aa|aaa...)`
  * Complement: all strings not in some language
  * Difference: all strings in L1 but not in L2
  * Intersection
  * Reversal -- set of flipped strings

Regular languages are the simplest class of formal languages, and are definable by **regular expressions**.

* Regular expressions are finite state machines that define search patterns for a regular language.
  * Note that unlike modern implementations of regex engines, formal language regular expressions DO NOT have memory, letting them match recursive subpatterns, back-reference, etc. Theoretical regular expressions are equivalent to FSMs.
* Regular languages DO NOT describe recursive nesting, i.e. center-embedded constructions
  * HTML/XML is not regular: you can have arbitrary nesting of tags. To verify if some HTML is correct one must be able to verify that every opening tag is closed. This is impossible without some form of memory.
  * Simpler example: a language `L = { word in a^ib^i for some i >= 0 }`, e.g. `{ ab, aabb, aaabbb... }`. FSM would look like: if char is A, expect A or B next, if next is A, expect A or BBB next, if next is A, expect A or BBBB next... going on forever.
