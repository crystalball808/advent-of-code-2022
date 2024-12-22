import file_streams/file_stream
import gleam/io

const input_path = "src/day_1/test.txt"

pub fn main() {
  let assert Ok(stream) = file_stream.open_read(input_path)
  io.debug(stream)
}
