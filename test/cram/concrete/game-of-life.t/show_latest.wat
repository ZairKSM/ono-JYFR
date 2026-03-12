(module
  (func $print_i32 (import "ono" "print_i32") (param i32))
  (func $get_show_latest (import "ono" "get_show_latest") (result i32))

  ;; test de la fonction get_show_latest
  (func $main
    (call $print_i32 (call $get_show_latest))
  )

  (start $main)
)
