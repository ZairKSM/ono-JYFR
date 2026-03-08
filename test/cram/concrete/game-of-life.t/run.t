Test basic functions (grid, set/get cell, bounds):
  $ echo "42 42" | ono concrete game_of_life.wat
  1
  8
  9
  0
  0
  OK!

Test basic functions with -w and -h flags:
  $ ono concrete game_of_life.wat -w 42 -h 42
  1
  8
  9
  0
  0
  OK!

Test of display primitives (print_cell, newline, clear_screen, sleep):
  $ ono concrete primitives.wat
  ████████
  ████████
  ████████
  ████████
  OK!
