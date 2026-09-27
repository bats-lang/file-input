#include "share/atspre_staload.hats"
#use array as A
#use wasm.bats-packages.dev/file-input as FI

(* A file of any size (past alloc's 1 MiB) is read whole into the piece
   of an arena sized to it *)
fn f {n:nat} (file: $FI.infile(n)): void = let
  val n = $FI.size(file)
in
  if n <= 0 then $FI.close(file)
  else if n > 268435456 then $FI.close(file)
  else case+ $A.arena_create<byte>(n) of
    | ~$A.arena_none() => $FI.close(file)
    | ~$A.arena_some(ar) => let
        val p = $A.arena_alloc<byte>(ar, n)
        val () = $FI.file_read(file, 0, p, n)
        val () = $A.arena_return<byte>(ar, p)
        val () = $A.arena_destroy<byte>(ar)
      in $FI.close(file) end
end
