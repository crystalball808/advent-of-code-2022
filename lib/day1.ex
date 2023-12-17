defmodule Day1 do
  def part_one do
    {:ok, content} = File.read("input1")

    content
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&calibrate_value/1)
    |> Enum.sum()
  end

  @spec calibrate_value(String.t()) :: integer()
  def calibrate_value(line) do
    line
    |> String.replace(~r/\D/, "", global: true)
    |> keep_first_and_last()
    |> String.to_integer()
  end

  @spec keep_first_and_last(String.t()) :: String.t()
  def keep_first_and_last(str) do
    "#{String.first(str)}#{String.last(str)}"
  end
end
