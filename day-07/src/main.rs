use std::fs;

use day_07::get_file_system;

fn main() {
    println!("test");
    let log = fs::read_to_string("input.txt").expect("Failed to read the file");

    let file_system = get_file_system(log);
    dbg!(file_system);
}
