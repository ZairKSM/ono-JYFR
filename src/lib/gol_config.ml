type t = {
  name : string option;
  offset_row : int;
  offset_col : int;
  alive_cells : (int * int) list;
}

let default_glider =
  {
    name = Some "Glider";
    offset_row = 1;
    offset_col = 1;
    alive_cells = [ (1, 2); (2, 3); (3, 1); (3, 2); (3, 3) ];
  }

let starts_with ~prefix s =
  let plen = String.length prefix in
  String.length s >= plen && String.sub s 0 plen = prefix

let after_prefix ~prefix s =
  let plen = String.length prefix in
  String.trim (String.sub s plen (String.length s - plen))

let read_file path =
  try
    let ic = open_in_bin (Fpath.to_string path) in
    Fun.protect
      ~finally:(fun () -> close_in ic)
      (fun () ->
        let buf = Buffer.create 4096 in
        (try
           while true do
             Buffer.add_char buf (input_char ic)
           done
         with End_of_file -> ());
        Ok (Buffer.contents buf))
  with Sys_error msg -> Error (`Msg msg)

let parse_from_string content =
  let lines = String.split_on_char '\n' content in
  let name = ref None in
  let offset_row = ref 0 in
  let offset_col = ref 0 in
  let pattern_lines = ref [] in
  let in_pattern = ref false in
  List.iter
    (fun raw_line ->
      let line = String.trim raw_line in
      if String.length line = 0 then ()
      else if line.[0] = '#' then ()
      else if not !in_pattern then
        if starts_with ~prefix:"name " line then
          name := Some (after_prefix ~prefix:"name " line)
        else if starts_with ~prefix:"offset " line then begin
          let rest = after_prefix ~prefix:"offset " line in
          let parts =
            String.split_on_char ' ' rest
            |> List.filter (fun s -> String.length s > 0)
          in
          match parts with
          | [ r; c ] -> (
              try
                offset_row := int_of_string r;
                offset_col := int_of_string c
              with Failure _ -> ())
          | _ -> ()
        end
        else begin
          in_pattern := true;
          pattern_lines := [ line ]
        end
      else pattern_lines := line :: !pattern_lines)
    lines;
  let pattern_lines = List.rev !pattern_lines in
  let alive_cells = ref [] in
  List.iteri
    (fun row line ->
      String.iteri
        (fun col c ->
          if c = 'O' then
            alive_cells :=
              (!offset_row + row, !offset_col + col) :: !alive_cells)
        line)
    pattern_lines;
  {
    name = !name;
    offset_row = !offset_row;
    offset_col = !offset_col;
    alive_cells = List.rev !alive_cells;
  }

let parse_file path =
  let open Syntax in
  let+ content = read_file path in
  parse_from_string content

(* convertie une configuration en .gol*)
let to_string ~dimensions:(rows, cols)
    { name; offset_row; offset_col; alive_cells } =
  let buf = Buffer.create 256 in
  (match name with
  | Some name -> Buffer.add_string buf ("name " ^ name ^ "\n")
  | None -> ());
  Buffer.add_string buf (Printf.sprintf "offset %d %d\n" offset_row offset_col);
  Buffer.add_char buf '\n';
  let relative_cells =
    List.map
      (fun (row, col) -> (row - offset_row, col - offset_col))
      alive_cells
  in
  let rows = max 0 rows in
  let cols = max 0 cols in
  if rows > 0 && cols > 0 then begin
    let grid = Array.make_matrix rows cols '.' in
    List.iter
      (fun (row, col) ->
        if row >= 0 && row < rows && col >= 0 && col < cols then
          grid.(row).(col) <- 'O')
      relative_cells;
    Array.iter
      (fun line ->
        Array.iter (Buffer.add_char buf) line;
        Buffer.add_char buf '\n')
      grid
  end;
  Buffer.contents buf

(* écrit le .gol *)
let write_file ~dimensions path config =
  let content = to_string ~dimensions config in
  try
    let oc = open_out_bin (Fpath.to_string path) in
    Fun.protect
      ~finally:(fun () -> close_out oc)
      (fun () -> output_string oc content);
    Ok ()
  with Sys_error msg -> Error (`Msg msg)

(* lire la réponse du solveur  *)
let parse_symbolic_cells content =
  let lines = String.split_on_char '\n' content in
  let cells = ref [] in
  List.iter
    (fun raw_line ->
      let line = String.trim raw_line in
      if starts_with ~prefix:"symbol symbol_" line then
        Scanf.sscanf_opt line "symbol symbol_%d i32 %Ld" (fun index value ->
            cells := (index, value) :: !cells)
        |> ignore)
    lines;
  let cells = List.sort compare (List.rev !cells) in
  if cells = [] then Error (`Msg "no symbolic cell found in model")
  else Ok cells

(* transforme en vraies coordonnées de cellules vivantes *)
let alive_cells_of_symbolic_model ~width ~height cells =
  let total = width * height in
  List.filter_map
    (fun (index, value) ->
      if index < 0 || index >= total then None
      else if Int64.logand value 1L = 0L then None
      else Some (index / width, index mod width))
    cells

(* transforme la réponse en un fichier .gol *)
let write_generated_file ~model_file ~output_file =
  let open Syntax in
  let* model = read_file model_file in
  let* cells = parse_symbolic_cells model in
  let config =
    {
      name = Some "Generated";
      offset_row = 0;
      offset_col = 0;
      alive_cells =
        alive_cells_of_symbolic_model ~width:!Generation_config.width
          ~height:!Generation_config.height cells;
    }
  in
  write_file
    ~dimensions:(!Generation_config.height, !Generation_config.width)
    output_file config
