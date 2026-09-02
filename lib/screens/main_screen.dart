// lib/screens/main_screen.dart

import 'package:flutter/material.dart';

import '../models/coffee_order.dart';
import '../models/coffee_run_history.dart';

import 'coffee_run_screen.dart';
import 'saved_orders_screen.dart';
import 'history_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<CoffeeOrder> _currentOrders = [];
  final List<CoffeeOrder> _savedOrders = [];
  final List<CoffeeRunHistory> _history = [];

  void _addCurrentOrder(String name, String order) {
    setState(() {
      _currentOrders.add(
        CoffeeOrder(
          coworkerName: name,
          order: order,
        ),
      );
    });
  }

  void _removeCurrentOrder(int index) {
    setState(() {
      _currentOrders.removeAt(index);
    });
  }

  void _saveOrder(CoffeeOrder order) {
    final alreadySaved = _savedOrders.any(
          (saved) =>
      saved.coworkerName.toLowerCase() ==
          order.coworkerName.toLowerCase() &&
          saved.order.toLowerCase() ==
              order.order.toLowerCase(),
    );

    if (!alreadySaved) {
      setState(() {
        _savedOrders.add(
          CoffeeOrder(
            coworkerName: order.coworkerName,
            order: order.order,
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order saved.'),
        ),
      );
    }
  }

  void _useSavedOrder(CoffeeOrder order) {
    setState(() {
      _currentOrders.add(
        CoffeeOrder(
          coworkerName: order.coworkerName,
          order: order.order,
        ),
      );

      _selectedIndex = 0;
    });
  }

  void _deleteSavedOrder(int index) {
    setState(() {
      _savedOrders.removeAt(index);
    });
  }

  void _completeCoffeeRun() {
    if (_currentOrders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add at least one order first.'),
        ),
      );

      return;
    }

    setState(() {
      _history.insert(
        0,
        CoffeeRunHistory(
          date: DateTime.now(),
          orders: List.from(_currentOrders),
        ),
      );

      _currentOrders.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      CoffeeRunScreen(
        currentOrders: _currentOrders,
        onAddOrder: _addCurrentOrder,
        onRemoveOrder: _removeCurrentOrder,
        onSaveOrder: _saveOrder,
        onCompleteRun: _completeCoffeeRun,
      ),

      SavedOrdersScreen(
        savedOrders: _savedOrders,
        onUseOrder: _useSavedOrder,
        onDeleteOrder: _deleteSavedOrder,
      ),

      HistoryScreen(
        history: _history,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Run'),
      ),
      body: screens[_selectedIndex],
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