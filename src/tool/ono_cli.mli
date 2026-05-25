(** Résultat standard des commandes CLI du projet. *)
type outcome = (unit, [ Ono.Error.t | Cmdliner.Cmd.eval_error ]) Result.t

(** Convertit une erreur Ono en code de sortie Unix. *)
val error_to_exit_code : Ono.Error.t -> int

(** Liste des codes de sortie documentés pour Cmdliner. *)
val exits : Cmdliner.Cmd.Exit.info list

(** Section de documentation des options communes. *)
val sdocs : string

(** Version affichée par l'exécutable. *)
val version : string

(** Initialisation du logging. *)
val setup_log : unit Cmdliner.Term.t

(** Argument positionnel du fichier source. *)
val source_file : Fpath.t Cmdliner.Term.t

(** Graine optionnelle pour les tirages pseudo-aléatoires. *)
val seed : int option Cmdliner.Term.t

(** Nombre d'étapes à simuler en mode concret. *)
val steps : int option Cmdliner.Term.t

(** Nombre de générations finales à afficher. *)
val show_latest : int option Cmdliner.Term.t

(** Largeur optionnelle de la grille. *)
val width : int option Cmdliner.Term.t

(** Hauteur optionnelle de la grille. *)
val height : int option Cmdliner.Term.t

(** Fichier de configuration [*.gol] optionnel. *)
val config_file : Fpath.t option Cmdliner.Term.t

(** Contraintes symboliques activées depuis la ligne de commande. *)
val constraints : Ono.Symbolic_ono_module.constraint_spec list Cmdliner.Term.t

(** Active le rendu graphique en mode concret. *)
val graphics : bool Cmdliner.Term.t
