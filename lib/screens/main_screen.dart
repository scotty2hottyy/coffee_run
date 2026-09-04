// lib/screens/main_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static const String _savedOrdersKey = 'saved_orders';
  static const String _historyKey = 'coffee_run_history';

  int _selectedIndex = 0;

  final List<CoffeeOrder> _currentOrders = [];
  final List<CoffeeOrder> _savedOrders = [];
  final List<CoffeeRunHistory> _history = [];

  @override
  void initState() {
    super.initState();
    _loadPersistentData();
  }

  Future<void> _loadPersistentData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedOrders = _decodeSavedOrders(prefs.getString(_savedOrdersKey));
      final history = _decodeHistory(prefs.getString(_historyKey));

      if (!mounted) {
        return;
      }

      setState(() {
        _savedOrders
          ..clear()
          ..addAll(savedOrders);
        _history
          ..clear()
          ..addAll(history);
      });
    } catch (_) {
      // If preferences cannot be read, keep the app usable with empty lists.
    }
  }

  List<CoffeeOrder> _decodeSavedOrders(String? storedData) {
    if (storedData == null) {
      return [];
    }

    try {
      final decodedData = jsonDecode(storedData);

      if (decodedData is! List) {
        return [];
      }

      return decodedData
          .map(
            (order) =>
                CoffeeOrder.fromJson(Map<String, dynamic>.from(order as Map)),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  List<CoffeeRunHistory> _decodeHistory(String? storedData) {
    if (storedData == null) {
      return [];
    }

    try {
      final decodedData = jsonDecode(storedData);

      if (decodedData is! List) {
        return [];
      }

      return decodedData
          .map(
            (run) => CoffeeRunHistory.fromJson(
              Map<String, dynamic>.from(run as Map),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveSavedOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedOrders = jsonEncode(
        _savedOrders.map((order) => order.toJson()).toList(),
      );

      await prefs.setString(_savedOrdersKey, encodedOrders);
    } catch (_) {}
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedHistory = jsonEncode(
        _history.map((run) => run.toJson()).toList(),
      );

      await prefs.setString(_historyKey, encodedHistory);
    } catch (_) {}
  }

  void _addCurrentOrder(String name, String order, double price) {
    setState(() {
      _currentOrders.add(
        CoffeeOrder(coworkerName: name, order: order, price: price),
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
          saved.order.toLowerCase() == order.order.toLowerCase(),
    );

    if (!alreadySaved) {
      setState(() {
        _savedOrders.add(
          CoffeeOrder(
            coworkerName: order.coworkerName,
            order: order.order,
            price: order.price,
          ),
        );
      });

      _saveSavedOrders();

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Order saved.')));
    }
  }

  void _useSavedOrder(CoffeeOrder order) {
    setState(() {
      _currentOrders.add(
        CoffeeOrder(
          coworkerName: order.coworkerName,
          order: order.order,
          price: order.price,
        ),
      );

      _selectedIndex = 0;
    });
  }

  void _deleteSavedOrder(int index) {
    setState(() {
      _savedOrders.removeAt(index);
    });

    _saveSavedOrders();
  }

  void _completeCoffeeRun() {
    if (_currentOrders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one order first.')),
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

    _saveHistory();
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

      HistoryScreen(history: _history),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Coffee Run')),
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.coffee), label: 'Coffee Run'),
          NavigationDestination(
            icon: Icon(Icons.bookmark),
            label: 'Saved Orders',
          ),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
