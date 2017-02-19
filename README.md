# :construction: WIP: ExGraph
[![Build Status](https://travis-ci.org/danielmorandini/ex_graph.svg?branch=master)](https://travis-ci.org/danielmorandini/ex_graph)

## Problem Overview
> In graph theory, the shortest path problem is the problem of finding a path between two vertices (or nodes) in a graph such that the sum of the weights of its constituent edges is minimized.
>
> <cite> [Wikipedia](https://en.wikipedia.org/wiki/Shortest_path_problem) </cite>

There are many algorithms available out there for solving this kind of problems, but all of them
share a common propery: their **high time complexity**.

## The Elixir Way
I tried to solve this problem using a different approach, a **concurrent** one.

### Simple Algorithm Description
* Spawn a process in the `start` nodes

* Check if current node is a `goal` node
  * `true` ->  send the path found to the `root`
  * `false` -> spawn a process for every neighbour of the current node. The process keeps track of the path travelled

Processes are linked to a root process that collects the results, gets notified when a process dies and returns the result when
the graph has been completely discovered (intensionally and consciusly, check todo list).

![graph example](https://github.com/danielmorandini/ex_graph/blob/master/static/graph_example_1.png)

## TODO
- [ ] Calculate `time complexity`. Hint: it is linear wrt the actual distance from start to end node
- [ ] Prove that the algorithm is `sound and complete`
- [ ] Check `space complecity`, see if it could be an issue with huge graphs
- [ ] Add options that allow to call `get_path!`and return just the first path/ only shortest etc
- [ ] Make it work with `weighted` graphs


## Installation
The package can be installed by adding `ex_graph` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ex_graph, github: "danielmorandini/ex_graph"}]
end
```

If cloned, run `mix test` to run all tests


