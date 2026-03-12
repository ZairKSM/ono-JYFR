### Fichiers .gol

Un fichier .gol est un fichier de configuration pour le jeu de la vie. Il contient des informations sur le nom de la configuration, son offset par rapport à l'origine, et la liste des cellules vivantes. Voici un exemple de fichier .gol pour le blinker :

```
# Blinker
# Oscille entre une ligne et une colonne cycle de période 2. 
name Blinker
offset 10 10

OOO
```

Les lignes commençant par # sont des commentaires et ne sont pas prises en compte par le programme. La ligne `name` indique le nom de la configuration ( optionnel ). la ligne `offset` indique les coordonnées de la cellule vivante la plus à gauche et la plus haute (0,0 par défaut). Les lignes suivantes représentent la grille de cellules, où O représente une cellule vivante et . représente une cellule morte. Les lignes vides sont ignorées.