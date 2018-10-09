defmodule ElixirPackage do
  use Application
  require Logger

  def start(_type, _args) do
    Logger.debug("ElixirPackage starting.")

    ElixirPackage.Nif.start()

    if ElixirPackage.Nif.loaded?() do
      Logger.debug("ElixirPackage started.")
    else
      Logger.error("Failed to start ElixirPackage!")
    end

    children = []

    opts = [strategy: :one_for_one, name: ElixirPackage.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def stop(_state) do
    Logger.debug("ElixirPackage stopped.")
  end
end
