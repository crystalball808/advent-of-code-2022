import file_streams/file_stream
import gleam/int
import gleam/io
import gleam/result
import gleam/string

const input_path = "src/day_1/test.txt"

pub fn main() {
  let assert Ok(stream) = file_stream.open_read(input_path)

  let location_ids = collect_location_ids(stream, #([], []))

  io.debug(location_ids)
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
    Error(error) -> {
      io.debug(error)
      acc
    }
  }
}

fn parse_line(line: String) -> Result(#(Int, Int), Nil) {
  let assert [first_number, second_number] =
    line
    |> string.trim_end
    |> string.split(on: "   ")

  use first_number_parsed <- result.try(int.parse(first_number))
  use second_number_parsed <- result.try(int.parse(second_number))

  Ok(#(first_number_parsed, second_number_parsed))
}
