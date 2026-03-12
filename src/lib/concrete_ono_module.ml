type extern_func = Kdo.Concrete.Extern_func.extern_func

(* buffer pour l'affichage *)
let text_buffer = Buffer.create Game_constant.GameConstant.taille_buffer


let steps_limit : int option ref = ref None

let show_latest_number : int option ref = ref None

let set_steps_limit (steps : int option) : unit = steps_limit := steps

let set_show_latest_number (num : int option) : unit = show_latest_number := num

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
  let alive = Kdo.Concrete.I32.to_int cell <> 0 in
  Buffer.add_string text_buffer
    (if alive then Game_constant.GameConstant.case_en_vie
     else Game_constant.GameConstant.case_morte);
  Ok ()

let newline () : (unit, _) Result.t =
  Buffer.add_char text_buffer '\n';
  Ok ()

(*
  dans le Readme : 
  "afficher le contenu du buffer à l'écran puis vider celui-ci en prévision du prochain affichage"
  En mode show_latest, affichage plain sans séquences ANSI (pour les cram tests).
*)
let clear_screen () : (unit, _) Result.t =
  let contents = Buffer.contents text_buffer in
  Format.printf "\027[2J\027[H%s%!" contents;
  if !show_latest_number == None then
    (Buffer.clear text_buffer;)
  else 
    Buffer.add_char text_buffer '\n';
  Ok ()

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
    ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Concrete.Extern_func.extern_type;
  }
