(** Configuration de taille utilisée pour la génération symbolique. *)

(** Largeur de la grille générée. *)
val width : int ref

(** Hauteur de la grille générée. *)
val height : int ref

(** [set ?width ?height ()] met à jour les dimensions de génération lorsque
    des valeurs sont fournies. *)
val set : ?width:int -> ?height:int -> unit -> unit
