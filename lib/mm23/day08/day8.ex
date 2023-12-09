defmodule MM23.Day8 do
  @doc """
  Part 1

  ## Examples

      iex> MM23.Day8.part1("lib/mm23/day08/example.txt")
      2

      iex> MM23.Day8.part1("lib/mm23/day08/example2.txt")
      6

      iex> MM23.Day8.part1("lib/mm23/day08/input.txt")
      21251

  """
  def part1(input) do
    [instructions | nodes_str] =
      File.read!(input)
      |> String.split("\n", trim: true)

    nodes_str
    |> Enum.map(&Regex.scan(~r/[A-Z]+/, &1))
    |> Enum.map(&List.flatten(&1))
    |> Enum.reduce(%{}, fn [from, left, right], map -> Map.put(map, from, [left, right]) end)
    |> find("AAA", String.to_charlist(instructions))
  end

  def find(_, "ZZZ", _) do
    0
  end

  def find(nodes, curr, instructions) do
    {curr, instructions} = next(nodes, curr, instructions)
    1 + find(nodes, curr, instructions)
  end

  def next(nodes, curr, instructions) do
    [go | instructions] = instructions

    nodes
    |> Map.get(curr)
    |> then(fn [left, right] ->
      case go do
        ?L -> {left, instructions ++ [go]}
        ?R -> {right, instructions ++ [go]}
      end
    end)
  end
end
