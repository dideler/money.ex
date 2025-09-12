# money.ex

Very simple library for money representation in Elixir.
Made for fun and personal use in a toy project.
Not battle tested and feature incomplete.
Not recommended for use in your own projects.

## Installation

The package can be installed by adding `money` to your list of dependencies in `mix.exs`.

From [Hex](https://hex.pm/packages/money):

```elixir
def deps do
  [
    {:money, "~> 0.1.0"}
  ]
end
```

From GitHub:

```elixir
def deps do
  [
    {:money, github: "dideler/money.ex"}
  ]
end
```

From Git:

```elixir
def deps do
  [
    {:money, git: "https://github.com/dideler/money.ex.git", tag: "0.1.0"}
  ]
end
```

The docs can be found at [https://hexdocs.pm/money](https://hexdocs.pm/money).

## Roadmap

- initialise: ~~new~~, parse (maybe)
- predicates: ~~equals?~~, ~~zero?~~, ~~positive?~~, ~~negative?~~, ~~gt?~~, ~~lt?~~ ~~ge?/gte?~~ ~~le?/lte?~~ ~~eq?~~ ~~ne?~~, ~~pos?~~, ~~neg?~~
- operations: ~~add~~, ~~mul~~, ~~div~~, ~~sub~~, ~~abs~~, ~~convert~~, ~~compare~~, ~~split~~, allocate (maybe)
- presenters: ~~symbol~~, ~~name~~, ~~code~~, ~~to_s/to_string~~
