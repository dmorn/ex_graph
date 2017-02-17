defmodule Graph.Algo.Root do
  use GenServer

  alias Graph.Algo.Bacteria
  require Logger
  @server __MODULE__

  defstruct [:caller, paths: [], refs: MapSet.new()] # Using HasMap for performance reasons.

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [opts], name: @server)
  end

  @doc """
  Starts the graph's contamination. Spawns a `Bacteria` process in the `start` node
  and set's `goal` as the goal node.

  Returns a list of possible paths from `start` to `goal`, empty list if no paths found.
  """
  def infect_and_collect(graph, start, goal) do
    GenServer.call(@server, {:infect_and_collect, graph, start, goal})
  end

  @doc """
  Spawns a `Bacteria` process with the given `node_state`.
  """
  def generate(node_state = %Bacteria{}) do
    GenServer.cast(@server, {:generate, node_state})
  end

  @doc """
  Called to notify that a path from `start` to `goal` nodes was found.
  """
  def add_path(path) do
    GenServer.cast(@server, {:path, path})
  end

  # GenServer implementation
  @doc false
  def init(_opts) do
    #all = Keyword.get(opts, :first_only, false)
    #shortest = Keyword.get(opts, :shortest, false)
    #ref = Keyword.get(opts, :ref)
    {:ok, %__MODULE__{}}
  end

  @doc false
  def handle_call({:infect_and_collect, graph, start, goal}, from, state) do
    node_state = %Bacteria{
      graph: graph,
      curr_node: start,
      goal: goal
    }

    GenServer.cast(@server, {:generate, node_state})
    {:noreply, %{state | caller: from}}
  end

  @doc false
  def handle_cast({:path, path}, state) do
    {:noreply, %{state | paths: state.paths ++ [path]}}
  end

  @doc false
  def handle_cast({:generate, node_state}, state) do
    # Link the bacteria processes to this process. We'll receive the termination messages in the `handle_info`
    # callback.
    ref =
      Bacteria
      |> spawn_link(:infect, [node_state])
      |> Process.monitor() # Otherwise we would not receive any message from the process
    {:noreply, %{state | refs: MapSet.put(state.refs, ref)}}
  end

  @doc false
  # Called when a `Bacteria` process, previously monitered, died. This happens when the process is done
  # with it's computations, i.e. it generated a `Bacteria` for each neightbour that it has or it found
  # the end of the path.
  def handle_info({:DOWN, ref, :process, _pid, :normal}, state) do
    refs = MapSet.delete(state.refs, ref)

    case MapSet.size(refs) do
      0 ->
        # WE'RE DONE. Every bacteria died, if we found a path, we've already collected it
        GenServer.reply(state.caller, {:ok, state.paths})
        {:noreply, %__MODULE__{}}
      _ ->
        {:noreply, %{state | refs: refs}}
    end
  end

  @doc false
  def handle_info(_message, state) do
    {:noreply, state}
  end
end
