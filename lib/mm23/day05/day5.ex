defmodule MM23.Day5 do
  @doc """
  Part 1

  ## Examples

      iex> MM23.Day5.part1("lib/mm23/day05/example.txt")
      35

      iex> MM23.Day5.part1("lib/mm23/day05/input.txt")
      282277027

  """
  def part1(input) do
    File.read!(input)
    |> String.split("\n\n", trim: true)
    |> then(fn [seeds_str | raw_mappings] ->
      mappings =
        Enum.map(raw_mappings, fn raw_map ->
          String.split(raw_map, "\n", trim: true)
          |> Enum.drop(1)
          |> Enum.map(fn row ->
            Regex.scan(~r/\d+/, row)
            |> List.flatten()
            |> Enum.map(&String.to_integer/1)
          end)
        end)

      Regex.scan(~r/\d+/, seeds_str)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(fn n ->
        Enum.reduce(mappings, n, fn map, n ->
          Enum.reduce_while(map, n, fn [dest, src, len], n ->
            if n >= src and n < src + len do
              {:halt, n + (dest - src)}
            else
              {:cont, n}
            end
          end)
        end)
      end)
      |> Enum.min()
    end)
  end
end
