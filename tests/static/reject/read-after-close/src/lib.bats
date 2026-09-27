#include "share/atspre_staload.hats"
#use array as A
#use wasm.bats-packages.dev/file-input as FI

(* A closed file is gone: it cannot be read *)
fn f {l:agz}{n:pos | n <= 1048576} (data: !$A.borrow(byte, l, n), n: int n): void = let
  val file = $FI.file_store(data, n)
  val buf = $A.alloc<byte>(n)
  val () = $FI.close(file)
  val () = $FI.file_read(file, 0, buf, n)
in $A.free<byte>(buf) end
