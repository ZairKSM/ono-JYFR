(module $base
    (func $print_i32 (import "ono" "print_i32") (param i32))

    (global $w      i32  (i32.const 42))  ;; width
    (global $h      i32  (i32.const 42))  ;; height

    (memory 10_000)   

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
    ;; on decale a droite pour "effacer" les 8 bits de droite
    ;; puis on decale a gauche pour revenir sur l'entier precedent sans les 8 premier bits
    ;; on applique un or (addition gentille) qui permet d'ajouter l'entier ($elem) au debut
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

    ;; fonction qui converti les deux coordonné en une coordonné uniquie (linéaire)
    (func $convertToLinear (param $x i32) (param $y i32) (result i32)
        local.get $x
        global.get $w
        i32.mul

        local.get $y
        i32.add
    )
    ;; fonction qui converti une coordonnée linéaire en deux coordonnée x et y
    (func $convertToXY (param $i i32) (result i32) (result i32)
        ;; x
        
        local.get $i
        global.get $w
        i32.div_u
        
        ;;y
        local.get $i
        global.get $w
        i32.rem_u

    
    
    )
    ;; méthode qui permet de check si les coordonnée sont out ou in bound
    (func $isValid (param $x i32) (param $y i32) (result i32)

        local.get $x
        i32.const 0
        i32.lt_u 

        (if (then 
            i32.const 0
            return
        ))

        local.get $x
        global.get $w
        i32.ge_u

        (if (then 
            i32.const 0
            return
        ))

        local.get $y
        i32.const 0
        i32.lt_u 

        (if (then 
            i32.const 0
            return
        ))

        local.get $y
        global.get $h
        i32.ge_u

        (if (then 
            i32.const 0
            return
        ))

        i32.const 1
    )
    
    ;; haut niveau
    (func $set_cell (param $x i32) (param $y i32) (param $elem i32)
        local.get $x

        local.get $y

        call $isValid
        i32.const 1
        i32.ne 
        (if (then
            return ;; on ne fait rien
        ))


        local.get $x

        local.get $y

        call $convertToLinear

        local.get $elem

        call $set_bit

    )

    ;; haut niveau
    (func $get_cell (param $x i32) (param $y i32) (result i32)
        ;; TODO on check avant si on est pas out of bound
        ;; if (i32.ge_u (local.get $x) (i32.const 0) ) (i32.lt_u (local.get $x) (global.get $w))
        local.get $x

        local.get $y

        call $isValid
        i32.const 1
        i32.ne 
        (if (then
            i32.const -1 ;; erreur
            return
        ))

        local.get $x

        local.get $y

        call $convertToLinear

        call $get_bit
    )

    (func $main

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


      i32.const 1
      i32.const 1
      call $convertToLinear
      call $print_i32

      
      i32.const 43
      call $convertToXY
      call $print_i32
      call $print_i32

      i32.const 43
      i32.const 1
      call $isValid
      call $print_i32

      i32.const 1
      i32.const 1
      call $isValid
      call $print_i32

      i32.const 1
      i32.const 1
      i32.const 1
      call $set_cell

      i32.const 1
      i32.const 1
      call $get_cell
      call $print_i32

      i32.const 1
      i32.const 1
      i32.const 8
      call $set_cell


      i32.const 0
      i32.const 1
      i32.const 9
      call $set_cell


      i32.const 1
      i32.const 1
      call $get_cell
      call $print_i32

      i32.const 0
      i32.const 1
      call $get_cell
      call $print_i32

      i32.const 42
      i32.const 1
      call $get_cell
      call $print_i32

    )
    (start $main)
)