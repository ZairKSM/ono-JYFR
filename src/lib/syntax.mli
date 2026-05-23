(** Opérateurs pratiques pour chaîner des [result]. *)

(** [Result.bind]. *)
val ( let* ) : ('a, 'e) result -> ('a -> ('b, 'e) result) -> ('b, 'e) result

(** [Result.map]. *)
val ( let+ ) : ('a, 'e) result -> ('a -> 'b) -> ('b, 'e) result
