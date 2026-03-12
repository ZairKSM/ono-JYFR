type t =
  { name : string option
  ; offset_row : int
  ; offset_col : int
  ; alive_cells : (int * int) list
  }

let empty = { name = None; offset_row = 0; offset_col = 0; alive_cells = [] }

let default_glider =
  { name = Some "Glider"
  ; offset_row = 1
  ; offset_col = 1
  ; alive_cells = [ (1, 2); (2, 3); (3, 1); (3, 2); (3, 3) ]
  }

let starts_with ~prefix s =
  let plen = String.length prefix in
  String.length s >= plen && String.sub s 0 plen = prefix

let after_prefix ~prefix s =
  let plen = String.length prefix in
  String.trim (String.sub s plen (String.length s - plen))

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
      if String.length line = 0 then 
        ()
      else if line.[0] = '#' then 
        ()
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
            with Failure _ -> () )
          | _ -> ()
        end
        else begin
          in_pattern := true;
          pattern_lines := [ line ]
        end
      else 
        pattern_lines := line :: !pattern_lines )
    lines;
  let pattern_lines = List.rev !pattern_lines in
  let alive_cells = ref [] in
  List.iteri
    (fun row line ->
      String.iteri
        (fun col c ->
          if c = 'O' then
            alive_cells :=
              (!offset_row + row, !offset_col + col) :: !alive_cells )
        line )
    pattern_lines;
  { name = !name
  ; offset_row = !offset_row
  ; offset_col = !offset_col
  ; alive_cells = List.rev !alive_cells
  }

let parse_file path =
  try
    let ic = open_in (Fpath.to_string path) in
    Fun.protect
      ~finally:(fun () -> close_in ic)
      (fun () ->
        let buf = Buffer.create 4096 in
        ( try
            while true do
              Buffer.add_char buf (input_char ic)
            done
          with End_of_file -> () );
        Ok (parse_from_string (Buffer.contents buf)) )
  with Sys_error msg -> Error (`Msg msg)
