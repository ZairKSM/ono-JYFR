(module
  (func $print_i32 (import "ono" "print_i32") (param i32))
  (func $get_steps (import "ono" "get_steps") (result i32))

  ;; test de la fonction de steps
  (func $main
    (call $print_i32 (call $get_steps))
  )

  (start $main)
)
