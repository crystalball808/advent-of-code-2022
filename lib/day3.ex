defmodule Day3 do
  def part_one do
    {:ok, content} = File.read("input3")

    lines = content |> String.trim() |> String.split("\n")

    part_coordinates = get_part_coordinates(lines)

    IO.inspect(part_coordinates, label: "===\npart coordinates")
  end

  defp get_part_coordinates(lines, index \\ 0, line_parts_map \\ %{})
  defp get_part_coordinates([], _index, line_parts_map), do: line_parts_map

  defp get_part_coordinates([line | rest_lines], index, line_parts_map) do
    indexes_of_parts = line |> get_indexes_of_parts()

    if length(indexes_of_parts) > 0 do
      new_lines_map = Map.put(line_parts_map, index, indexes_of_parts)

      get_part_coordinates(rest_lines, index + 1, new_lines_map)
    else
      get_part_coordinates(rest_lines, index + 1, line_parts_map)
    end
  end

  @spec get_indexes_of_parts(String.t()) :: [integer()]
  defp get_indexes_of_parts(line) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce([], fn {grapheme, index}, acc ->
      if is_part?(grapheme) do
        [index | acc]
      else
        acc
      end
    end)
  end

  @spec is_part?(String.t()) :: boolean()
  defp is_part?(<<grapheme>>) do
    grapheme !== ?. and grapheme not in ?0..?9
  end
end
