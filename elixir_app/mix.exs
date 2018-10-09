defmodule ElixirApp.Mixfile do
  use Mix.Project

  def project do
    [app: :elixir_app,
     version: "0.1.0",
     elixir: "~> 1.7",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:elixir_package, path: "./elixir_package"}
    ]
  end
end
