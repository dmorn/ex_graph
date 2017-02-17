defmodule GraphTest do
  use ExUnit.Case, async: false
  require Logger

  describe "get_paths!/3; single vertex graph:" do
    setup do
      g = Graph.new()
      Graph.add_vertex(g, 1)
      {:ok, %{g: g}}
    end

    test "start and goal are the same", %{g: g} do
      assert {:ok, [[1]]} = Graph.get_paths!(g, 1, 1)
    end

    test "start and goal not in the graph", %{g: g} do
      assert {:ok, []} = Graph.get_paths!(g, 3, 4)
    end
  end

  describe "get_paths!/3; 3 vertex graph, tree structure:" do
    setup do
      g = Graph.new()
      Graph.add_vertices(g, [1,2,3])
      Graph.add_edges(g, [{1,2}, {2,3}])
      {:ok, %{g: g}}
    end

    test "start and goal connected by one edge", %{g: g} do
      assert {:ok, [[1,2]]} = Graph.get_paths!(g, 1, 2)
    end

    test "start and goal not connected", %{g: g} do
      assert {:ok, []} = Graph.get_paths!(g, 2, 1)
    end
  end

  describe "get_paths!/3; 3 vertex graph, cyclic structure:" do
    setup do
      g = Graph.new()
      Graph.add_vertices(g, [1,2,3])
      Graph.add_edges(g, [{1,2}, {1,3}, {3, 2}])
      {:ok, %{g: g}}
    end

    test "start and goal connected by 2 paths", %{g: g} do
      assert {:ok, [[1,2], [1,3,2]]} = Graph.get_paths!(g, 1, 2)
    end
  end

  describe "get_paths!/3; 5 vertices, cyclic: " do
    setup do
      g = Graph.new()
      Graph.add_vertices(g, [1,2,3,4,5])
      Graph.add_edges(g, [{1,2}, {2,1}, {1,3}, {3,1}, {1,4}, {4,3}, {3,5}])
      {:ok, %{g: g}}
    end

    test "start and goal could enter a cycle", %{g: g} do
      assert {:ok, [[1,2]]} = Graph.get_paths!(g, 1, 2)
      assert {:ok, [[1,3,5], [1,4,3,5]]} = Graph.get_paths!(g, 1, 5)
    end
  end
end
