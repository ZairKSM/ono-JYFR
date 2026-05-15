# Rapport du projet

## Comment exécuter le projet 

### Compilation
Pour compiler le projet:

```sh
dune build
```

### Concrete

Exécution concrète du projet:

```sh
dune exec ono -- concrete [option] game-of-life/game_of_life.wat 
```

Le mode `concrete` permet notamment d'utiliser les options suivantes, visibles dans `dune exec ono -- concrete --help`:
- `--config=CONFIG` pour charger une configuration initiale `.gol` (voire le fichier `game-of-life/configs/DOC.md` pour les formats de ces fichiers)
- `-w` / `--width` et `-h` / `--height` pour fixer la taille de la grille
- `--steps` pour limiter le nombre d'itérations
- `--seed` pour fixer la graine de la génération pseudo-aléatoire
- `--show_latest` pour n'afficher que les dernières configurations
- `--use-graphical-window` pour activer l'affichage graphique 

Fichiers `.gol` disponibles:
- `acorn.gol`
- `beacon.gol`
- `blinker.gol`
- `block.gol`
- `diehard.gol`
- `glider.gol`
- `lwss.gol`
- `pentadecathlon.gol`
- `pulsar.gol`
- `rpentomino.gol`
- `toad.gol`

voici des exemples d'exécution concrète:

```sh
# exécution avec acorn.gol, 35x55
dune exec ono -- concrete --config=game-of-life/configs/acorn.gol -w 35 -h 35  game-of-life/game_of_life.wat      

# exécution de basse (avec glider.gol) avec une grille vide 10x10
dune exec ono -- concrete -w 10 -h 10 game-of-life/game_of_life.wat

# simulation de lwss.gol, limitée à 10 étapes avec une grille 20x20 
dune exec ono -- concrete --config=game-of-life/configs/lwss.gol --steps 10 -w 20 -h 20 game-of-life/game_of_life.wat

# simulation de rpentomino avec affichage des 3 dernières générations sur 10 étapes
dune exec ono -- concrete --config=game-of-life/configs/rpentomino.gol  --steps 10 --show_latest 3 -w 20 -h 20 game-of-life/game_of_life.wat

# exécution avec affichage graphique avec pulsar.gol sur une grille 50x50
dune exec ono -- concrete --use-graphical-window --config=game-of-life/configs/pulsar.gol -w 50 -h 50 game-of-life/game_of_life.wat
```

### Symbolic

Pour l'exécution symbolique du générateur on utilise --constraint=ID ou --constraint=ID:N pour appliquer une contrainte spécifique à la génération, par exemple:

```sh
# génération symbolique sans contrainte explicite
dune exec ono -- symbolic game-of-life/generation/generate.wat 

# génération symbolique avec la contrainte 17 avec N a 6
dune exec ono -- symbolic game-of-life/generation/generate.wat --constraint=17:6

# génération symbolique avec la contrainte 5
dune exec ono -- symbolic game-of-life/generation/generate.wat --constraint=5
```

pour tester la génération symbolique, on peut aussi exécuter le simulateur concret sur la configuration générée:

```sh
dune exec ono -- concrete --config=game-of-life/generation/generate.gol --steps 2 --show_latest 2  -w 15 -h 15 game-of-life/game_of_life.wat 
``` 

Contraintes disponibles, Au tour suivant on a:
- `1` cellule `(0,0)` vivante au tour suivant
- `2` cellule `(0,0)` morte au tour suivant
- `3` au moins une cellule vivante au tour suivant
- `4` toutes les cellules vivantes au tour suivant
- `5` toutes les cellules mortes au tour suivant
- `6` une ligne horizontale complète de cellules vivantes
- `7` une colonne complète de cellules vivantes
- `8` exactement `35` cellules vivantes au tour suivant
- `9` il existe une cellule isolée (i.e. dont toutes les cellules voisines sont mortes)
- `10` il existe une cellule entourée de cellules vivantes
- `11` il existe deux cellules vivantes cote a cote (horizontal ou vertical)
- `12` présence d'un motif en `L`
- `13` présence d'un carré `NxN` de cellules vivantes (valeur de basse `2` pour `N`)
- `14` existence d'une cellule morte qui devient vivante
- `15` présence d'une alternance vivant/mort sur une longueur `N` (valeur de basse `4` pour `N`)
- `16` présence d'un motif clignotant de période `2`
- `17` présence d'une diagonale vivante de longueur `N` (valeur de basse `4` pour `N`)


Le mode `symbolic`, va générer une configuration du jeu de la vie qui satisfait une contrainte donnée. Le résultat de cette génération est exporté dans un fichier `.gol` dans le répertoire `game-of-life/generation`, avec un nom du type `generate.gol`.

 
## Test

Les vérifications se font avec les tests cram :

```sh
dune runtest
```

### Tests `concrete`

- `test/cram/concrete/manpage.t/run.t`
  vérifie la documentation de `ono concrete`, en particulier les options `--config`, `-w`, `-h`, `--seed`, `--steps`, `--show_latest` et `--use-graphical-window`
- `test/cram/concrete/game-of-life.t/run.t`
  valide les primitives du jeu de la vie et le passage correct des options `-w`, `-h`, `--steps` et `--show_latest`, ainsi que leurs cas d'erreur
- `test/cram/concrete/config-tests.t/run.t`
  teste le chargement de fichiers `.gol` réels et l'évolution correcte de plusieurs motifs du jeu de la vie, par exemple `blinker`, `block`, `glider` et les autres configurations présentes dans `game-of-life/configs/`
- `test/cram/concrete/factorial.t/run.t`
  exemple test factorielle
- `test/cram/concrete/fibonacci.t/run.t`
  exemple test Fibonacci
- `test/cram/concrete/square_i64.t/run.t`
  exemple test de calcul de carré d'un entier 64 bits
- `test/cram/concrete/random.t/run.t`
  vérifie que l'option `--seed` rend la génération pseudo-aléatoire reproductible

### Tests `symbolic`

- `test/cram/symbolic/manpage.t/run.t`
  vérifie la documentation de `ono symbolic` et la présence de la nouvelle option `--constraint=ID`
- `test/cram/symbolic/basic_symbol.t/run.t`
- `test/cram/symbolic/fibonacci.t/run.t`



## Parties réalisés 

Le tableau suivant reprend les demandes du `README` dans leur ordre d'apparition, avec l'issue associée quand elle existe dans le dépôt.

| Demande du README | Statut | Issue attribuée |
| --- | --- | --- |
| Écrire un module Wasm avec `$factorial` et un cram test | Fait | [#2](https://github.com/ZairKSM/ono-JYFR/issues/2) |
| Ajouter `print_i64`, écrire `$square_i64` et un cram test | Fait | [#2](https://github.com/ZairKSM/ono-JYFR/issues/2) |
| Ajouter `random_i32`, l'option `--seed` et un cram test déterministe | Fait | [#38](https://github.com/ZairKSM/ono-JYFR/issues/38) |
| Ajouter les primitives OCaml `sleep`, `print_cell`, `newline`, `clear_screen` | Fait | [#9](https://github.com/ZairKSM/ono-JYFR/issues/9) |
| Poser la base du jeu de la vie en Wasm: mémoire, dimensions, conversions, `get_cell`, `set_cell` | Fait | [#10](https://github.com/ZairKSM/ono-JYFR/issues/10) |
| Implémenter la logique du jeu: voisins, `next_state`, itération | Fait | [#11](https://github.com/ZairKSM/ono-JYFR/issues/11) |
| Ajouter la boucle principale et l'affichage textuel du jeu | Fait | [#12](https://github.com/ZairKSM/ono-JYFR/issues/12) |
| Ajouter `read_int` et permettre à l'utilisateur de choisir les dimensions | Fait | [#18](https://github.com/ZairKSM/ono-JYFR/issues/18) |
| Définir un format de fichier pour les configurations initiales | Fait | [#19](https://github.com/ZairKSM/ono-JYFR/issues/19) |
| Ajouter `--steps` et `--show_latest` pour tester la simulation | Fait | [#20](https://github.com/ZairKSM/ono-JYFR/issues/20) |
| Écrire des configurations initiales et des cram tests pertinents | Fait | [#21](https://github.com/ZairKSM/ono-JYFR/issues/21) |
| Réaliser une version graphique du jeu dans une fenêtre | Fait | [#35](https://github.com/ZairKSM/ono-JYFR/issues/35), [#36](https://github.com/ZairKSM/ono-JYFR/issues/36), [#33](https://github.com/ZairKSM/ono-JYFR/issues/33) |
| Ajouter un flag `--use-graphical-window` pour choisir le rendu | Fait | [#37](https://github.com/ZairKSM/ono-JYFR/issues/37) |
| Mettre en place l'exécution symbolique dans `ono` | Fait | [#41](https://github.com/ZairKSM/ono-JYFR/issues/41) |
| Implémenter un solveur de polynômes en Wasm en mode symbolique | Fait | [#43](https://github.com/ZairKSM/ono-JYFR/issues/43) |
| Générer une grille du jeu de la vie sans contrainte et produire une sortie lisible par le simulateur | Fait | [#44](https://github.com/ZairKSM/ono-JYFR/issues/44) |
| Ajouter différentes contraintes intéressantes pour la génération symbolique | Fait | [#45](https://github.com/ZairKSM/ono-JYFR/issues/45) |
| Ajouter une option pour choisir les contraintes appliquées | Fait | [#46](https://github.com/ZairKSM/ono-JYFR/issues/46) |
| Bonus avec l'implementation en JS | Fait | [#51](https://github.com/ZairKSM/ono-JYFR/issues/51) |

## Points subtils 

## Difficultés 

## Échecs

- La partie solveur de polynômes n'est pas totalement parfait, il manque d'optimisation 
- Le jeu de la vie n'est pas très optimisé.
