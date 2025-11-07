import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Direction { north, south, east, west }

class Room {
  final String description;
  final Map<Direction, int> exits = {};

  Room(this.description);
}

void main() => runApp(const MaterialApp(
      title: 'Choose Your Adventure Game',
      home: AdventureGame(),
    ));

class AdventureGame extends StatefulWidget {
  const AdventureGame({super.key});

  @override
  State<AdventureGame> createState() => _AdventureGameState();
}

class _AdventureGameState extends State<AdventureGame> {
  int _currentRoomIndex = 0;
  final List<Room> _world = [];

  @override
  void initState() {
    super.initState();
    _generateWorld();
  }

  void _generateWorld() {
    const creatures = ['glowing mushrooms', 'a sleeping dragon', 'a flock of bats', 'a ghostly figure', 'a chittering goblin', 'a hidden treasure chest'];
    const places = ['a damp cave', 'a dusty hall', 'a narrow passage', 'a vast cavern', 'a torch-lit chamber', 'a secret exit'];

    for (var i = 0; i < 6; i++) {
      _world.add(Room('You are in ${places[i]} with ${creatures[i]}.'));
    }

    _createExit(0, 1, Direction.north);
    _createExit(1, 2, Direction.east);
    _createExit(2, 3, Direction.north);
    _createExit(1, 4, Direction.west);
    _createExit(4, 5, Direction.north);
  }

  void _createExit(int from, int to, Direction direction) {
    final opposite = {
      Direction.north: Direction.south,
      Direction.south: Direction.north,
      Direction.east: Direction.west,
      Direction.west: Direction.east,
    };
    _world[from].exits[direction] = to;
    _world[to].exits[opposite[direction]!] = from;
  }

  void _move(Direction direction) {
    setState(() {
      _currentRoomIndex = _world[_currentRoomIndex].exits[direction]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentRoom = _world[_currentRoomIndex];
    final isGameOver = _currentRoomIndex == 5;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Adventure'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Room #${_currentRoomIndex + 1}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              isGameOver ? 'You found the treasure and escaped! Game Over.' : currentRoom.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            if (!isGameOver)
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 12.0,
                children: currentRoom.exits.keys.map((direction) {
                  return ElevatedButton(
                    onPressed: () => _move(direction),
                    child: Text(direction.name.toUpperCase()),
                  );
                }).toList(),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text('Exit Game'),
            )
          ],
        ),
      ),
    );
  }
}
