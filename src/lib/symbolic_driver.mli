(** Exécution symbolique d'un module Wasm. *)

(** [run ~source_file ~constraints] exécute [source_file] en mode symbolique.

    Lorsqu'il s'agit du générateur du jeu de la vie, un fichier [*.gol] est
    produit à partir du modèle trouvé. *)
val run :
  source_file:Fpath.t ->
  constraints:Symbolic_ono_module.constraint_spec list ->
  (unit, Owi.Result.err) result
