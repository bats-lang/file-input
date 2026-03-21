(* file-input -- user-selected file I/O *)

#include "share/atspre_staload.hats"

#use array as A
#use promise as P
#use wasm.bats-packages.dev/bridge as B
#use result as R

staload BF = "wasm.bats-packages.dev/bridge/src/file.sats"
staload BS = "wasm.bats-packages.dev/bridge/src/stash.sats"

#pub fun open
  {li:agz}{ni:pos}
  (input_node_id: !$A.borrow(byte, li, ni), id_len: int ni)
  : $P.promise(int, $P.Pending)

#pub fun get_size(): [n:int] int n

#pub fun get_name_len(): int

#pub fun get_name
  {n:pos | n <= 1048576}
  (len: int n): [l:agz] $A.arr(byte, l, n)

#pub fun file_read
  {l:agz}{n:pos}
  (handle: int, file_offset: int,
   out: !$A.arr(byte, l, n), len: int n): $R.result(int, int)

#pub fun close
  (handle: int): void

#pub fun file_store
  {l:agz}{n:pos}
  (!$A.borrow(byte, l, n), int n): int

implement open{li}{ni}(input_node_id, id_len) =
  $BF.file_open(input_node_id, id_len)

implement get_size() = $BF.file_size()

implement get_name_len() = $BF.file_name_len()

implement get_name{n}(len) = $BF.file_name(len)

implement file_read{l}{n}(handle, file_offset, out, len) =
  $BF.file_read(handle, file_offset, out, len)

implement close(handle) = $BF.file_close(handle)

implement file_store{l}{n}(data, len) = $BF.file_store(data, len)
