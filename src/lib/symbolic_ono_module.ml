type extern_func = Kdo.Symbolic.Extern_func.extern_func

let supported_constraints = [ 1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12; 13; 14; 15; 16; 17 ]
let active_constraints : int ref = ref 0
let active_constraint_args : (int, int) Hashtbl.t = Hashtbl.create 8

type constraint_spec = {
  id : int;
  arg : int option;
}

let default_constraint_arg = function 13 -> 2 | 15 -> 4 | 17 -> 4 | _ -> 0

let set_constraints constraints =
  Hashtbl.reset active_constraint_args;
  List.iter
    (fun { id; arg } ->
      match arg with
      | Some value -> Hashtbl.replace active_constraint_args id value
      | None -> ())
    constraints;
  active_constraints :=
    List.fold_left
      (fun a { id; _ } -> a lor (1 lsl id))
      0 constraints

let print_i32 (n : Kdo.Symbolic.I32.t) : unit Kdo.Symbolic.Choice.t =
  Logs.app (fun m -> m "%a" Kdo.Symbolic.I32.pp n);
  Kdo.Symbolic.Choice.return ()

let i32_symbol () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  Kdo.Symbolic.Choice.with_new_symbol (Smtml.Ty.Ty_bitv 32)
    Kdo.Symbolic.I32.symbol

let read_int () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  let n =
    Format.printf "Enter an integer :%!";
    Scanf.scanf " %d" Fun.id
  in
  Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int n)

let get_generation_width () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int Generation_config.width)

let get_generation_height () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int Generation_config.height)

let get_constraints () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int !active_constraints)

let get_constraint_arg_value constraint_id =
  let value =
    Hashtbl.find_opt active_constraint_args constraint_id
    |> Option.value ~default:(default_constraint_arg constraint_id)
  in
  value

let get_constraint_13_arg () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  let value = get_constraint_arg_value 13 in
  Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int value)

let get_constraint_15_arg () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  let value = get_constraint_arg_value 15 in
  Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int value)

let get_constraint_17_arg () : Kdo.Symbolic.I32.t Kdo.Symbolic.Choice.t =
  let value = get_constraint_arg_value 17 in
  Kdo.Symbolic.Choice.return (Kdo.Symbolic.I32.of_int value)

let m =
  let open Kdo.Symbolic.Extern_func in
  let open Kdo.Symbolic.Extern_func.Syntax in
  let functions =
    [
      ("print_i32", Extern_func (i32 ^->. unit, print_i32));
      ("i32_symbol", Extern_func (unit ^->. i32, i32_symbol));
      ("read_int", Extern_func (unit ^->. i32, read_int));
      ("get_generation_width", Extern_func (unit ^->. i32, get_generation_width));
      ( "get_generation_height",
        Extern_func (unit ^->. i32, get_generation_height) );
      ("get_constraints", Extern_func (unit ^->. i32, get_constraints));
      ("get_constraint_13_arg", Extern_func (unit ^->. i32, get_constraint_13_arg));
      ("get_constraint_15_arg", Extern_func (unit ^->. i32, get_constraint_15_arg));
      ("get_constraint_17_arg", Extern_func (unit ^->. i32, get_constraint_17_arg));
    ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Symbolic.Extern_func.extern_type;
  }
