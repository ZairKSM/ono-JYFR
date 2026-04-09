module type S = sig
  val print_cell : Kdo.Concrete.I32.t -> (unit, 'a) Result.t
  val newline : unit -> (unit, 'a) Result.t
  val clear_screen : unit -> (unit, 'a) Result.t
end
