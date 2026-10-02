(* file-input -- user-selected file I/O *)

#include "share/atspre_staload.hats"

#use array as A
#use promise as P
#use wasm.bats-packages.dev/bridge as B
#use result as R

staload BF = "wasm.bats-packages.dev/bridge/src/file.sats"
staload BI = "wasm.bats-packages.dev/bridge/src/idb.sats"

(* A file of n bytes, held by JS. It is linear: claimed once, borrowed by
   size, file_read and idb_put, and consumed by close, which lets JS
   release its bytes; a closed file cannot be read *)
#pub vtypedef infile(n:int) = $BF.infile(n)

(* What opening a file found (bridge's opened: Opened of a file,
   NotOpened when none was picked, or OpenFailed when it could not be
   read) *)
#pub vtypedef opened = $BF.opened

(* Reads the file picked in the file input with that id *)
#pub fun open
  {li:agz}{ni:pos}
  (input_node_id: !$A.borrow(byte, li, ni), id_len: int ni)
  : $P.promise(opened, $P.Chained)

(* The file of a handle JS passed, or none *)
#pub fun claim
  (handle: Int): $R.option([n:nat] infile(n))

#pub fun size {n:nat} (f: !infile(n)): int n

(* out[0, len) := the file's bytes [file_offset, file_offset + len) *)
#pub fun file_read
  {n:nat}{o,k:nat | o + k <= n}{l:agz}{ow:addr}{m:pos | k <= m}
  (f: !infile(n), file_offset: int o,
   out: !$A.arrx(byte, l, m, ow), len: int k): void

#pub fun close {n:nat} (f: infile(n)): void

(* A file holding data[0, len) *)
#pub fun file_store
  {l:agz}{n:pos}
  (data: !$A.borrow(byte, l, n), len: int n): infile(n)

(* Whether a store was kept (bridge's stored: Stored or NotStored) *)
#pub typedef stored = $BI.stored

(* What a read found (bridge's file_lookup: FileFound of a file,
   FileAbsent, or FileUnreadable when it could not be read) *)
#pub vtypedef file_lookup = $BF.file_lookup

(* Stores f's bytes in IndexedDB under key, without copying them through
   wasm memory *)
#pub fun idb_put
  {lk:agz}{nk:pos}{n:nat}
  (key: !$A.borrow(byte, lk, nk), key_len: int nk, f: !infile(n))
  : $P.promise(stored, $P.Chained)

(* The bytes idb_put stored under key, as a file *)
#pub fun idb_get
  {lk:agz}{nk:pos}
  (key: !$A.borrow(byte, lk, nk), key_len: int nk)
  : $P.promise(file_lookup, $P.Chained)

implement idb_put{lk}{nk}{n}(key, key_len, f) = $BF.file_idb_put(key, key_len, f)

implement idb_get{lk}{nk}(key, key_len) = $BF.file_idb_get(key, key_len)

implement open{li}{ni}(input_node_id, id_len) =
  $BF.file_open(input_node_id, id_len)

implement claim(handle) = $BF.file_claim(handle)

implement size{n}(f) = $BF.file_size(f)

implement file_read{n}{o,k}{l}{ow}{m}(f, file_offset, out, len) =
  $BF.file_read(f, file_offset, out, len)

implement close{n}(f) = $BF.file_close(f)

implement file_store{l}{n}(data, len) = $BF.file_store(data, len)
