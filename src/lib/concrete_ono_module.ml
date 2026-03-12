type extern_func = Kdo.Concrete.Extern_func.extern_func

let config : Gol_config.t ref = ref Gol_config.default_glider

let set_config c = config := c

(* buffer pour l'affichage *)
let text_buffer = Buffer.create Game_constant.GameConstant.taille_buffer

let print_i32 (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I32.pp n);
  Ok ()

(* j'ai juste copier coller et ajouter dans "let functions = ...." *)
let print_i64 (n : Kdo.Concrete.I64.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I64.pp n);
  Ok ()

let random_i32 () : (Kdo.Concrete.I32.t, _) Result.t =
  Ok (Kdo.Concrete.I32.of_int32 (Random.int32 Int32.max_int))

(* atendre ms milliseconde *)
let sleep (ms : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  let ms = Kdo.Concrete.I32.to_int ms in
  let seconds = float_of_int ms /. 1000.0 in
  Unix.sleepf seconds;
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
*)
let clear_screen () : (unit, _) Result.t =
  let contents = Buffer.contents text_buffer in
  Format.printf "\027[2J\027[H%s%!" contents;
  Buffer.clear text_buffer;
  Ok ()

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
      ("is_alive_init", Extern_func (i32 ^-> i32 ^->. i32, is_alive_init));
    ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Concrete.Extern_func.extern_type;
  }
