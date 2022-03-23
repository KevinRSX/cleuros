open Ast

let symbol_table = Hashtbl.create 64 
let set (id) (v) = 
      Hashtbl.add symbol_table id v
let get (id) = 
      Hashtbl.find symbol_table id

let rec eval = function 
        Lit(x) -> x
      | Binop(e1, op, e2) -> 
            let v1 = eval e1 in 
            let v2 = eval e2 in 
            (match op with 
            | Add -> v1 + v2
            | Sub -> v1 - v2
            | Mul -> v1 * v2
            | Div -> v1 / v2
            (* TODO: implement the rest of the bops *)
            | _ -> 0)
      | Asn(id, ex) -> let v = eval ex in ((set id v ); v)
      | Var(id) -> get id
      | Swap(id1, id2) -> let tmp = get id1 in 
            (set id1 (get id2);
             set id2 tmp; 0) 

let rec eval_program = function 
      | [] -> 0
      | [hd] -> eval hd
      | hd :: tl -> ignore(eval hd); eval_program tl
