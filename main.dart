// Dieses Programm ist ein einfaches Konsolenspiel "Schiffe versenken".
import 'dart:io';
// Importieren des Mathepackages für die Verwendung von Punkten
import 'dart:math';

// Erstellung des Spielfeldes
// Eine Liste die eine Funktion enthält, die eine Liste und die Platzhalter zurückgibt
List<List<String>> generateGrid(int size) {
  // Erstellen einer Liste von Listen, die das Spielfeld repräsentiert
  // Jede Zelle wird mit dem Platzhalter '~' gefüllt, der für "Wasser" steht
  // Die Größe des Spielfeldes wird durch den Parameter 'size' bestimmt
  // und ist quadratisch (size x size)
  return List.generate(size, (_) => List.filled(size, '~'));
}

// Erstellung der Schiffe und Festlegung der Koordinaten, Rückgabe der Schiffe und ihrer Koordinaten in einer Liste
List<Point<int>> placeShips(int count, int size) {
  final random = Random();
  final ships = <Point<int>>{};
  // Verwenden eines Sets, um doppelte Koordinaten zu vermeiden
  while (ships.length < count) {
    int x = random.nextInt(size);
    int y = random.nextInt(size);
    ships.add(Point(x, y));
  }
  // Konvertieren des Set in eine Liste, um die Schiffe zurückzugeben
  return ships.toList();
}

// Ausgabe des Spielfeldes
void printGrid(List<List<String>> grid) {
  int size = grid.length;
  stdout.write('   ');
  // Ausgabe der Spaltenüberschriften
  for (int j = 0; j < size; j++) stdout.write('$j ');
  print('');
  // Ausgabe der Zeilenüberschriften und des Spielfeldes
  for (int i = 0; i < size; i++) {
    stdout.write('$i  ');
    // Ausgabe der Zellen des Spielfeldes
    for (int j = 0; j < size; j++) stdout.write('${grid[i][j]} ');
    print('');
  }
}

// Abfangen des Fehlers bei Eingabe einer Dezimalzahl oder nichts (Null-Safety)
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
  // Frage und Eingabe des Spielernamens
  print('Bitte gib deinen Namen oder Spielernamen ein:');
  String? playerName = stdin.readLineSync();
  // Wenn der Spieler keinen Namen eingibt, setze den Standardnamen
  // auf "Spieler"
  if (playerName == null || playerName.isEmpty) {
    playerName = 'Spieler';
  }
  // Personalisierte Begrüßung des Spielers
  print(
    'Hallo $playerName, lass uns spielen! Zuerst beantworte mir noch zwei Fragen:',
  );
  //Angabe der Spielfeldgröße und der Anzahl der Schiffe
  int gridSize = readInt(
    'Gib bitte die Größe des Spielfeldes ein (z. B. 5 für 5×5): ',
  );
  int shipCount = readInt(
    'Gib bitte die Anzahl der Schiffe ein, die versteckt werden sollen (z. B. 4 für 4 Schiffe): ',
  );

  // Erstellung des fertigen Spielfeldes und der vertecken Schiffe
  final grid = generateGrid(gridSize);
  final ships = placeShips(shipCount, gridSize);

  // Leere Variablen für Treffer und Versuche
  int hits = 0, attempts = 0;

  // Spielschleife, die so lange läuft, bis alle Schiffe versenkt sind
  while (hits < shipCount) {
    printGrid(grid);
    int row = readInt('Zeile (0–${gridSize - 1}): ');
    int col = readInt('Spalte (0–${gridSize - 1}): ');

    // Überprüfen, ob die Koordinaten im gültigen Bereich liegen
    if (row < 0 || row >= gridSize || col < 0 || col >= gridSize) {
      print('Koordinaten außerhalb des Bereichs!');
      continue;
    }
    // Überprüfen, ob das Feld bereits angegriffen wurde
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
