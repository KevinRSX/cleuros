(* Some codes are borrowed from MicroC's IR generator *)

module L = Llvm
module A = Ast
open Sast

(* We need not store type information here because semant has done it *)
module StringMap = Map.Make(String)

let translate_no_builtin prog =
  let context = L.global_context () in
  let the_module = L.create_module context "cleuros" in

  (* Get types from the context *)
  let i32_t      = L.i32_type    context
  and i8_t       = L.i8_type     context
  and i1_t       = L.i1_type     context
  and f_t        = L.float_type  context
  and void_t     = L.void_type   context in


  (* Return the LLVM type for a MicroC type *)
  let ltype_of_typ = function
      A.Int   -> i32_t
    | A.Bool  -> i1_t
    | A.Float -> f_t
    | A.Void  -> void_t
    | _ -> i32_t
  in

  let printf_t : L.lltype =
    L.var_arg_function_type i32_t [| L.pointer_type i8_t |] in
  let printf_func : L.llvalue =
    L.declare_function "printf" printf_t the_module in

  (* Built-in functions *)
  let print_int_func =
    let ftype = L.function_type void_t [|i32_t|] in
    let func = L.define_function "print_int_func" ftype the_module in

    let param = Array.get (L.params func) 0 in
    let entry_block = L.entry_block func in
    let builder = L.builder_at_end context entry_block in
    let int_format_str = L.build_global_stringptr "%d\n" "fmt" builder in
    let _ = L.build_call printf_func [|int_format_str; param|] "res" builder in
    let _ = L.build_ret_void builder in
    func
  in

  let function_decls : (L.llvalue * sfunc_def) StringMap.t =
    let function_decl m fdecl =
      let name = fdecl.sfname
      and param_types =
        Array.of_list (List.map (fun (t,_) -> ltype_of_typ t) fdecl.sargs)
      in
      let ftype = L.function_type (ltype_of_typ fdecl.srtyp) param_types in
      StringMap.add name (L.define_function name ftype the_module, fdecl) m in
    let custom_decl m ctdecl = m in
    let add_func_decl m = function
        SFuncDef fdecl -> function_decl m fdecl
      | SCustomTypeDef ctdecl -> custom_decl m ctdecl
    in
    List.fold_left add_func_decl StringMap.empty prog in

  let build_custom_type_body ctdecl = () in

  let build_function_body fdecl =
    let (the_function, _) = StringMap.find fdecl.sfname function_decls in
    let entry_block = L.entry_block the_function in
    let builder = L.builder_at_end context entry_block in

    let local_vars = ref (
      let add_formal m (t, n) p =
        L.set_value_name n p;
        let store_location = L.build_alloca (ltype_of_typ t) n builder in
        ignore (L.build_store p store_location builder);
        StringMap.add n store_location m
      in
      List.fold_left2 add_formal StringMap.empty fdecl.sargs
        (Array.to_list (L.params the_function))
    ) in

    (* Get storage location of a local assignment of _built-in_ types
       The first function deals with the case of a new assignment.
       The second is used by SVar, where the variable must have existed *)
    let get_local_asn_loc etype name =
      try StringMap.find name !local_vars
      with Not_found ->
          let loc = L.build_alloca (ltype_of_typ etype) name builder in
          (* print_endline ("newly storing: " ^ name); *)
          local_vars := StringMap.add name loc !local_vars;
          loc
    in

    let get_local_asn_loc_fast name = StringMap.find name !local_vars in

    (* Get storage location of arrays *)
    let local_arrs = ref StringMap.empty in

    let get_local_arr_loc etype len name =
      try StringMap.find name !local_arrs
      with Not_found ->
        let loc = L.build_alloca (L.array_type (ltype_of_typ etype) len)
                  name builder in
        local_arrs := StringMap.add name loc !local_arrs;
        loc
    in

    let get_local_arr_loc_fast name = StringMap.find name !local_arrs in


    (* Decouples type casting from evaluation
       The rule is you must cast support values, or there will be errros
       How is that supported? Because you have type checked! *)
    let cast_float i =
      let ti = L.type_of i in
      if ti = i32_t then L.const_intcast i f_t true
      else i
    in 


    (* Entry point: expression builder *)
    let rec build_expr builder ((t, e): sexpr) = match e with
        SILit i -> L.const_int i32_t i
      | SBLit b -> L.const_int i1_t (if b then 1 else 0)
      | SFLit f -> L.const_float f_t f
      | SAsn (name, (t, expr)) ->
          let e' = build_expr builder (t, expr) in
          let store = get_local_asn_loc t name in
          ignore (L.build_store e' store builder); e'
      | SVar name -> L.build_load (get_local_asn_loc_fast name) name builder;
      | SSwap (name1, name2) ->
          let loc1 = get_local_asn_loc_fast name1 in
          let loc2 = get_local_asn_loc_fast name2 in
          let v1 = L.build_load loc1 name1 builder in
          let v2 = L.build_load loc2 name2 builder in
          ignore (L.build_store v2 loc1 builder);
          ignore (L.build_store v1 loc2 builder);
          L.const_int i32_t 0 (* Bug 1 *)
      | SBinop ((t1, e1), bop, (t2, e2)) ->
          let e1' = build_expr builder (t1, e1)
          and e2' = build_expr builder (t2, e2) in
          let build_int bop el1 el2 = (match bop with
              A.Add -> L.build_add
            | A.Sub -> L.build_sub
            | A.Mul -> L.build_mul
            | A.Div -> L.build_sdiv
            | _ -> raise (Failure "Opeartion not permitted for the given type")
          ) el1 el2 "itmp" builder in (* I love ARM *)
          let build_float bop el1 el2 = (match bop with
              A.Add -> L.build_fadd
            | A.Sub -> L.build_fsub
            | A.Mul -> L.build_fmul
            | A.Div -> L.build_fdiv
            | _ -> raise (Failure "Opeartion not permitted for the given type")
          ) el1 el2 "ftmp" builder in
          let build_bool bop el1 el2 = (match bop with
              A.Neq     -> L.build_icmp L.Icmp.Ne
            | A.Eq      -> L.build_icmp L.Icmp.Eq
            | A.Less    -> L.build_icmp L.Icmp.Slt
            | A.Greater -> L.build_icmp L.Icmp.Sgt
            | A.And     -> L.build_and
            | A.Or      -> L.build_or
            | _ -> raise (Failure "Opeartion not permitted for the given type")
          ) el1 el2 "btmp" builder in
          (match t with
              Int -> build_int bop e1' e2'
            | Float -> build_float bop (cast_float e1') (cast_float e2')
            | _ -> build_bool bop e1' e2'
          )
      | SCall ("print", args) ->
          let llargs = List.rev (List.map (build_expr builder) (List.rev args)) in
          let result = "" in
          L.build_call print_int_func (Array.of_list llargs) result builder
      | SCall (f, args) ->
          let (fdef, fdecl) = StringMap.find f function_decls in
          let llargs = List.rev (List.map (build_expr builder) (List.rev args)) in
          let result = (match fdecl.srtyp with
              Void -> "" (* Bug #1 Potential *)
            | _    -> f ^ "_res") in
          L.build_call fdef (Array.of_list llargs) result builder
      (* Additional features *)
      | SArrayLit elements -> L.const_int i32_t 0 (* Bug #2 *)
      | SArrayDecl (name, len, atyp, elements) ->
          let l_elems = List.map (build_expr builder) elements in
          let arr_store = get_local_arr_loc atyp len name in
          let rec store_each_element i = function
            | [] -> ()
            | l_e :: l_rest ->
                let index = L.const_int i32_t i in
                let arr_gep = L.build_gep arr_store
                [|L.const_int i32_t 0; index|] "arr_gep" builder in
                ignore (L.build_store l_e arr_gep builder);
                store_each_element (i + 1) l_rest
          in
          ignore (store_each_element 0 l_elems);
          L.const_int i32_t 0; (* Bug #1 *)
      | SArrayAccess (name, index_sexpr) ->
          (* gep here is really strange... The first zero means you need to
             index into the pointer to the array [len * i32/i1/float],
             yielding the array itself [len * i32/i1/float]. A more consistent
             way IMO should be loading the array first because what you have
             allocated is also [len * i32/i1/float], then you can directly
             index into this thing and get the actual element, but that doesn't work
             as lli tells you that you can't gep from a non-pointer (no star). I
             don't have energy to figure this out right now...*)
          let index = build_expr builder index_sexpr in
          let arr_store = get_local_arr_loc_fast name in
          let arr_gep = L.build_gep arr_store
            [|L.const_int i32_t 0; index|] "arr_gep" builder in
          L.build_load arr_gep "arr_i" builder
      | SArrLength (name) ->
          (* Getting length can potentially be optimized, if LLVM doesn't 
             do it for us. Instead of loading, we can store the length in 
             local_arr StringMap, and retrieve the value at compile time,
             instead of loading it ourselves *)
          let arr = L.build_load (get_local_arr_loc_fast name) name builder in
          L.const_int i32_t (L.array_length (L.type_of arr))
      | SArrayMemberAsn (name, index_sexpr, value_sexpr) ->
          let value = build_expr builder value_sexpr in
          let index = build_expr builder index_sexpr in
          let arr_store = get_local_arr_loc_fast name in
          let arr_gep = L.build_gep arr_store
            [|L.const_int i32_t 0; index|] "arr_gep" builder in
          ignore (L.build_store value arr_gep builder);
          value
      | _ -> raise (Failure "Expression cannot be translated") (* TODO: SCust* *)
    in


    (* Copied from MicroC: Force adding terminators *)
    let add_terminal builder instr =
      match L.block_terminator (L.insertion_block builder) with
        Some _ -> ()
      | None -> ignore (instr builder) in

    (* Entry point: statement builder *)
    let rec build_stmt builder = function
        SBlock sb -> List.fold_left build_stmt builder sb
      | SExpr e -> ignore (build_expr builder e); builder
      | SReturn e -> ignore(L.build_ret (build_expr builder e) builder); builder
      | SIf (predicate, then_stmt, else_stmt) ->
          let bool_val = build_expr builder predicate in

          let then_bb = L.append_block context "then" the_function in
          ignore (build_stmt (L.builder_at_end context then_bb) then_stmt);
          let else_bb = L.append_block context "else" the_function in
          ignore (build_stmt (L.builder_at_end context else_bb) else_stmt);

          let end_bb = L.append_block context "if_end" the_function in
          let build_br_end = L.build_br end_bb in
          add_terminal (L.builder_at_end context then_bb) build_br_end;
          add_terminal (L.builder_at_end context else_bb) build_br_end;

          ignore(L.build_cond_br bool_val then_bb else_bb builder);
          L.builder_at_end context end_bb
      | SWhile (predicate, body) ->
          let while_bb = L.append_block context "while" the_function in
          let build_br_while = L.build_br while_bb in (* br while partial func *)

          (* Jump to while *)
          ignore (build_br_while builder);

          (* Branch in while header *)
          let while_builder = L.builder_at_end context while_bb in
          let bool_val = build_expr while_builder predicate in

          (* Build while body *)
          let while_body_bb =
            L.append_block context "while_body" the_function in
          let body_builder = L.builder_at_end context while_body_bb in
          let body_builder = build_stmt body_builder body in
          add_terminal body_builder build_br_while;

          let while_end_bb = L.append_block context "while_end" the_function in
          ignore (L.build_cond_br bool_val while_body_bb while_end_bb
                  while_builder);

          L.builder_at_end context while_end_bb
      | _ -> raise (Failure "Statement cannot be translated")
    in

    let func_builder = build_stmt builder (SBlock fdecl.sbody) in
    add_terminal func_builder (L.build_ret_void)
  in

  let rec build_prog = function
      SCustomTypeDef ctdecl -> build_custom_type_body ctdecl
    | SFuncDef fdecl -> build_function_body fdecl
  in
  List.iter build_prog prog;
  the_module

(* Remove builtin functions and construct the main function *)
let translate prog =
  let is_builtin = function
      SCustomTypeDef ctdecl -> true
    | SFuncDef fdecl -> (match fdecl.sfname with
        "print" -> false
      | _       -> true)
  in
  translate_no_builtin (List.filter is_builtin prog)
