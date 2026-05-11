# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),



## Release History



### [X.X.X] - 2026-05-11
### Added
- ajout des contraintes 6,7,8 ([#45](https://github.com/ZairKSM/ono-JYFR/issues/45))
- ajout des contraintes 4,5 ([#45](https://github.com/ZairKSM/ono-JYFR/issues/45))
- ajout des contraintes 17, 17_bis, 15, 14, 13, 12 ([#45](https://github.com/ZairKSM/ono-JYFR/issues/45))

### [X.X.X] - 2026-05-10
### Added
- ajout des contraintes 1,3 ([#45](https://github.com/ZairKSM/ono-JYFR/issues/45))
- optimised next state (removed a useless if)


### [X.X.X] - 2026-05-08
### Added
- implémentation du ".gol" comme valeur de retour pour `generate.wat` ([#44](https://github.com/ZairKSM/ono-JYFR/issues/44))

# A COMPLÉTER 
# A COMPLÉTER 
# A COMPLÉTER 

### [1.3.0] - 2026-04-09
### Added
- implémentation complète de l’interface graphique de la simulation avec Raylib: rendu du plateau, mise à jour des cellules et intégration à `--use-graphical-window` ([#36](https://github.com/ZairKSM/ono-JYFR/issues/36))

### [1.2.1] - 2026-03-27
### Added
- Mise en place initiale de l'interface graphique via l'option `--use-graphical-window` avec `Raylib` ([#35](https://github.com/ZairKSM/ono-JYFR/issues/35))

### [1.2.0] - 2026-03-27
### Added
- extension textuelle complète pour le jeu de la vie: lecture des dimensions via `read_int` et options `-w`/`-h` ([#18](https://github.com/ZairKSM/ono-JYFR/issues/18))
- contrôle de simulation en ligne de commande avec `--steps` et filtrage d'affichage avec `--show_latest` ([#20](https://github.com/ZairKSM/ono-JYFR/issues/20))
- support des configurations initiales `.gol` via `--config`, ajout d'un jeu de patterns et crams tests associés ([#19](https://github.com/ZairKSM/ono-JYFR/issues/19), [#21](https://github.com/ZairKSM/ono-JYFR/issues/21))

### Changed
- alignement du formatage OCaml sur `ocamlformat 0.29.0` et ajout de la dépendance de dev correspondante dans les métadonnées opam

### Fixed
- stabilisation CI/CD Debian unstable: restauration/sauvegarde fiable du cache `_opam` et correction de l'ordre `apt-get update` avant création de switch opam pour éviter les erreurs ([#17](https://github.com/ZairKSM/ono-JYFR/issues/17), [#25](https://github.com/ZairKSM/ono-JYFR/issues/25))

### [1.1.2] - 2026-03-3
### Added
- nouvelles configurations initiales du jeu de la vie dans `game-of-life/configs/` : `beacon`, `lwss`, `pulsar`, `pentadecathlon`, `rpentomino`, `acorn` et `diehard` ([#21](https://github.com/ZairKSM/ono-JYFR/issues/21))
- nouveaux cram tests pour valider le chargement des configurations `.gol` et le comportement des patterns avec `--config`, `--steps`, `--show_latest`, `-w` et `-h` ([#21](https://github.com/ZairKSM/ono-JYFR/issues/21))


### [1.1.1] - 2026-03-12
### Added
- option `--steps` qui permet de faire x tour du jeu ([#20](https://github.com/ZairKSM/ono-JYFR/issues/20))
- option `--show_latest` qui affiche les y dernier plateau du jeu ([#20](https://github.com/ZairKSM/ono-JYFR/issues/20))

### [1.1.0] - 2026-??-??
### Added
- Fonction `$read_int` pour pouvoir lire un entier pour la taille du plateau ([#18](https://github.com/ZairKSM/ono-JYFR/issues/18))
- ajout des options `-w` et `-h` pour spécifier la largeur et la hauteur du plateau en ligne de commande 


### [1.0.0] - 2026-02-19
### Added
- Fonction `$alternate` pour alterner entre les deux zones mémoire (double-buffering) afin d'éviter les effets de bord lors du calcul de l'état suivant ([#12](https://github.com/ZairKSM/ono-JYFR/issues/12))
- Fonction `$display_board` pour afficher l'état courant du plateau cellule par cellule ([#12](https://github.com/ZairKSM/ono-JYFR/issues/12))
- Fonction `$main_loop` : boucle principale du jeu, initialise un planeur (*glider*) et itère indéfiniment en affichant et calculant chaque génération ([#12](https://github.com/ZairKSM/ono-JYFR/issues/12))



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

### [0.1.0] - 2025-12-16
### Added
- first version

## Unreleased
