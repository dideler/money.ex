# money.ex

Very simple library for money representation in Elixir.
Made for fun and personal use in a toy project.
Not battle tested and feature incomplete.
Not recommended for use in your own projects.

## Installation

```elixir
def deps do
  [
    {:money, "~> 0.1.0"}, # If published to Hex
    {:money, github: "dideler/money.ex"},
    {:money, git: "https://github.com/dideler/money.ex.git", tag: "0.1.0"}
  ]
end
```

## Roadmap

- initialise: new, parse (maybe)
- predicates: equals?, zero?, positive?, negative?, gt?, lt? ge?/gte? le?/lte? eq? ne?, pos?, neg?
- operations: add, mul, div, sub, abs, convert, compare, split, allocate (maybe)
- presenters: symbol, name, code, to_s/to_string
