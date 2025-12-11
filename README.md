# money.ex

Simple lightweight library for money representation in Elixir.

Not yet recommended for use in production while major version is 0.
Currently dog-fooding the library in a personal project.

## Installation

Add `money_ex` to your list of dependencies in `mix.exs`, then run `mix deps.get`.

From [Hex](https://hex.pm/packages/money_ex):

```elixir
def deps do
  [
    {:money_ex, "~> 0.3.0"}
  ]
end
```

From GitHub:

```elixir
def deps do
  [
    {:money_ex, github: "dideler/money.ex"}
  ]
end
```

From Git:

```elixir
def deps do
  [
    {:money_ex, git: "https://github.com/dideler/money.ex.git", tag: "0.3.0"}
  ]
end
```

The docs can be found at [https://hexdocs.pm/money_ex](https://hexdocs.pm/money_ex).

## Goals

- Keep it lightweight, minimal use of dependencies
- Keep it simple, prefer design decisions that reduce complexity
- Keep it reasonably fast and performant but not at the expense of simplicity
- Extendable and configurable, building blocks instead of trying to do everything

## Anti-goals

- Out of the box support for every currency, avoid maintenance hell
- Cryptocurrency support, only focused on fiat currencies for now
- Decimal or arbitrary precision for internal representation

## Roadmap

- initialise: ~~new~~, parse (maybe)
- predicates: ~~equals?~~, ~~zero?~~, ~~positive?~~, ~~negative?~~, ~~gt?~~, ~~lt?~~ ~~ge?/gte?~~ ~~le?/lte?~~ ~~eq?~~ ~~ne?~~, ~~pos?~~, ~~neg?~~
- operations: ~~add~~, ~~mul~~, ~~div~~, ~~sub~~, ~~abs~~, ~~convert~~, ~~compare~~, ~~split~~, ~~allocate~~
- presenters: ~~symbol~~, ~~name~~, ~~code~~, ~~to_s/to_string~~
- extendability: user-defined currencies, conversion rates, rounding strategy
- documentation: @docs for public API, organise with :group tag, doctests
- continuous delivery: dialyzer, credo, publish alias, warnings as errors
- protocols: ~~String.Chars~~, Inspect, Jason.Encoder, Ecto.Type
