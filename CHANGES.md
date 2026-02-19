# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),



## Release History

### [1.0.0] - 2026-02-19
### Added
- Fonction `$alternate` pour alterner entre les deux zones mémoire (double-buffering) afin d'éviter les effets de bord lors du calcul de l'état suivant ([#12](https://github.com/ZairKSM/ono-JYFR/issues/12))
- Fonction `$display_board` pour afficher l'état courant du plateau cellule par cellule ([#12](https://github.com/ZairKSM/ono-JYFR/issues/12))
- Fonction `$main_loop` : boucle principale du jeu, initialise un planeur (*glider*) et itère indéfiniment en affichant et calculant chaque génération ([#12](https://github.com/ZairKSM/ono-JYFR/issues/12))



### [0.1.0] - 2025-12-16
### Added
- first version

## Unreleased

### [0.4.0] - 2026-02-18
### Added
- Fonction `$nb_neighbours` pour compter le nombre de voisins vivants d'une cellule : [i32 ; i32] -> \[i32] ([#11](https://github.com/ZairKSM/ono-JYFR/issues/11))
- Fonction `$next_state` pour calculer le prochain état d'une cellule selon les règles du jeu de la vie : [i32 ; i32] -> \[i32] ([#11](https://github.com/ZairKSM/ono-JYFR/issues/11))
- Fonction `$iteration` pour calculer et appliquer le prochain état de toutes les cellules du plateau ([#11](https://github.com/ZairKSM/ono-JYFR/issues/11))


### [0.3.0] - 2026-02-12
### Added
- Fonction `get` pour récupérer un entier (i32) stocker dans un indice donnée : \[i32] -> \[i32] ([#10](https://github.com/ZairKSM/ono-JYFR/issues/10))
- Fonction `set` pour stocker un entier (i32) dans un indice donnée : [i32 ; i32] -> [] ([#10](https://github.com/ZairKSM/ono-JYFR/issues/10))
- Fonction `get_cell` pour recuperer une cellule depuis deux indices x et y : [i32 ; i32] -> \[i32] ([#10](https://github.com/ZairKSM/ono-JYFR/issues/10))
- Fonction `set_cell` pour stocker une cellule depuis deux indices x et y et un element donnée : [i32 ; i32 ; i32] -> [] ([#10](https://github.com/ZairKSM/ono-JYFR/issues/10))
- Fonction `convertToXY` pour convertir une coordonnée linéaire vers deux coordonée x et y : \[i32] -> [i32 ; i32] ([#10](https://github.com/ZairKSM/ono-JYFR/issues/10))
- Fonction `convertToLinear` pour convertir les coordonnées x et y vers une coordonnée linéaire (utilisée dans get_cell et set_cell) : [i32 ; i32] -> \[i32] ([#10](https://github.com/ZairKSM/ono-JYFR/issues/10))
- Fonction `isValid` pour verifier si les coordonnée donnés en entrée sont valide (utilisé dans get_cell et set_cell) : [i32 ; i32] -> \[i32] (0 or 1) ([#10](https://github.com/ZairKSM/ono-JYFR/issues/10))


### [0.2.0] - 2026-02-10
### Added
- Fonction `sleep` pour attendre un nombre de millisecondes ([#9](https://github.com/ZairKSM/ono-JYFR/issues/9))
- Fonction `print_cell` pour afficher une cellule vivante ou morte ([#9](https://github.com/ZairKSM/ono-JYFR/issues/9))
- Fonction `newline` pour ajouter un saut de ligne ([#9](https://github.com/ZairKSM/ono-JYFR/issues/9))
- Fonction `clear_screen` pour afficher et vider le buffer d'affichage ([#9](https://github.com/ZairKSM/ono-JYFR/issues/9))

### [0.1.1] - 2026-02-05
### added
- Fonction `$factorial` en WebAssembly avec tests ([#2](https://github.com/ZairKSM/ono-JYFR/issues/2))
- Fonction `$square` en WebAssembly avec tests ([#2](https://github.com/ZairKSM/ono-JYFR/issues/2))
- Fonction `print_i64` pour afficher des entiers 64 bits ([#2](https://github.com/ZairKSM/ono-JYFR/issues/2))
- Fonction `random_i32` pour générer des nombres aléatoires ([#2](https://github.com/ZairKSM/ono-JYFR/issues/2))
- Option `--seed` pour rendre la génération aléatoire reproductible ([#2](https://github.com/ZairKSM/ono-JYFR/issues/2))


### Fixed
- Erreur dans `$factorial` pour les entrées négatives, maintenant retourne 0 au lieu de causer une erreur



