Test des fonctions de base (grille, set/get cell, bornes):
  $ ono concrete game_of_life.wat
  1
  8
  9
  0
  0
  OK!

Test des primitives d'affichage (print_cell, newline, clear_screen, sleep):
  $ ono concrete primitives.wat
  ████████
  ████████
  ████████
  ████████
  OK!

Test de l'option --steps (valeur transmise au module Wasm):
  $ ono concrete --steps 42 steps.wat
  42
  OK!

Sans --steps, la valeur par défaut est -1 (simulation infinie côté Wasm):
  $ ono concrete steps.wat
  -1
  OK!

Test de l'option --show_latest (valeur transmise au module Wasm):
  $ ono concrete --show_latest 3 --steps 5 show_latest.wat
  3
  OK!

Sans --show_latest, la valeur par défaut est -1 (pas de mode show_latest):
  $ ono concrete show_latest.wat
  -1
  OK!

--show_latest doit être > 0:
  $ ono concrete --show_latest 0 --steps 5 show_latest.wat
  ono: [ERROR] -show_latest doit etre > 0
  [123]

--show_latest requiert --steps:
  $ ono concrete --show_latest 3 show_latest.wat
  ono: [ERROR] --show_latest doit être appelé avec --steps
  [123]
