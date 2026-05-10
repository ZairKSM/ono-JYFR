type extern_func = Kdo.Concrete.Extern_func.extern_func

let config : Gol_config.t ref = ref Gol_config.default_glider
let set_config c = config := c

let set_steps_limit (steps : int option) : unit =
  Display_buffer.steps_limit := steps

let set_show_latest_number (num : int option) : unit =
  Display_buffer.show_latest_number := num

open Display_buffer

let view : (module Interface.S) ref = ref (module Textual : Interface.S)

let set_render_mode (enabled : bool) : unit =
  view :=
    if enabled then (module Graphics : Interface.S)
    else (module Textual : Interface.S)

let print_i32 (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I32.pp n);
  Ok ()

(* j'ai juste copier coller et ajouter dans "let functions = ...." *)
let print_i64 (n : Kdo.Concrete.I64.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I64.pp n);
  Ok ()

let random_i32 () : (Kdo.Concrete.I32.t, _) Result.t =
  Ok (Kdo.Concrete.I32.of_int32 (Random.int32 Int32.max_int))

let get_steps () : (Kdo.Concrete.I32.t, _) Result.t =
  let steps = match !steps_limit with Some n -> n | None -> -1 in
  Ok (Kdo.Concrete.I32.of_int32 (Int32.of_int steps))

let get_show_latest () : (Kdo.Concrete.I32.t, _) Result.t =
  let show_latest = match !show_latest_number with Some n -> n | None -> -1 in
  Ok (Kdo.Concrete.I32.of_int32 (Int32.of_int show_latest))

(* atendre ms milliseconde *)
let sleep (ms : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  let ms = Kdo.Concrete.I32.to_int ms in
  let seconds = float_of_int ms /. 1000.0 in
  (* si on doit montrer les x derniers on fait pas de sleep car faignon*)
  if !show_latest_number == None then Unix.sleepf seconds;
  Ok ()

(* Affiche une cellule vivante ou morte
    si cellule <> 0 vivante
    sinon morte 🧟​
*)
let print_cell (cell : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  let module M = (val !view) in
  M.print_cell cell

let newline () : (unit, _) Result.t =
  let module M = (val !view) in
  M.newline ()

(*
  dans le Readme : 
  "afficher le contenu du buffer à l'écran puis vider celui-ci en prévision du prochain affichage"
  En mode show_latest, affichage plain sans séquences ANSI (pour les cram tests).
*)
let clear_screen () : (unit, _) Result.t =
  let module M = (val !view) in
  M.clear_screen ()

(* valeurs pré-remplies pour la hauteur et la largeur (-w, -h) *)
let preset_values : int Queue.t = Queue.create ()
let push_preset v = Queue.push v preset_values

let read_int () : (Kdo.Concrete.I32.t, _) Result.t =
  let n =
    if not (Queue.is_empty preset_values) then Queue.pop preset_values
    else begin
      Format.printf "Enter an integer : %!";
      Scanf.scanf " %d" Fun.id
    end
  in
  Display_buffer.push n;

  Ok (Kdo.Concrete.I32.of_int32 (Int32.of_int n))

let get_generation_width () : (Kdo.Concrete.I32.t, _) Result.t =
  Ok (Kdo.Concrete.I32.of_int32 (Int32.of_int Generation_config.width))

let get_generation_height () : (Kdo.Concrete.I32.t, _) Result.t =
  Ok (Kdo.Concrete.I32.of_int32 (Int32.of_int Generation_config.height))

(* Renvoie 1 si la cellule (row, col) est vivante dans la config initiale, 0 sinon *)
let is_alive_init (row : Kdo.Concrete.I32.t) (col : Kdo.Concrete.I32.t) :
    (Kdo.Concrete.I32.t, _) Result.t =
  let r = Kdo.Concrete.I32.to_int row in
  let c = Kdo.Concrete.I32.to_int col in
  let alive =
    List.exists (fun (pr, pc) -> pr = r && pc = c) !config.alive_cells
  in
  Ok (Kdo.Concrete.I32.of_int32 (if alive then 1l else 0l))

let m =
  let open Kdo.Concrete.Extern_func in
  let open Kdo.Concrete.Extern_func.Syntax in
  let functions =
    [
      ("print_i32", Extern_func (i32 ^->. unit, print_i32));
      ("print_i64", Extern_func (i64 ^->. unit, print_i64));
      ("random_i32", Extern_func (unit ^->. i32, random_i32));
      ("sleep", Extern_func (i32 ^->. unit, sleep));
      ("print_cell", Extern_func (i32 ^->. unit, print_cell));
      ("newline", Extern_func (unit ^->. unit, newline));
      ("clear_screen", Extern_func (unit ^->. unit, clear_screen));
      ("get_steps", Extern_func (unit ^->. i32, get_steps));
      ("get_show_latest", Extern_func (unit ^->. i32, get_show_latest));
      ("is_alive_init", Extern_func (i32 ^-> i32 ^->. i32, is_alive_init));
      ("read_int", Extern_func (unit ^->. i32, read_int));
      ("get_generation_width", Extern_func (unit ^->. i32, get_generation_width));
      ( "get_generation_height",
        Extern_func (unit ^->. i32, get_generation_height) );
    ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Concrete.Extern_func.extern_type;
  }
