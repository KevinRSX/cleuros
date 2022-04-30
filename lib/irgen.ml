(* Some codes are borrowed from MicroC's IR generator *)

module L = Llvm
module A = Ast
open Sast

let translate functions =
  let context = L.global_context () in
  let the_module = L.create_module context "cleuros" in

  (* Get types from the context *)
  let i32_t      = L.i32_type    context
  and i8_t       = L.i8_type     context in

  let printf_t : L.lltype =
    L.var_arg_function_type i32_t [| L.pointer_type i8_t |] in
  let printf_func : L.llvalue =
    L.declare_function "printf" printf_t the_module in

  let _ =
    let ftype = L.function_type i32_t [||] in
    let func = L.define_function "main" ftype the_module in
    let entry_block = L.entry_block func in
    let builder = L.builder_at_end context entry_block in
    let int_format_str = L.build_global_stringptr "Kevin's bday: %d\n" "fmt"
        builder in
    let _ = L.build_call printf_func [|int_format_str; L.const_int i32_t 89|] "res" builder in
    L.build_ret (L.const_int i32_t 0) builder
  in
  the_module
