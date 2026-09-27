#include "share/atspre_staload.hats"
#use array as A
#use wasm.bats-packages.dev/file-input as FI

(* A read must lie inside the file: [1, n + 1) does not *)
fn f {l:agz}{n:pos | n <= 1048576} (data: !$A.borrow(byte, l, n), n: int n): void = let
  val file = $FI.file_store(data, n)
  val buf = $A.alloc<byte>(n)
  val () = $FI.file_read(file, 1, buf, n)
  val () = $A.free<byte>(buf)
in $FI.close(file) end
