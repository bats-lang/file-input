# file-input

Browser file input handling for [Bats](https://github.com/bats-lang) WASM applications.

## Features

- Open file picker dialog
- Read selected file metadata (name, size)
- Read file contents into buffer

## Usage

```bats
#use wasm.bats-packages.dev/file-input as FI

val () = $FI.open()
val size = $FI.get_size()
val name_len = $FI.get_name_len()
```

## API

See [docs/lib.md](docs/lib.md) for the full API reference.

## Target

WASM only (`#target wasm`).
