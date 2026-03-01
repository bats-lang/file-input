(* file-input -- user-selected file I/O *)

#include "share/atspre_staload.hats"

#use array as A
#use promise as P
#use wasm.bats-packages.dev/bridge as B
#use result as R

#pub fun open
  {li:agz}{ni:pos}
  (input_node_id: !$A.borrow(byte, li, ni), id_len: int ni)
  : $P.promise(int, $P.Pending)

#pub fun get_size(): int

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

implement open{li}{ni}(input_node_id, id_len) =
  $B.file_open(input_node_id, id_len)

implement get_size() = $B.file_size()

implement get_name_len() = $B.file_name_len()

implement get_name{n}(len) = $B.file_name(len)

implement file_read{l}{n}(handle, file_offset, out, len) =
  $B.file_read(handle, file_offset, out, len)

implement close(handle) = $B.file_close(handle)
