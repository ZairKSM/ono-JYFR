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
  and+ config_file = config_file in

  (*si on l'option seed alors pas aléatoire sinon gamble 🇲🇹​🎰​*)
  (match seed with Some s -> Random.init s | None -> Random.self_init ());

  (* on pré-charge  -w et -h pour que read_int les renvoie *)
  Option.iter Ono.Concrete_ono_module.push_preset width;
  Option.iter Ono.Concrete_ono_module.push_preset height;

  (* on pré-charge  -w et -h pour que read_int les renvoie *)
  Option.iter Ono.Concrete_ono_module.push_preset width;
  Option.iter Ono.Concrete_ono_module.push_preset height;

  Ono.Concrete_driver.run ~source_file ?config_file () |> function
  | Ok () -> Ok ()
  | Error e -> Error (`Msg (Kdo.R.err_to_string e))

let cmd : Ono_cli.outcome Cmd.t = Cmd.v info term
