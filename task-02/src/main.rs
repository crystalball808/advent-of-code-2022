use std::fs;
use unicode_segmentation::UnicodeSegmentation;

const MY_ROCK_SHAPE: &str = "X";
const MY_PAPER_SHAPE: &str = "Y";
const MY_SCISSORS_SHAPE: &str = "Z";

const ENEMY_ROCK_SHAPE: &str = "A";
const ENEMY_PAPER_SHAPE: &str = "B";
const ENEMY_SCISSORS_SHAPE: &str = "C";
fn main() {
    let input = fs::read_to_string("input.txt").expect("Failed to read the file");
    let mut total_score: u32 = 0;
    for round in input.split("\n") {
        if round.len() == 0 { continue }
        let graphemes = round.graphemes(true).collect::<Vec<&str>>();

        let enemy_shape = *graphemes.get(0).expect("Unable to read shapes");
        let my_shape = *graphemes.get(2).expect("Unable to read shapes");

        // Points based on shape
        if my_shape == MY_ROCK_SHAPE { total_score += 1 }
        if my_shape == MY_PAPER_SHAPE { total_score += 2 }
        if my_shape == MY_SCISSORS_SHAPE { total_score += 3 }

        // Points based on round result

        // Draw
        if my_shape == MY_ROCK_SHAPE && enemy_shape == ENEMY_ROCK_SHAPE { total_score += 3 }
        if my_shape == MY_PAPER_SHAPE && enemy_shape == ENEMY_PAPER_SHAPE { total_score += 3 }
        if my_shape == MY_SCISSORS_SHAPE && enemy_shape == ENEMY_SCISSORS_SHAPE { total_score += 3 }

        // Win
        if my_shape == MY_ROCK_SHAPE && enemy_shape == ENEMY_SCISSORS_SHAPE { total_score += 6 }
        if my_shape == MY_PAPER_SHAPE && enemy_shape == ENEMY_ROCK_SHAPE { total_score += 6 }
        if my_shape == MY_SCISSORS_SHAPE && enemy_shape == ENEMY_PAPER_SHAPE { total_score += 6 }
    }
    println!("Total score: {total_score}")
}
