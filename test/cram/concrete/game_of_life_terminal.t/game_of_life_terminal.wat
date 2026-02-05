(module
    (func $print_i32 (import "ono" "print_i32") (param i32))
    (func $sleep (import "ono" "sleep") (param i32))
    (func $print_cell (import "ono" "print_cell") (param i32))
    (func $newline (import "ono" "newline"))
    (func $clear_screen (import "ono" "clear_screen"))
    
    
    (func $test_functions
        (call $print_cell (i32.const 1))
        (call $print_cell (i32.const 1))
        (call $print_cell (i32.const 1))
        (call $print_cell (i32.const 1))
        (call $newline)
        (call $clear_screen)
        (call $sleep (i32.const 500))

        (call $print_cell (i32.const 1))
        (call $print_cell (i32.const 1))
        (call $print_cell (i32.const 1))
        (call $print_cell (i32.const 0))
        (call $newline)
        (call $clear_screen)
        (call $sleep (i32.const 500))     

        (call $print_cell (i32.const 1))
        (call $print_cell (i32.const 1))
        (call $print_cell (i32.const 0))
        (call $print_cell (i32.const 0))
        (call $newline)
        (call $clear_screen)
        (call $sleep (i32.const 500))     


        (call $print_cell (i32.const 1))
        (call $print_cell (i32.const 0))
        (call $print_cell (i32.const 0))
        (call $print_cell (i32.const 0))
        (call $newline)
        (call $clear_screen)
        (call $sleep (i32.const 500))  

    )
    
    (func $main (call $test_functions) )
    
    (start $main)
)
