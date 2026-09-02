// lib/models/coffee_run_history.dart

import 'coffee_order.dart';

class CoffeeRunHistory {
  final DateTime date;
  final List<CoffeeOrder> orders;

  CoffeeRunHistory({
    required this.date,
    required this.orders,
  });
}