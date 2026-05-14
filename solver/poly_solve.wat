(module
  (import "ono" "i32_symbol" (func $i32_symbol (result i32)))
  (import "ono" "read_int" (func $read_int (result i32)))

  (global $a (mut i32) (i32.const 0))
  (global $b (mut i32) (i32.const 0))
  (global $c (mut i32) (i32.const 0))
  (global $d (mut i32) (i32.const 0))

  (func $poly (param $x i32) (result i32)
    ;; Calculate using horner method
      (i32.add
        (i32.mul
          (i32.add
            (i32.mul
              (i32.add
                (i32.mul (global.get $a) (local.get $x))
                (global.get $b)
              )
              (local.get $x)
            )
            (global.get $c)
          )
          (local.get $x)
        )
        (global.get $d)
      )
    

    )
  

  (func $main
    (local $x1 i32)
    (local $x2 i32)
    (local $x3 i32)
    
    (global.set $a (call $read_int))
    (global.set $b (call $read_int))
    (global.set $c (call $read_int))
    (global.set $d (call $read_int))

    (local.set $x1 (call $i32_symbol))
    (local.set $x2 (call $i32_symbol))
    (local.set $x3 (call $i32_symbol))

    
    (if (i32.eq (call $poly (local.get $x1)) (i32.const 0))
      (then
        
        (if (i32.and
              (i32.eq (call $poly (local.get $x2)) (i32.const 0))
              (i32.ne (local.get $x1) (local.get $x2))
            )
          (then
            
            (if (i32.and
                  (i32.eq (call $poly (local.get $x3)) (i32.const 0))
                  (i32.and
                    (i32.ne (local.get $x1) (local.get $x3))
                    (i32.ne (local.get $x2) (local.get $x3))
                  )
                )
              (then
                (unreachable)
              )
              (else
                (unreachable)
              )
            )

          )
          (else
            (unreachable)
          )
        )

      )
    )  )

  (start $main) 
)
