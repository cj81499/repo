use clap::Parser;
use std::path::PathBuf;

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
    let mut builder = ar::Builder::new(File::create(cli.name).unwrap());

    for file in cli.files {
        builder.append_path(file).unwrap();
    }
}
