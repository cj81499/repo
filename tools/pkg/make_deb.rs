use clap::Parser;
use std::{os::unix::fs::MetadataExt, path::PathBuf};

use ar::{self, Builder, Header};
use std::fs::File;

#[derive(Parser)]
#[command(version, about, long_about = None)]
struct Cli {
    name: String,
    control: PathBuf,
    data: PathBuf,
}

fn main() {
    let cli = Cli::parse();
    let mut builder = Builder::new(File::create(cli.name).unwrap());

    // debian-binary
    let data = "2.0\n";
    let mut header = Header::new("debian-binary".into(), data.len().try_into().unwrap());
    header.set_mode(0o644);
    builder.append(&header, data.as_bytes()).unwrap();

    // control
    // TODO: validate that name matches expectations - can we do this using clap?
    let name = cli.control.file_name().unwrap().as_encoded_bytes().into();
    let mut file = File::open(&cli.control).unwrap();
    let mut header = Header::new(name, file.metadata().unwrap().size());
    header.set_mode(0o644);
    builder.append(&header, &mut file).unwrap();

    // data
    // TODO: validate that name matches expectations - can we do this using clap?
    let name = cli.data.file_name().unwrap().as_encoded_bytes().into();
    let mut file = File::open(&cli.data).unwrap();
    let mut header = Header::new(name, file.metadata().unwrap().size());
    header.set_mode(0o644);
    builder.append(&header, &mut file).unwrap();
}
