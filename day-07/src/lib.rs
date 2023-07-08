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

fn find_folder_by_name_mut<'a>(name: &'a str, tree: &'a mut Folder) -> Option<&'a mut Folder> {
    if tree.name == name {
        return Some(tree);
    }
    for entity in &mut tree.contents {
        if let Entity::Folder(folder) = entity {
            if folder.name == name {
                return Some(folder);
            }

            let maybe_folder = find_folder_by_name_mut(name, folder);

            if let Some(_) = maybe_folder {
               return maybe_folder 
            }
        }
    }

    None
}

fn find_name_of_parent_folder<'a>(name: &'a str, tree: &'a Folder) -> Option<&'a str> {
    for entity in &tree.contents {
        if let Entity::Folder(folder) = entity {
            if folder.name == name {
                return Some(&tree.name);
            }

            let from_children = find_name_of_parent_folder(name, folder);

            if let Some(_) = from_children {
               return from_children 
            }
        }
    }

    None
}

pub fn get_file_system(log: String) -> Result<Folder, &'static str> {
    let mut result = Folder {
        name: "/".to_owned(),
        contents: vec![],
    };

    let mut current_folder_name: String = "/".to_owned();

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

                        match *folder_name {
                            ".." => {
                                current_folder_name =
                                    find_name_of_parent_folder(&current_folder_name, &result)
                                        .expect(&format!(
                                            "Cannot find a parent of folder: {}",
                                            current_folder_name
                                        ))
                                        .to_owned();
                            }
                            other => {
                                current_folder_name = String::from(other);
                            }
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
                    let name_of_new_entity = statements.get(1).expect(CORRUPTED_FILE_MESSAGE);

                    let current_folder =
                        find_folder_by_name_mut(&current_folder_name, &mut result).expect(
                            &format!("Cannot find a folder with name: {}", current_folder_name),
                        );

                    if statement == "dir" {
                        current_folder.contents.push(Entity::Folder(Folder {
                            contents: vec![],
                            name: name_of_new_entity.to_string(),
                        }))
                    } else {
                        current_folder.contents.push(Entity::File(File {
                            size: statement.parse().unwrap(),
                            name: name_of_new_entity.to_string(),
                        }))
                    }

                }
            }
        }
    }

    return Ok(result);
}
