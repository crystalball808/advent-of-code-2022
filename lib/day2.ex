defmodule Day2 do
  @max_red 12
  @max_green 13
  @max_blue 14

  def part_one do
    {:ok, content} = File.read("input2")

    content
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce([], &keep_possible_game_ids/2)
    |> Enum.sum()
  end

  @spec keep_possible_game_ids(String.t(), [integer()]) :: [integer()]
  @doc "Test doc"
  def keep_possible_game_ids(line, acc) do
    # Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    [game_name, game] = String.split(line, ":")

    is_possible =
      game
      |> String.split(";")
      |> is_game_possible()

    if is_possible do
      id =
        game_name
        |> String.replace(~r/\D/, "")
        |> String.to_integer()

      [id | acc]
    else
      acc
    end
  end

  @spec is_game_possible([String.t()]) :: boolean()
  def is_game_possible(remaining_rounds) do
    rem_rounds_count = length(remaining_rounds)

    if rem_rounds_count === 0 do
      true
    else
      [round | rest] = remaining_rounds

      number_color_pairs =
        Regex.scan(~r/\d+\s(green|red|blue)/, round, capture: :first)
        |> List.flatten()

      some_pair_unvalid =
        Enum.any?(number_color_pairs, fn pair ->
          [number, color] = String.split(pair, " ")

          case color do
            "red" -> String.to_integer(number) > @max_red
            "green" -> String.to_integer(number) > @max_green
            "blue" -> String.to_integer(number) > @max_blue
            _ -> false
          end
        end)

      if some_pair_unvalid do
        false
      else
        is_game_possible(rest)
      end
    end
  end
end
