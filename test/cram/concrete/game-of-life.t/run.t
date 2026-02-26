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
