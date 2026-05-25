(** Interface commune aux rendus du jeu de la vie. *)

module type S = sig
  (** Affiche une cellule vivante ou morte. *)
  val print_cell : Kdo.Concrete.I32.t -> (unit, 'a) Result.t

  (** Passe à la ligne dans la représentation courante. *)
  val newline : unit -> (unit, 'a) Result.t

  (** Vide/affiche le buffer courant pour préparer l'image suivante. *)
  val clear_screen : unit -> (unit, 'a) Result.t
end
