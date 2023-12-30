defmodule Day3 do
  def part_one do
    {:ok, content} = File.read("input3")

    lines_with_index = content |> String.trim() |> String.split("\n") |> Enum.with_index()

    part_coordinates = get_part_coordinates(lines_with_index)

    numbers_with_parts = get_numbers_with_parts(lines_with_index, part_coordinates)

    numbers_with_parts |> Enum.map(&String.to_integer/1) |> Enum.sum()
  end

  def get_numbers_with_parts(lines_with_index, part_coordinates, numbers_with_parts \\ [])
  def get_numbers_with_parts([], _part_coordinates, numbers_with_parts), do: numbers_with_parts

  def get_numbers_with_parts(
        [{line, index} | rest_lines],
        part_coordinates,
        numbers_with_parts
      ) do
    filter_condition = fn number_position ->
      has_part?(number_position, Map.get(part_coordinates, index - 1)) or
        has_part?(number_position, Map.get(part_coordinates, index)) or
        has_part?(number_position, Map.get(part_coordinates, index + 1))
    end

    numbers_with_parts_from_line =
      Regex.scan(~r/\d+/, line, return: :index)
      |> List.flatten()
      |> Enum.filter(filter_condition)
      |> Enum.map(fn number_position ->
        String.slice(line, elem(number_position, 0), elem(number_position, 1))
      end)

    get_numbers_with_parts(
      rest_lines,
      part_coordinates,
      numbers_with_parts_from_line ++ numbers_with_parts
    )
  end

  defp has_part?({number_start, number_length}, index_list) do
    if index_list === nil do
      false
    else
      number_end = number_start + number_length - 1
      range_to_check = (number_start - 1)..(number_end + 1)

      Enum.any?(index_list, fn index -> index in range_to_check end)
    end
  end

  def get_part_coordinates(lines_with_index, line_parts_map \\ %{})
  def get_part_coordinates([], line_parts_map), do: line_parts_map

  def get_part_coordinates([{line, index} | rest_lines], line_parts_map) do
    indexes_of_parts = line |> get_indexes_of_parts()

    if length(indexes_of_parts) > 0 do
      new_lines_map = Map.put(line_parts_map, index, indexes_of_parts)

      get_part_coordinates(rest_lines, new_lines_map)
    else
      get_part_coordinates(rest_lines, line_parts_map)
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
