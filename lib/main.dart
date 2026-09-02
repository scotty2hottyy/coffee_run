import 'package:flutter/material.dart';

void main() {
  runApp(const CoffeeRunApp());
}

class CoffeeRunApp extends StatelessWidget {
  const CoffeeRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Run',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    Center(
      child: Text(
        'Coffee Run',
        style: TextStyle(fontSize: 28),
      ),
    ),
    Center(
      child: Text(
        'Saved Orders',
        style: TextStyle(fontSize: 28),
      ),
    ),
    Center(
      child: Text(
        'History',
        style: TextStyle(fontSize: 28),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Run'),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.coffee),
            label: 'Coffee Run',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark),
            label: 'Saved Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}