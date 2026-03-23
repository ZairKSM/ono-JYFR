(* The `ono concrete` command. *)

open Cmdliner
open Ono_cli

let info = Cmd.info "concrete" ~exits

let term =
  let open Term.Syntax in
  let+ () = setup_log
 
  and+ source_file = source_file
 
  and+ seed = seed
  and+ width = width
  and+ height = height
  and+ steps = steps
  and+ show_latest = show_latest
  and+ config_file = config_file in

  (*si on l'option seed alors pas aléatoire sinon gamble 🇲🇹​🎰​*)
  (match seed with Some s -> Random.init s | None -> Random.self_init ());
  (* on pré-charge  -w et -h pour que read_int les renvoie *)
  Option.iter Ono.Concrete_ono_module.push_preset width;
  Option.iter Ono.Concrete_ono_module.push_preset height;

  (* on renta la monade*)
  let ( let* ) = Result.bind in
  let* () =
    match steps with
    | Some n when n < 0 -> Error (`Msg "--steps doit etre >= 0")
    | _ -> Ok ()
  in
  Ono.Concrete_ono_module.set_steps_limit steps;
  let* () =
    match show_latest with
    | Some n when n <= 0 -> Error (`Msg "-show_latest doit etre > 0")
    | Some _ when steps = None -> Error (`Msg "--show_latest doit être appelé avec --steps")
    | _ -> Ok ()
  in
  Ono.Concrete_ono_module.set_show_latest_number show_latest;
  Ono.Concrete_driver.run ~source_file ?config_file () |> function
  | Ok () -> Ok ()
  | Error e -> Error (`Msg (Kdo.R.err_to_string e))

let cmd : Ono_cli.outcome Cmd.t = Cmd.v info term
