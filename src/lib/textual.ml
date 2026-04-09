open Display_buffer

let text_buffer = Buffer.create GameConstant.taille_buffer

let print_cell (cell : Kdo.Concrete.I32.t) : (unit, _) Result.t =
    let alive = Kdo.Concrete.I32.to_int cell <> 0 in
      Buffer.add_string text_buffer
        (if alive then GameConstant.case_en_vie
         else GameConstant.case_morte);
      Ok ()


let newline () : (unit, _) Result.t =
    Buffer.add_char text_buffer '\n';
    Ok ()


let clear_screen () : (unit, _) Result.t =
  let contents = Buffer.contents text_buffer in
  Format.printf "\027[2J\027[H%s%!" contents;
  if !show_latest_number == None then Buffer.clear text_buffer
  else Buffer.add_char text_buffer '\n';
  Ok ()









