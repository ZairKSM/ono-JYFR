(** Fonctions hôtes exposées au mode symbolique. *)

(** Spécification d'une contrainte activée en ligne de commande. *)
type constraint_spec = {
  id : int;
  arg : int option;
}

(** Identifiants de contraintes pris en charge par le générateur. *)
val supported_constraints : int list

(** Enregistre la liste des contraintes actives pour la prochaine exécution. *)
val set_constraints : constraint_spec list -> unit

(** Module d'externes [ono] utilisé lors du linkage symbolique. *)
val m : Kdo.Symbolic.Extern_func.extern_func Kdo.Extern.Module.t
