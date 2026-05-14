open Syntax
module Interpret = Kdo.Interpret.Symbolic (Kdo.Interpret.Default_parameters)

(* info de sortie pour le mode generation *)
type generation_output = {
  workspace : Fpath.t;
  model_base : Fpath.t;
  model_file : Fpath.t;
  output_file : Fpath.t;
}

let is_game_of_life_generator source_file =
  Fpath.basename source_file = "generate.wat"
  && Fpath.basename (Fpath.parent source_file) = "generation"

(* préparation du dossier temporaire *)
let prepare_generation_output source_file =
  let temp_dir = Filename.temp_file "ono-gol" "" in
  Sys.remove temp_dir;
  Unix.mkdir temp_dir 0o700;
  let workspace = Fpath.v temp_dir in
  let model_base = Fpath.(workspace / "model") in
  let model_file = Fpath.add_ext "scfg" model_base in
  let output_file = Fpath.add_ext "gol" (Fpath.rem_ext source_file) in
  { workspace; model_base; model_file; output_file }

(* nettoyage du dossier temporaire. *)
let rec rm_rf path =
  if Sys.file_exists path then
    if Sys.is_directory path then begin
      Sys.readdir path
      |> Array.iter (fun entry -> rm_rf (Filename.concat path entry));
      Unix.rmdir path
    end
    else Sys.remove path

let cleanup_generation_output { workspace; _ } =
  rm_rf (Fpath.to_string workspace)

let run ~source_file ~constraints =
  Symbolic_ono_module.set_constraints constraints;

  (* Parsing. *)
  Logs.info (fun m -> m "Parsing file %a..." Fpath.pp source_file);
  let* wat_module = Kdo.Parse.Wat.Module.from_file source_file in
  Logs.debug (fun m ->
      m "Parsed module is:  @\n@[<v>%a@]" Kdo.Wat.Module.pp wat_module);

  (* Compiling to Wasm. *)
  Logs.info (fun m -> m "Compiling to Wasm...");
  let* wasm_module = Kdo.Compile.Wat.until_wasm ~unsafe:false wat_module in
  Logs.debug (fun m ->
      m "Compiled module is:  @\n@[<v>%a@]" Kdo.Wasm.Module.pp wasm_module);

  (* Validation step. *)
  Logs.info (fun m -> m "Validating...");
  let* () = Kdo.Validate.Wasm.modul wasm_module in

  (* Linking. *)
  Logs.info (fun m -> m "Linking...");
  let link_state : Kdo.Symbolic.Extern_func.extern_func Kdo.Link.State.t =
    Kdo.Link.State.empty ()
  in
  let link_state =
    Kdo.Link.Extern.modul Symbolic_ono_module.m link_state ~name:"ono"
  in
  let name = Some (Fpath.to_string source_file) in
  let* linked_module, link_state =
    Kdo.Link.Wasm.modul link_state ~name wasm_module
  in

  (* Interpreting. *)
  Logs.info (fun m -> m "Interpreting...");
  (*
  on a 2 mode :
  - le mode standard
  - le mode generation
  *)
  let generation_output =
    if is_game_of_life_generator source_file then
      Some (prepare_generation_output source_file)
    else None
  in
  Fun.protect
    ~finally:(fun () -> Option.iter cleanup_generation_output generation_output)
    (fun () ->
      (* en mode generation `Found_bug` correspond a une solution  *)
      let no_stop_at_failure = Option.is_none generation_output in
      let workspace =
        match generation_output with
        | Some { workspace; _ } -> workspace
        | None -> Fpath.v "."
      in
      let model_out_file =
        Option.map (fun { model_base; _ } -> model_base) generation_output
      in
      let result =
        Interpret.modul link_state linked_module
        |> Kdo.Symbolic.Driver.handle_result
             ~exploration_strategy:
               Kdo.Symbolic.Parameters.Exploration_strategy.FIFO ~workers:4
             ~no_stop_at_failure ~no_value:false
             ~no_assert_failure_expression_printing:false
             ~deterministic_result_order:false
             ~fail_mode:Kdo.Symbolic.Parameters.Both ~workspace
             ~solver:Smtml.Solver_type.Z3_solver
             ~model_format:Kdo.Symbolic.Model.Scfg ~model_out_file
             ~with_breadcrumbs:true ~run_time:None
      in
      match (generation_output, result) with
      (* mode standerd *)
      | None, Ok () -> Ok ()
      | None, Error e ->
          Fmt.error_msg "owi error: %s" (Owi.Result.err_to_string e)
      (* mode generation: où si on a une érreur c'est qu'on a trouvé une configuration . *)
      | Some { model_file; output_file; _ }, Error (`Found_bug _) ->
          let* () = Gol_config.write_generated_file ~model_file ~output_file in
          Logs.app (fun m -> m "Generated %a" Fpath.pp output_file);
          Ok ()
      | Some _, Ok () ->
          Fmt.error_msg "no satisfying configuration found for %a" Fpath.pp
            source_file
      | Some _, Error e ->
          Fmt.error_msg "owi error: %s" (Owi.Result.err_to_string e))
