(* file-input -- user-selected file I/O *)

#include "share/atspre_staload.hats"

#use array as A
#use promise as P
#use wasm.bats-packages.dev/bridge as B
#use result as R

staload BF = "wasm.bats-packages.dev/bridge/src/file.sats"

(* A file of n bytes *)
#pub typedef infile(n:int) = $BF.infile(n)

(* Reads the file picked in the file input with that id; the promise
   resolves with a handle to claim *)
#pub fun open
  {li:agz}{ni:pos}
  (input_node_id: !$A.borrow(byte, li, ni), id_len: int ni)
  : $P.promise(Int, $P.Pending)

(* The file an open promise resolved with, or none if the open failed *)
#pub fun claim
  (handle: Int): $R.option([n:nat] infile(n))

#pub fun size {n:nat} (f: infile(n)): int n

(* out[0, len) := the file's bytes [file_offset, file_offset + len) *)
#pub fun file_read
  {n:nat}{o,k:nat | o + k <= n}{l:agz}{m:pos | k <= m}
  (f: infile(n), file_offset: int o,
   out: !$A.arr(byte, l, m), len: int k): void

#pub fun close {n:nat} (f: infile(n)): void

(* A file holding data[0, len) *)
#pub fun file_store
  {l:agz}{n:pos}
  (data: !$A.borrow(byte, l, n), len: int n): infile(n)

implement open{li}{ni}(input_node_id, id_len) =
  $BF.file_open(input_node_id, id_len)

implement claim(handle) = $BF.file_claim(handle)

implement size{n}(f) = $BF.file_size(f)

implement file_read{n}{o,k}{l}{m}(f, file_offset, out, len) =
  $BF.file_read(f, file_offset, out, len)

implement close{n}(f) = $BF.file_close(f)

implement file_store{l}{n}(data, len) = $BF.file_store(data, len)
