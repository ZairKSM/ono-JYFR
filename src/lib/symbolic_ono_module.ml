type extern_func = Kdo.Symbolic.Extern_func.extern_func

let supported_constraints = [ 1; 2; 3; 4; 5; 6; 7; 8; 12; 13; 14; 15; 16; 17 ]
let active_constraints : int ref = ref 0

let set_constraints constraints =
  active_constraints :=
    List.fold_left
      (fun a constraint_id -> a lor (1 lsl constraint_id))
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
    ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Symbolic.Extern_func.extern_type;
  }
