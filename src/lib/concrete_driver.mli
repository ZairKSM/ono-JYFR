(** Exécution concrète d'un module Wasm. *)

(** [run ~source_file ?config_file ()] exécute [source_file] en mode concret.

    Si [config_file] est fourni, il est chargé comme configuration initiale du
    jeu de la vie. *)
val run :
  source_file:Fpath.t ->
  ?config_file:Fpath.t ->
  unit ->
  (unit, Owi.Result.err) result
