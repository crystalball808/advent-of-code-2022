use std::{collections::HashMap, fs, process::exit};

fn main() {
    let input = fs::read_to_string("input.txt").expect("Failed to open file");
    let chars: Vec<char> = input.chars().collect();
    if chars.len() < 4 {
        panic!("There should by at least 4 chars in the input!");
    }

    let mut start = 0;

    let mut char_hash: HashMap<char, usize> = HashMap::new();
    loop {
        let end = start + 3;
        let buffer_slice = chars.get(start..=end).unwrap();
        let mut all_unique = true;

        for (index, char) in buffer_slice.iter().enumerate() {
            match char_hash.insert(*char, index) {
                Some(index_of_present) => {
                    // shift to the next char after the duplicated one
                    start = start + index_of_present + 1;
                    all_unique = false;
                }
                _ => {}
            }
        }

        if all_unique {
            // convert index to real number
            println!("The answer is {}", end + 1);
            exit(0);
        } else {
            char_hash.clear();
        }
    }
}
