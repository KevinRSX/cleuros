(* Some codes are borrowed from MicroC's IR generator *)

module L = Llvm
module A = Ast
open Sast

module StringMap = Map.Make(String)

let translate functions =
  let context = L.global_context () in
  let the_module = L.create_module context "cleuros" in

  (* Get types from the context *)
  let i32_t      = L.i32_type    context
  and i8_t       = L.i8_type     context
  and i1_t       = L.i1_type     context in


  (* Return the LLVM type for a MicroC type *)
  let ltype_of_typ = function
      A.Int   -> i32_t
    | A.Bool  -> i1_t
    | _ -> i8_t
  in

  let printf_t : L.lltype =
    L.var_arg_function_type i32_t [| L.pointer_type i8_t |] in
  let printf_func : L.llvalue =
    L.declare_function "printf" printf_t the_module in

  let function_decls : (L.llvalue * sfunc_def) StringMap.t =
    let function_decl m fdecl =
      let name = fdecl.sfname
      and param_types =
        Array.of_list (List.map (fun (t,_) -> ltype_of_typ t) fdecl.sargs)
      in
      let ftype = L.function_type (ltype_of_typ fdecl.srtyp) param_types in
      StringMap.add name (L.define_function name ftype the_module, fdecl) m in
    List.fold_left function_decl StringMap.empty functions in

  let gcd_ref_func =
    let ftype = L.function_type i32_t [|i32_t; i32_t|] in
    let func = L.define_function "gcd_ref" ftype the_module in
    let entry_block = L.entry_block func in
    let builder = L.builder_at_end context entry_block in
    let int_format_str = L.build_global_stringptr "Running gcd stub\n" "gcd_stub"
      builder in
    let _ = L.build_call printf_func [|int_format_str|] "res" builder in
    let _ = L.build_ret (L.const_int i32_t 10) builder in
    func
  in

  let _ =
    let ftype = L.function_type i32_t [||] in
    let func = L.define_function "main" ftype the_module in
    let entry_block = L.entry_block func in
    let builder = L.builder_at_end context entry_block in
    let int_format_str = L.build_global_stringptr "Mysterious number: %d\n" "fmt"
        builder in
    let gcd_res = L.build_call gcd_ref_func [|L.const_int i32_t 0; L.const_int i32_t 0|]
      "gcd_res" builder in
    let _ = L.build_call printf_func [|int_format_str; gcd_res|]
      "res" builder in
    L.build_ret gcd_res builder
  in
  the_module
