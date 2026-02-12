(module 
  (func $print_i32 (import "ono" "print_i32") (param i32))
  (func $sleep (import "ono" "sleep") (param i32))
  (func $print_cell (import "ono" "print_cell") (param i32))
  (func $newline (import "ono" "newline"))
  (func $clear_screen (import "ono" "clear_screen"))

  (global $w i32 (i32.const 42)) ;; width  (colonnes)
  (global $h i32 (i32.const 42)) ;; height (lignes)

  (memory 1) ;; 1 page = 64 Ko, 

  ;; Convertit (row, col) en indice linéaire : row * w + col (car la mémoire en réalité est linéaire)
  (func $to_linear (param $row i32) (param $col i32) (result i32)
    (i32.add (i32.mul (local.get $row) (global.get $w)) (local.get $col))
  )

  ;; Vérifie si (row, col) est dans les bornes
  (func $is_valid (param $row i32) (param $col i32) (result i32)
    (i32.and
      (i32.lt_u (local.get $row) (global.get $h))
      (i32.lt_u (local.get $col) (global.get $w))
    )
  )

  ;; Lit la cellule (row, col). Renvoie 0 si hors bornes (= morte)
  (func $get_cell (param $row i32) (param $col i32) (result i32)
    (if (result i32) (call $is_valid (local.get $row) (local.get $col))
      (then (i32.load8_u (call $to_linear (local.get $row) (local.get $col))))
      (else (i32.const 0))
    )
  )


  ;; Écrit dans la cellule (row, col). Ne fait rien si hors bornes
  (func $set_cell (param $row i32) (param $col i32) (param $val i32)
    (if (call $is_valid (local.get $row) (local.get $col)) (then
      (i32.store8
        (call $to_linear (local.get $row) (local.get $col))
        (local.get $val)
      )
    ))
  )


)
