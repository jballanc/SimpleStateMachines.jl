# SimpleStateMachines.jl

## What is this?

This repository is a collection of some simple examples of using "plain" Julia
(i.e. not dependent on any particular library) to implement state machines. The
initial `Cake` and `RegEx` examples were first covered in the JuliaCon 2019 talk
titled "Julia's Killer App(s): Implementing State Machines Simply using Multiple
Dispatch" ([video](https://www.youtube.com/watch?v=WGT9_cEImAk)).

## Contributing

Any suggestions or improvements to the existing examples are welcomed.
Additionally, any additional "simple state machine" examples would definitely be
considered for inclusion.

## State Machines

### Cake

`Cake` is a fun, simple demonstration of encoding the process of baking a cake
as a state machine. Possible states are:

* `NeedIngredients` - initial state; tracks ingredients already gathered
* `MixBatter` - tracks remaining ingredients to be added
* `RuinedBatter`
* `RawBatter`
* `BurntCake`
* `TastyCake`

Possible transitions are:

* `Gather` - specifies the ingredient being gathered
* `Add` - specifies the ingredients being added to the batter
* `Bake` - specifies the temperature the batter is being baked at

Finally, the `step` function accepts a state and a transition and always returns
a new state. As such, it can be used to `reduce` over a list of transitions in
order to "run" the state machine.


### RegEx

The `RegEx` example does *not* actually encode a full regular language
expression parser, but rather demonstrates the beginnings of how one might be
implemented as a state machine in Julia. In this implementation various
`Matcher`s are used as the states and the characters of the string to be
matched, converted to `Val` types, are the transitions. Unlike the `Cake`
example where the state machine had a fixed structure encoded in the
implementation, the `Matcher`s used in `RegEx` behave as a linked-list or tree
of states. Matchers currently implemented include:

* `MatchChar`
* `Wildcard`
* `Or`
