defmodule ElixirPackage.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_package,
      version: "0.0.1",
      name: "Elixir Package",
      description: "Test package with NIF.",
      package: package(),
      source_url: package_url(),
      homepage_url: package_url(),
      test_paths: test_paths(Mix.env()),
      elixir: "~> 1.0",
      compilers: compilers(Mix.env()),
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: []
    ]
  end

  defp package_url() do
    "https://github.com/tombruijn/rust-elixir-linking-issue-example-project"
  end

  defp package do
    %{
      files: [
        "lib",
        "c_src/*.[ch]",
        "mix.exs",
        "mix_helpers.exs",
        "Makefile"
      ],
      maintainers: ["Tom de Bruijn"],
      licenses: ["MIT"],
      links: %{"GitHub" => package_url()}
    }
  end

  def application do
    [mod: {ElixirPackage, []}, applications: [:logger]]
  end

  defp compilers(_), do: [:elixir_package] ++ Mix.compilers()
  defp test_paths(_), do: []

  defp elixirc_paths(env) do
    case test?(env) do
      true -> ["lib", "test/support"]
      false -> ["lib"]
    end
  end

  defp test?(:test), do: true
  defp test?(_), do: false
end
