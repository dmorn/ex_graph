defmodule Graph.Algo.Bacteria do
  alias Graph.Algo.Bacteria
  alias Graph.Algo.Root

  defstruct [:graph, :curr_node, :goal, path: []]

  @doc """
  The process is in a goal node. Send the path collected.
  """
  def infect(%Bacteria{curr_node: node, goal: g_node} = state) when node == g_node do
    Root.add_path(state.path ++ [node])
  end

  @doc """
  The process is in an intermediate node. Ask `Root` to infect every neightbour of the current node.
  It checks if we're falling in a cycle and avoids exploring it.
  """
  def infect(state) do
    if !Enum.member?(state.path, state.curr_node) do
      state.graph
      |> Graph.get_neighbours(state.curr_node)
      |> Enum.each(fn node -> Root.generate(%{state | path: state.path ++ [state.curr_node], curr_node: node}) end)
    end
  end
end
