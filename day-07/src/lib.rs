#[derive(Debug)]
struct File {
    size: u32,
    name: String,
}
#[derive(Debug)]
pub struct Folder {
    contents: Vec<Entity>,
    name: String,
}
#[derive(Debug)]
enum Entity {
    File(File),
    Folder(Folder),
}

const CORRUPTED_FILE_MESSAGE: &str = "Corrupted file";

pub fn get_file_system(log: String) -> Result<Folder, &'static str> {
    let mut result = Folder {
        name: "/".to_owned(),
        contents: vec![],
    };

    let mut current_folder = &mut result;

    let mut is_listing = false;
    for line in log.lines() {
        let statements: Vec<&str> = line.split(" ").collect();
        match *statements.get(0).expect(CORRUPTED_FILE_MESSAGE) {
            "$" => {
                // input
                match *statements.get(1).expect(CORRUPTED_FILE_MESSAGE) {
                    "ls" => {
                        is_listing = true;
                    }
                    "cd" => {
                        is_listing = false;
                        let folder_name = statements.get(2).expect(CORRUPTED_FILE_MESSAGE);

                        let new_folder = current_folder
                            .contents
                            .iter_mut()
                            .find(|content| match content {
                                Entity::File(_) => false,
                                Entity::Folder(folder) => folder.name == *folder_name,
                            })
                            .expect(CORRUPTED_FILE_MESSAGE);
                            if let Entity::Folder(folder) = new_folder {
                               current_folder = folder;
                            }
                    }
                    _ => {
                        is_listing = false;
                    }
                }
            }
            statement => {
                // output
                if is_listing {
                    let first_word = statement;
                    let second_word = statements.get(1).expect(CORRUPTED_FILE_MESSAGE);

                    if first_word == "dir".to_owned() {
                        current_folder
                            .contents
                            .push(Entity::Folder(Folder {
                                contents: vec![],
                                name: second_word.to_string(),
                            }))
                    } else {
                        current_folder
                            .contents
                            .push(Entity::File(File {
                                size: first_word.parse().unwrap(),
                                name: second_word.to_string(),
                            }))
                    }
                }
            }
        }
    }

    return Ok(result);
}
