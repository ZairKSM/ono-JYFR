(** Lecture et écriture du format [*.gol]. *)

(** Configuration d'une grille du jeu de la vie. *)
type t = {
  name : string option;
  offset_row : int;
  offset_col : int;
  alive_cells : (int * int) list;
}

(** Configuration par défaut utilisée en l'absence de fichier fourni. *)
val default_glider : t

(** Lit une configuration [*.gol] depuis un fichier. *)
val parse_file : Fpath.t -> (t, [> `Msg of string ]) result

(** Sérialise une configuration au format [*.gol] en conservant les dimensions fournies. *)
val to_string : dimensions:int * int -> t -> string

(** Écrit une configuration [*.gol] sur disque. *)
val write_file :
  dimensions:int * int -> Fpath.t -> t -> (unit, [> `Msg of string ]) result

(** Convertit un modèle symbolique [*.scfg] en fichier [*.gol]. *)
val write_generated_file :
  model_file:Fpath.t -> output_file:Fpath.t -> (unit, [> `Msg of string ]) result
