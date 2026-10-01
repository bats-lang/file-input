# file-input

> **Superseded.** File input is in
> [bridge](https://github.com/bats-lang/bridge) (`file_open`, `file_claim`,
> `file_read`, `file_size`, `file_close`, `file_store`, `file_idb_put`,
> `file_idb_get`, in
> [`src/file.bats`](https://github.com/bats-lang/bridge/blob/main/src/file.bats)).
> Use `#use wasm.bats-packages.dev/bridge` instead. No package depends on
> this one since bats-lang/quire#175, and the repository is to be archived.

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
