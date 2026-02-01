(module
    ;; on peut pas importer apres avoir defini une fonction pk je sais pas 
    (func $print_i64 (import "ono" "print_i64") (param i64))

    ;; what 9 + 10 ??
    ;; 21 
    ;; you stupid

    (func $square_i64 (param $x i64) (result i64) 
      (i64.mul (local.get $x) (local.get $x))
    )

    (func $main
      i64.const 50000
      call $square_i64
      call $print_i64
    )
    (start $main)
)