Check that branching works:
  $ ono symbolic branching_false.wat -vv
  ono: [INFO] Parsing file branching_false.wat...
  ono: [DEBUG] Parsed module is:  
               (module
                 (import "ono" "i32_symbol" (func $i32_symbol  (result i32)))
                 (import "ono" "print_i32" (func $print_i32  (param i32)))
                 (func $main (local $n i32)
                   call $i32_symbol
                   local.tee $n
                   i32.const 42
                   i32.lt_s
                   (if
                     (then
                       return
                     )
                     (else
                       unreachable
                     )
                   )
                 )
                 (start $main)
               )
  ono: [INFO] Compiling to Wasm...
  ono: [DEBUG] Compiled module is:  
               (module
                 (import "ono" "i32_symbol" (func $i32_symbol  (result i32)))
                 (import "ono" "print_i32" (func $print_i32  (param i32)))
                 (type (func (result i32)))
                 (type (func (param i32)))
                 (type (func))
                 (func $main (local $n i32)
                   call 0
                   local.tee 0
                   i32.const 42
                   i32.lt_s
                   (if
                     (then
                       return
                     )
                     (else
                       unreachable
                     )
                   )
                 )
                 (start 2)
               )
  ono: [INFO] Validating...
  ono: [INFO] Linking...
  ono: [INFO] Interpreting...
  ono: [ERROR] Trap: unreachable
  model {
    symbol symbol_0 i32 1073741824
  }
  breadcrumbs 0
  
  ono: [ERROR] owi error: Reached problem!
  [123]
  $ ono symbolic branching_true.wat -vv
  ono: [INFO] Parsing file branching_true.wat...
  ono: [DEBUG] Parsed module is:  
               (module
                 (import "ono" "i32_symbol" (func $i32_symbol  (result i32)))
                 (import "ono" "print_i32" (func $print_i32  (param i32)))
                 (func $main (local $n i32)
                   call $i32_symbol
                   local.tee $n
                   i32.const 42
                   i32.lt_s
                   (if
                     (then
                       unreachable
                     )
                     (else
                       return
                     )
                   )
                 )
                 (start $main)
               )
  ono: [INFO] Compiling to Wasm...
  ono: [DEBUG] Compiled module is:  
               (module
                 (import "ono" "i32_symbol" (func $i32_symbol  (result i32)))
                 (import "ono" "print_i32" (func $print_i32  (param i32)))
                 (type (func (result i32)))
                 (type (func (param i32)))
                 (type (func))
                 (func $main (local $n i32)
                   call 0
                   local.tee 0
                   i32.const 42
                   i32.lt_s
                   (if
                     (then
                       unreachable
                     )
                     (else
                       return
                     )
                   )
                 )
                 (start 2)
               )
  ono: [INFO] Validating...
  ono: [INFO] Linking...
  ono: [INFO] Interpreting...
  ono: [ERROR] Trap: unreachable
  model {
    symbol symbol_0 i32 0
  }
  breadcrumbs 1
  
  ono: [ERROR] owi error: Reached problem!
  [123]
