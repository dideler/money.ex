defmodule Money.MixProject do
  use Mix.Project

  @version "0.2.0"
  @source_url "https://github.com/dideler/money.ex"

  def project do
    [
      app: :money_ex,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Very simple library for money representation in Elixir.",
      package: [
        licenses: ["MIT"],
        links: %{"GitHub" => @source_url}
      ],
      docs: [
        main: "Money",
        source_ref: "v#{@version}",
        source_url: @source_url,
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
      {:ex_doc, "~> 0.39", only: :dev, runtime: false},
      {:decimal, "~> 2.0", only: :test}
    ]
  end
end
