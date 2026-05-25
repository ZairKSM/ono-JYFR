(** État partagé pour l'affichage et les paramètres d'exécution concrets. *)

(** Limite optionnelle sur le nombre d'étapes simulées. *)
val steps_limit : int option ref

(** Nombre optionnel de générations à afficher en fin de simulation. *)
val show_latest_number : int option ref

(** Empile une dimension prédéfinie pour les futurs appels à [read_int]. *)
val push : int -> unit

(** Dépile la prochaine dimension prédéfinie, ou [0] s'il n'y en a pas. *)
val pop : unit -> int
