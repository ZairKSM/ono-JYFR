(* taille pour la grille utilisee par generate.wat *)
let width = ref 6
let height = ref 7

let set ?width:new_width ?height:new_height () =
  Option.iter (fun value -> width := value) new_width;
  Option.iter (fun value -> height := value) new_height
