#include "share/atspre_staload.hats"
#use array as A
#use wasm.bats-packages.dev/file-input as FI

(* A stored file of n bytes is read whole *)
fn f {l:agz}{n:pos | n <= 1048576} (data: !$A.borrow(byte, l, n), n: int n): void = let
  val file = $FI.file_store(data, n)
  val buf = $A.alloc<byte>(n)
  val () = $FI.file_read(file, 0, buf, $FI.size(file))
  val () = $A.free<byte>(buf)
in $FI.close(file) end
