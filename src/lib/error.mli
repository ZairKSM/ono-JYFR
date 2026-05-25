(* Error infrastructure. *)

(** Type d'erreurs remontées par la bibliothèque. *)
type t =
  [ `Msg of string
  | `Call_stack_exhausted
  | `Conversion_to_integer
  | `Integer_divide_by_zero
  | `Integer_overflow
  | `Out_of_bounds_memory_access
  | `Unreachable ]
