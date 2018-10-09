defmodule ElixirPackage.Nif do
  @on_load :init

  def init do
    path = :filename.join(:code.priv_dir(:elixir_package), 'elixir_package_extension')

    case :erlang.load_nif(path, 1) do
      :ok ->
        :ok

      {:error, {:load_failed, reason}} ->
        arch = :erlang.system_info(:system_architecture)

        message = "[#{DateTime.utc_now() |> to_string}] Error loading NIF (host triple: #{arch})\nError: #{reason}\n\n"

        :elixir_package
        |> Application.app_dir()
        |> Path.join("install.log")
        |> File.write(message, [:append])

        :ok
    end
  end

  def start do
    _start()
  end

  def stop do
    _stop()
  end

  def loaded? do
    _loaded()
  end

  def _start do
    0
  end

  def _stop do
    0
  end

  def _loaded do
    false
  end
end
