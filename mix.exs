defmodule Money.MixProject do
  use Mix.Project

  def project do
    [
      app: :money,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Very simple library for money representation in Elixir.",
      package: [
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/dideler/money.ex"}
      ],
      docs: [
        main: "Money",
        source_ref: "v0.1.0",
        source_url: "https://github.com/dideler/money.ex",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.38", only: :dev, runtime: false}
    ]
  end
end
