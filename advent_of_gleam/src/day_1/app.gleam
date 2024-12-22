import file_streams/file_stream
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

const input_path = "src/day_1/input.txt"

pub fn main() {
  let assert Ok(stream) = file_stream.open_read(input_path)

  let #(first_list, second_list) = collect_location_ids(stream, #([], []))

  let first_sorted = list.sort(first_list, by: int.compare)
  let second_sorted = list.sort(second_list, by: int.compare)

  use zipped <- result.try(list.strict_zip(first_sorted, second_sorted))

  let res =
    list.fold(zipped, 0, fn(acc, pair) {
      acc + int.absolute_value(pair.0 - pair.1)
    })

  io.println("Day 1, first part: " <> int.to_string(res))

  Ok(Nil)
}

type Lists =
  #(List(Int), List(Int))

fn collect_location_ids(stream: file_stream.FileStream, acc: Lists) -> Lists {
  case file_stream.read_line(stream) {
    Ok(line) -> {
      let assert Ok(#(first_number, second_number)) = parse_line(line)

      let new_acc = #([first_number, ..acc.0], [second_number, ..acc.1])
      collect_location_ids(stream, new_acc)
    }
    Error(_) -> {
      acc
    }
  }
}

/// Parse a line that should resemble a pattern "X   Y"
/// 
/// ## Examples
/// ```gleam
/// let assert Ok(#(36, 17)) = parse_line("36   17")
/// ```
fn parse_line(line: String) -> Result(#(Int, Int), Nil) {
  let assert [first_number, second_number] =
    line
    |> string.trim_end
    |> string.split(on: "   ")

  use first_number_parsed <- result.try(int.parse(first_number))
  use second_number_parsed <- result.try(int.parse(second_number))

  Ok(#(first_number_parsed, second_number_parsed))
}
