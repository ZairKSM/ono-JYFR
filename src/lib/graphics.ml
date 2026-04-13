let cell_size = 10
let current_col = ref 0
let current_row = ref 0
let frame_started = ref false
let window_initialized = ref false
let light_gray = Raylib.Color.create 224 224 224 255

let ensure_window ~width ~height : unit =
  if not !window_initialized then begin
    Raylib.init_window width height "Jeu de la vie";
    Raylib.set_target_fps 60;
    window_initialized := true
  end

let close_window_if_needed () : unit =
  if !window_initialized then begin
    Raylib.close_window ();
    window_initialized := false
  end

let () = at_exit close_window_if_needed

let start_frame () =
  if not !frame_started then begin
    let width = Display_buffer.pop () in
    let height = Display_buffer.pop () in
    ensure_window ~width:(width * cell_size) ~height:(height * cell_size);
    if not (Raylib.window_should_close ()) then begin
      Raylib.begin_drawing ();
      Raylib.clear_background light_gray;
      frame_started := true
    end
  end

let print_cell (cell : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  start_frame ();
  let alive = Kdo.Concrete.I32.to_int cell <> 0 in
  let x = !current_col * cell_size in
  let y = !current_row * cell_size in
  let color = if alive then Raylib.Color.blue else Raylib.Color.white in
  let cell_size = cell_size - Bool.to_int (not alive) in
  Raylib.draw_rectangle x y cell_size cell_size color;
  current_col := !current_col + 1;
  Ok ()

let newline () : (unit, _) Result.t =
  current_row := !current_row + 1;
  current_col := 0;
  Ok ()

let clear_screen () : (unit, _) Result.t =
  if !frame_started then begin
    Raylib.end_drawing ();
    frame_started := false
  end
  else if !window_initialized && Raylib.window_should_close () then begin
    close_window_if_needed ();
    exit 0
  end;

  current_col := 0;
  current_row := 0;

  Ok ()
