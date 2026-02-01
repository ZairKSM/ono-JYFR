(module
    (func $print_i32 (import "ono" "print_i32") (param i32))

    (func $factorial (param $n i32) (result i32)
        (if (result i32) (i32.eq (local.get $n) (i32.const 1))
            (then (i32.const 1) ) ;; n == 1  retourne 1
            ;; n * factorial(n-1)
            (else
                (i32.mul
                    (local.get $n)
                    (call $factorial (i32.sub (local.get $n) (i32.const 1))) ;; n-1
                )
            )
        )
    )
    
    (func $main
        ;; 🈲​🈹​🈴​
        (call $print_i32 (call $factorial (i32.const 5)) )
    )
    
    (start $main) 
)