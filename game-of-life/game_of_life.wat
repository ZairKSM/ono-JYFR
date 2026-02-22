(module 
  (func $print_i32 (import "ono" "print_i32") (param i32))
  (func $sleep (import "ono" "sleep") (param i32))
  (func $print_cell (import "ono" "print_cell") (param i32))
  (func $newline (import "ono" "newline"))
  (func $clear_screen (import "ono" "clear_screen"))
  (func $read_int (import "ono" "read_int") (result i32))

  (global $w (mut i32) (i32.const 42)) ;; width  
  (global $h (mut i32) (i32.const 42)) ;; height 
  (global $turn (mut i32) (i32.const 0))

  (global $total_len (mut i32) (i32.const 1764)) ;; nombre total de cell


  (memory 1) ;; 1 page = 64 Ko, 


  (func $alternate 
        (if (i32.eq (global.get $total_len) (global.get $turn) )
        (then (global.set $turn (i32.const 0)))
        (else (global.set $turn (global.get $total_len)))
        )
    )
            

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
      (then (i32.load8_u (i32.add (call $to_linear (local.get $row) (local.get $col)) (global.get $turn))))
      (else (i32.const 0))
    )

  )

  ;; Écrit dans la cellule (row, col). Ne fait rien si hors bornes
  (func $set_cell (param $row i32) (param $col i32) (param $val i32)
    (if (call $is_valid (local.get $row) (local.get $col)) (then
      (i32.store8
        (i32.add (i32.sub (global.get $total_len) (global.get $turn))
        (call $to_linear (local.get $row) (local.get $col)))
        (local.get $val)
      )
    ))
  )
  ;; Calculate the number of alive neighbours
  (func $nb_neighbours (param $row i32) (param $col i32) (result i32)
    (local $count i32) ;; counter of alive neighbour 
    (local $dr i32) ;; delta for rows 
    (local $dc i32) ;; delta for colums 
    (local.set $count (i32.const 0))
    (local.set $dr (i32.const -1))
    (loop $outer
      (local.set $dc (i32.const -1))
      (loop $inner
        ;; don't check yourself
        (if (i32.or 
                (i32.ne (local.get $dr) (i32.const 0)) 
                (i32.ne (local.get $dc) (i32.const 0))
            )
        (then
            ;; Check neighbour at (row + dr, col + dc)
            (local.set $count
              (i32.add
                (local.get $count)
                (call $get_cell
                  (i32.add (local.get $row) (local.get $dr))
                  (i32.add (local.get $col) (local.get $dc))
                )
              )
            )
        )
        )
        
        (local.set $dc (i32.add (local.get $dc) (i32.const 1)))
        ;; If dc <= 1, continue inner loop
        (br_if $inner (i32.le_s (local.get $dc) (i32.const 1)))
      )
      (local.set $dr (i32.add (local.get $dr) (i32.const 1)))
      ;; If dr <= 1, continue outer loop
      (br_if $outer (i32.le_s (local.get $dr) (i32.const 1)))
    )
    
    (local.get $count)
  )
    
  ;; Calculate the next state of a cell based on current and neighbours 
  (func $next_state (param $row i32) (param $col i32) (result i32)
    (local $nb i32)
    (local $actual_state i32)
    (local $new i32)
    (local.set $nb (call $nb_neighbours (local.get $row) (local.get $col)))
    (local.set $actual_state (call $get_cell (local.get $row) (local.get $col)))
    ;; new_state = (neigh = 3) or (actual = 1 and neighbours = 2)
    (if (i32.or 
          (i32.eq (local.get $nb) (i32.const 3))
          (i32.and 
            (i32.eq (local.get $actual_state) (i32.const 1))
            (i32.eq (local.get $nb) (i32.const 2))
          )
        )
      (then (local.set $new (i32.const 1)))
      (else (local.set $new (i32.const 0)))
    )

    (local.get $new)
  )

  ;;Function that iterate and create the new state of the full board
  (func $iteration 
    (local $i i32)
    (local $j i32)
    (local.set $i (i32.const 0))
    (loop $outer
        (local.set $j (i32.const 0))

        (loop $inner
          (call $set_cell (local.get $i) (local.get $j) 
              (call $next_state (local.get $i) (local.get $j))
          )
          
          (local.set $j (i32.add (local.get $j) (i32.const 1)))
          (br_if $inner (i32.lt_u (local.get $j) (global.get $w)))
        )
        
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br_if $outer (i32.lt_u (local.get $i) (global.get $h)))
    )
  )
  ;; Fonction d'affichage du plateau de jeu
  (func $display_board
    (local $i i32)
    (local $j i32)
    (local.set $i (i32.const 0))
    (loop $outer
      (local.set $j (i32.const 0))
      (loop $inner
        (call $print_cell (call $get_cell (local.get $i) (local.get $j)))
        (local.set $j (i32.add (local.get $j) (i32.const 1)))
        (br_if $inner (i32.lt_u (local.get $j) (global.get $w)))
      )
      (call $newline)
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $outer (i32.lt_u (local.get $i) (global.get $h)))
    )

    (call $clear_screen)
  )

  (func $main_loop
    ;; Glider
    (call $set_cell (i32.const 1) (i32.const 2) (i32.const 1))
    (call $set_cell (i32.const 2) (i32.const 3) (i32.const 1))
    (call $set_cell (i32.const 3) (i32.const 1) (i32.const 1))
    (call $set_cell (i32.const 3) (i32.const 2) (i32.const 1))
    (call $set_cell (i32.const 3) (i32.const 3) (i32.const 1))
    
    (call $alternate)

    (loop $game
      (call $display_board)
      (call $iteration)
      (call $alternate)
      (call $sleep (i32.const 200)) 
      (br $game)
    )
  )

  (func $main 
    ;; read w and h from input
    ;; (global.set $w (call $read_int))
    ;; (global.set $h (call $read_int))
    (call $main_loop)
  )

  (start $main)
)
