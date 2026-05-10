type extern_func = Kdo.Symbolic.Extern_func.extern_func

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
    ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Symbolic.Extern_func.extern_type;
  }
