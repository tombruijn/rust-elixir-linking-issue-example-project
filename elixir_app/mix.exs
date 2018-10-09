defmodule ElixirApp.Mixfile do
  use Mix.Project

  def project do
    [app: :elixir_app,
     version: version(),
     elixir: "~> 1.7",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :elixir_package]]
  end

  defp deps do
    [
      {:distillery, "~> 2.0"},
      {:elixir_package, path: "./elixir_package"}
    ]
  end

  defp version() do
    System.get_env("BUILD_VERSION") || "0.0.1"
  end
end
