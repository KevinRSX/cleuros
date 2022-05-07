open Test_helper
open Semant
open Irgen
open Ast


type action = Ast | Sast | LLVM_IR

let usage = "Usage: " ^ Sys.argv.(0) ^ " [-a|-s|-l] <source.cl>"

let () =
  (* Command line arg parsing borrowed from MicroC *)
  let action = ref LLVM_IR in
  let set_action a () = action := a in
  let speclist = [
    ("-a", Arg.Unit (set_action Ast), "Print the AST");
    ("-s", Arg.Unit (set_action Sast), "Print the SAST");
    ("-l", Arg.Unit (set_action LLVM_IR), "Print the generated LLVM IR");
  ] in
  let s = ref "" in
  Arg.parse speclist (fun filename -> s := progstr_from_file filename) usage;

  match !action with
  Ast -> print_parsed !s
  | _ -> ( let ast = get_ast !s in 
    let sast = check_program  ast in
    match !action with 
    | Ast -> print_parsed !s 
    | Sast -> print_endline (Sast.string_of_sprogram sast);
    | LLVM_IR -> print_endline (L.string_of_llmodule (translate sast));
  )
