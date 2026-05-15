(* The `ono symbolic` command. *)

open Cmdliner
open Ono_cli

let info = Cmd.info "symbolic" ~exits

let term =
  let open Term.Syntax in
  let+ () = setup_log
  and+ source_file = source_file
  and+ constraints = constraints in
  let invalid_constraints =
    List.filter
      (fun { Ono.Symbolic_ono_module.id; _ } ->
        not
          (List.mem id Ono.Symbolic_ono_module.supported_constraints))
      constraints
  in
  if invalid_constraints <> [] then
    let constraints =
      invalid_constraints
      |> List.map (fun { Ono.Symbolic_ono_module.id; _ } -> string_of_int id)
      |> String.concat ", "
    in
    Error (`Msg ("contrainte non supportee: " ^ constraints))
  else
    Ono.Symbolic_driver.run ~source_file ~constraints |> function
    | Ok () -> Ok ()
    | Error e -> Error (`Msg (Kdo.R.err_to_string e))

let cmd : Ono_cli.outcome Cmd.t = Cmd.v info term
