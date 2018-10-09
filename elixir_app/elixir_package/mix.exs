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

defmodule Mix.Tasks.Compile.ElixirPackage do
  use Mix.Task

  def run(_args) do
    :ok = compile()
  end

  defp compile do
    System.put_env("LIB_DIR", priv_dir())
    File.mkdir_p!(priv_dir())
    clean_up_extension_files()
    Enum.each(["elixir_package_extension.h", "libelixir_package_extension.a"], fn(file) ->
      File.cp(project_ext_path(file), priv_path(file))
    end)

    {result, error_code} = System.cmd("make", [])
    IO.binwrite(result)

    if error_code != 0 do
      raise Mix.Error, message: """
      Could not run `make`. Please check if `make` and either `clang` or `gcc` are installed
      """
    end
    :ok
  end

  defp clean_up_extension_files do
    priv_dir()
    |> Path.join("*elixir_package*")
    |> Path.wildcard
    |> Enum.each(&File.rm_rf!/1)
  end

  defp project_ext_path(filename) do
    Path.join([__DIR__, "c_src", filename])
  end

  defp priv_path(filename) do
    Path.join(priv_dir(), filename)
  end

  defp priv_dir() do
    case :code.priv_dir(:elixir_package) do
      {:error, :bad_name} ->
        # This happens on initial compilation
        Mix.Tasks.Compile.Erlang.manifests
        |> List.first
        |> Path.dirname
        |> String.trim_trailing(".mix")
        |> Path.join("priv")
      path ->
        path
        |> List.to_string
    end
  end
end
