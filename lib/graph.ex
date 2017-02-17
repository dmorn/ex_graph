defmodule Graph do
  @moduledoc """
  `Graph` presents some useful functions for dealing with digraphs.
  """
  use Application
  alias Graph.Algo.Root
  require Logger

  @doc false
  def start(_type, _args), do: Graph.Supervisor.start_link()

  def new(), do: :digraph.new()

  def add_vertex(g, v), do: :digraph.add_vertex(g, v)
  def add_vertices(g, vertices) do
    Enum.each(vertices, fn v -> add_vertex(g, v) end)
  end

  def add_edge(g, {v1, v2}), do: :digraph.add_edge(g, v1, v2)
  def add_edges(g, edges) do
    Enum.each(edges, fn e -> add_edge(g, e) end)
  end

  def get_neighbours(g, v), do: :digraph.out_neighbours(g, v)

  @doc """
  Returns a list of paths from **start** to **goal** nodes, collected from graph **graph**.
  """
  def get_paths!(graph, start, goal, _opts \\ []) do
    Root.infect_and_collect(graph, start, goal)
  end
end
