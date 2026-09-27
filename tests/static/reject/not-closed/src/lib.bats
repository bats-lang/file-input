#include "share/atspre_staload.hats"
#use array as A
#use wasm.bats-packages.dev/file-input as FI

(* A file must be closed, so JS lets go of its bytes *)
fn f {l:agz}{n:pos | n <= 1048576} (data: !$A.borrow(byte, l, n), n: int n): int = let
  val file = $FI.file_store(data, n)
in $FI.size(file) end
