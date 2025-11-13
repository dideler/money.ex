# money.ex

Very simple library for money representation in Elixir.
Made for fun and personal use in a toy project.
Not yet recommended for use in production projects.
This project was done by hand, no vide-coding or LLMs.

## Installation

Add `money_ex` to your list of dependencies in `mix.exs`, then run `mix deps.get`.

From [Hex](https://hex.pm/packages/money_ex):

```elixir
def deps do
  [
    {:money_ex, "~> 0.2.0"}
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
    {:money_ex, git: "https://github.com/dideler/money.ex.git", tag: "0.2.0"}
  ]
end
```

The docs can be found at [https://hexdocs.pm/money_ex](https://hexdocs.pm/money_ex).

## Roadmap

- initialise: ~~new~~, parse (maybe)
- predicates: ~~equals?~~, ~~zero?~~, ~~positive?~~, ~~negative?~~, ~~gt?~~, ~~lt?~~ ~~ge?/gte?~~ ~~le?/lte?~~ ~~eq?~~ ~~ne?~~, ~~pos?~~, ~~neg?~~
- operations: ~~add~~, ~~mul~~, ~~div~~, ~~sub~~, ~~abs~~, ~~convert~~, ~~compare~~, ~~split~~, ~~allocate~~
- presenters: ~~symbol~~, ~~name~~, ~~code~~, ~~to_s/to_string~~
- extendability: user-defined currencies, user-defined conversion rates
- documentation: @docs for public API, organise with :group tag, doctests
- continuous delivery: dialyzer, credo, publish alias, warnings as errors
