(module
  (func $i32_symbol (import "ono" "i32_symbol") (result i32))

  (memory 1)

  (global $w    i32 (i32.const 4))
  (global $h    i32 (i32.const 4))
  (global $SIZE i32 (i32.const 16))

  ;; Buffer courant : 0 ou SIZE.
  (global $turn (mut i32) (i32.const 0))



;; vivante ou morte

  (func $sym_bit (result i32)
    (i32.and (call $i32_symbol) (i32.const 1))
  )

;; copie de game_of_life (utile à l'avenir ??)
  (func $alternate
    (if (i32.eq (global.get $turn) (i32.const 0))
      (then (global.set $turn (global.get $SIZE)))
      (else (global.set $turn (i32.const 0))))
  )

  (func $to_linear (param $row i32) (param $col i32) (result i32)
    (i32.add (i32.mul (local.get $row) (global.get $w)) (local.get $col))
  )

  (func $is_valid (param $row i32) (param $col i32) (result i32)
    (i32.and
      (i32.lt_u (local.get $row) (global.get $h))
      (i32.lt_u (local.get $col) (global.get $w)))
  )

  (func $get_cell (param $row i32) (param $col i32) (result i32)
    (if (result i32) (call $is_valid (local.get $row) (local.get $col))
      (then
        (i32.load8_u
          (i32.add (call $to_linear (local.get $row) (local.get $col))
                   (global.get $turn))))
      (else (i32.const 0)))
  )

  (func $set_cell (param $row i32) (param $col i32) (param $val i32)
    (if (call $is_valid (local.get $row) (local.get $col))
      (then
        (i32.store8
          (i32.add (i32.sub (global.get $SIZE) (global.get $turn))
                   (call $to_linear (local.get $row) (local.get $col)))
          (local.get $val))))
  )

  (func $nb_neighbours (param $row i32) (param $col i32) (result i32)
    (local $count i32) (local $dr i32) (local $dc i32)
    (local.set $count (i32.const 0))
    (local.set $dr (i32.const -1))
    (loop $outer
      (local.set $dc (i32.const -1))
      (loop $inner
        (if (i32.or
              (i32.ne (local.get $dr) (i32.const 0))
              (i32.ne (local.get $dc) (i32.const 0)))
          (then
            (local.set $count
              (i32.add (local.get $count)
                (call $get_cell
                  (i32.add (local.get $row) (local.get $dr))
                  (i32.add (local.get $col) (local.get $dc)))))))
        (local.set $dc (i32.add (local.get $dc) (i32.const 1)))
        (br_if $inner (i32.le_s (local.get $dc) (i32.const 1))))
      (local.set $dr (i32.add (local.get $dr) (i32.const 1)))
      (br_if $outer (i32.le_s (local.get $dr) (i32.const 1))))
    (local.get $count)
  )

  (func $next_state (param $row i32) (param $col i32) (result i32)
    (local $nb i32) (local $actual i32)
    (local.set $nb (call $nb_neighbours (local.get $row) (local.get $col)))
    (local.set $actual (call $get_cell (local.get $row) (local.get $col)))
    (if (result i32)
      (i32.or
        (i32.eq (local.get $nb) (i32.const 3))
        (i32.and
          (i32.eq (local.get $actual) (i32.const 1))
          (i32.eq (local.get $nb) (i32.const 2))))
      (then (i32.const 1))
      (else (i32.const 0)))
  )

  (func $iteration
    (local $i i32) (local $j i32)
    (local.set $i (i32.const 0))
    (loop $outer
      (local.set $j (i32.const 0))
      (loop $inner
        (call $set_cell (local.get $i) (local.get $j)
          (call $next_state (local.get $i) (local.get $j)))
        (local.set $j (i32.add (local.get $j) (i32.const 1)))
        (br_if $inner (i32.lt_u (local.get $j) (global.get $w))))
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $outer (i32.lt_u (local.get $i) (global.get $h))))
    (call $alternate)
  )

;; grille symbolique sans contrainte
  (func $init_symbolic_grid
    (local $i i32)
    (local.set $i (i32.const 0))
    (loop $init
      (i32.store8 (local.get $i) (call $sym_bit))
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $init (i32.lt_u (local.get $i) (global.get $SIZE))))
  )



;; fonction qui selectionne la contrainte --option contrainte
;; TODO:
  (func $check (result i32)
    (i32.const 0)
  )

  (func $main
    (call $init_symbolic_grid)
    (if (i32.eqz (call $check)) (then (return)))
    unreachable
  )

  (start $main)
)
