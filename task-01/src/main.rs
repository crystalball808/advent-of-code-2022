use std::fs;

fn main() {
    let current_dir = std::env::current_dir().unwrap().to_str().unwrap().to_string();
    let path = current_dir + "\\input.txt";
    println!("Path: {}", path);

    let input = fs::read_to_string("input.txt").expect("Failed to read the file");

    for line in input.lines() {
        println!("{} line", line);
    }
}
