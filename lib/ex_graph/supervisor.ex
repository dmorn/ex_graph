defmodule ExGraph.Supervisor do
  @moduledoc false
  use Supervisor
  alias ExGraph.Algo.Root

  @doc false
  def start_link() do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @doc false
  def init(:ok) do
    children = [
      worker(Root, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end