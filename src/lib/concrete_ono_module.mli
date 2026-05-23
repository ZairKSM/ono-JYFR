(** Fonctions hôtes exposées au mode concret. *)

(** [set_config config] remplace la configuration initiale utilisée par
    [is_alive_init]. *)
val set_config : Gol_config.t -> unit

(** Configure la limite d'étapes utilisée par le moteur concret. *)
val set_steps_limit : int option -> unit

(** Configure le nombre de générations à conserver à l'affichage. *)
val set_show_latest_number : int option -> unit

(** Active ou désactive le rendu graphique. *)
val set_render_mode : bool -> unit

(** Pré-charge une valeur qui sera consommée par le prochain [read_int]. *)
val push_preset : int -> unit

(** Module d'externes [ono] utilisé lors du linkage concret. *)
val m : Kdo.Concrete.Extern_func.extern_func Kdo.Extern.Module.t
