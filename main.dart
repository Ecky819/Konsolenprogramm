import 'dart:io';
import 'dart:math';

// Erstellung des Spielfeldes
// Eine LIste die eine Funktion enthält, die eine Liste und die PLatzhalter zurückgibt
List<List<String>> generateGrid(int size) {
  return List.generate(size, (_) => List.filled(size, '~'));
}

// Erstellung der Schiffe
List<Point<int>> placeShips(int count, int size) {
  final random = Random();
  final ships = <Point<int>>{};
  while (ships.length < count) {
    int x = random.nextInt(size);
    int y = random.nextInt(size);
    ships.add(Point(x, y));
  }
  return ships.toList();
}

// Ausgabe des Spielfeldes
void printGrid(List<List<String>> grid) {
  int size = grid.length;
  stdout.write('   ');
  for (int j = 0; j < size; j++) stdout.write('$j ');
  print('');
  for (int i = 0; i < size; i++) {
    stdout.write('$i  ');
    for (int j = 0; j < size; j++) stdout.write('${grid[i][j]} ');
    print('');
  }
}

// Abfangen des Fehlers bei Eingabe einer Dezimalzahl
int readInt(String prompt) {
  while (true) {
    stdout.write(prompt);
    final line = stdin.readLineSync();
    final value = line == null ? null : int.tryParse(line);
    if (value != null) return value;
    print('Ungültige Eingabe, bitte ganzzahlige Zahl eingeben.');
  }
}

// Begrüßung  und Erklärung
void main() {
  print('Willkomen zum Spiel "Schiffe versenken"!');
  print(
    'Dieses Spiel ist ein einfaches Konsolenspiel, bei dem du Schiffe versenken musst.',
  );
  // Begrüße den Spieler und frage nach dem Namen
  print('Bitte gib deinen Namen oder Spielernamen ein:');
  String? playerName = stdin.readLineSync();
  if (playerName == null || playerName.isEmpty) {
    playerName = 'Spieler';
  }

  print(
    'Hallo $playerName, lass uns spielen! Zuerst beantworte mir noch zwei Fragen:',
  );
  //Angabe der Spielfeldgröße und der Anzahl der Schiffe
  int gridSize = readInt(
    'Gieb bitte die Größe des Spielfeldes ein (z. B. 5 für 5×5): ',
  );
  int shipCount = readInt(
    'Gieb bitte die Anzahl der Schiffe ein, die versteckt werden sollen (z. B. 4 für 4 Schiffe): ',
  );

  // Erstellung des Spielfeldes und der Schiffe
  final grid = generateGrid(gridSize);
  final ships = placeShips(shipCount, gridSize);

  int hits = 0, attempts = 0;

  while (hits < shipCount) {
    printGrid(grid);
    int row = readInt('Zeile (0–${gridSize - 1}): ');
    int col = readInt('Spalte (0–${gridSize - 1}): ');

    if (row < 0 || row >= gridSize || col < 0 || col >= gridSize) {
      print('Koordinaten außerhalb des Bereichs!');
      continue;
    }
    if (grid[row][col] != '~') {
      print('Dieses Feld hast du bereits angegriffen.');
      continue;
    }
    //Zählen der Versuchen und Angriffe
    attempts++;
    if (ships.contains(Point(col, row))) {
      print('Treffer!');
      grid[row][col] = 'X';
      hits++;
    } else {
      print('Wasser.');
      grid[row][col] = 'O';
    }
  }

  //Ausgabe der Schiffe und Versuche
  printGrid(grid);
  print(
    '🎉 Glückwunsch! Du hast alle $shipCount Schiffe in $attempts Versuchen versenkt.',
  );
}
