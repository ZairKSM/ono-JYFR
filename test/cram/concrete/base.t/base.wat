(module $base
    (func $print_i64 (import "ono" "print_i64") (param i64))
    (func $print_i32 (import "ono" "print_i32") (param i32))

    (global $w      i32  (i32.const 42))  ;; width
    (global $h      i32  (i32.const 42))  ;; height

    (memory 10)   

    ;; bas niveua
    ;; recuperer les bon 8 bits associé
    (func $get_bit (param $i i32) (result i32)
        (local.get $i) ;; indice
        i32.load 
        ;; on bit shift a gauche pour effacer ce qui y'a devant
        i32.const 24 ;; 32-8 = 24 bits, on decale de 24 bits pour effacer les 24 bits devant
        i32.shl

        i32.const 24 ;; 32-8 = 24; on decale vers la droite pour recuperer le bon nombre final
        i32.shr_u
    )

    ;; bas niveau
    ;; recup tous les bit de l'indice et reverse 
    ;; et ajoute l'elemeent au debut
    (func $pre_set_bit (param $i i32) (param $elem i32) (result i32)
        ;; on recup les 4 bytes
        (local.get $i) ;; indice
        i32.load 

        i32.const 8
        i32.shr_u

        i32.const 8
        i32.shl

        (local.get $elem)
        i32.or
    )

    ;; bas niveau - gentil
    (func $set_bit (param $i i32) (param $elem i32)

        (local.get $i) ;; premier argument de i32

        (local.get $i) 
        (local.get $elem) 
        call $pre_set_bit

        i32.store ;; on store indice et les 4 bytes modifié 
    )

    ;; mid niveau set 
    (func $set)

    ;; mid niveau get
    (func $get)
    
    ;; haut niveau
    (func $set_cell (param $x i32) (param $y i32) (param $elem i32) (result i32)
        i32.const 0
    )

    ;; haut niveau
    (func $get_cell (param $x i32) (param $y i32) (result i32)
        ;; TODO on check avant si on est pas out of bound
        i32.const 0
    )

    (func $main
    ;;   call $init_memory
      i64.const 50000
      call $print_i64

      (i32.const 0) ;;indice ( ou offset)
      (i32.const 10) ;; elem
      i32.store ;; 

      (i32.const 1) ;;indice ( ou offset)
      (i32.const 1) ;; elem
      i32.store ;; 

      (i32.const 2) ;;indice ( ou offset)
      (i32.const 0) ;; elem
      i32.store ;; 

      (i32.const 3) ;;indice ( ou offset)
      (i32.const 1) ;; elem
      i32.store ;; 

      (i32.const 4) ;;indice ( ou offset)
      (i32.const 6) ;; elem
      i32.store ;; 

      ;; loadd

      (i32.const 0) ;; indice
      i32.load 
      call $print_i32

      (i32.const 4) ;; indice
      i32.load 
      call $print_i32


    ;;   (i32.const 0) ;;indice ( ou offset)
    ;;   (i32.const 2) ;; elem
    ;;   i32.store ;; 
      
      (i32.const 0) ;;indice ( ou offset)
      (i32.const 2) ;; elem
      call $set_bit
    ;;   call $print_i32
      
      (i32.const 0)
      call $get_bit
      call $print_i32
      

      (i32.const 0) ;; indice
      i32.load 
      call $print_i32

    )
    (start $main)
)