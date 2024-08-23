use clap::Parser;
use std::{os::unix::fs::MetadataExt, path::PathBuf};

use ar;
use std::fs::File;

#[derive(Parser)]
#[command(version, about, long_about = None)]
struct Cli {
    name: String,
    files: Vec<PathBuf>,
}

fn main() {
    let cli = Cli::parse();
    let mut builder = ar::Builder::new(File::create(cli.name).expect("Failed to open file"));

    for path in cli.files {
        // let file: PathBuf
        let name = path.file_name().expect("Failed to get file name").as_encoded_bytes().to_vec();
        let size = path.metadata().expect("Failed to get file metadata").size();
        let header = ar::Header::new(name, size);
        builder.append(&header, File::open(&path).expect("Failed to open file")).expect("Failed to add file to ar archive");
    }
}
