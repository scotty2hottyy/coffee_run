// lib/models/coffee_run_history.dart

import 'coffee_order.dart';

class CoffeeRunHistory {
  final DateTime date;
  final List<CoffeeOrder> orders;

  CoffeeRunHistory({required this.date, required this.orders});

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'orders': orders.map((order) => order.toJson()).toList(),
    };
  }

  factory CoffeeRunHistory.fromJson(Map<String, dynamic> json) {
    final date = json['date'];
    final orders = json['orders'];

    if (date is! String || orders is! List) {
      throw const FormatException('Invalid coffee run history data.');
    }

    return CoffeeRunHistory(
      date: DateTime.parse(date),
      orders: orders
          .map(
            (order) =>
                CoffeeOrder.fromJson(Map<String, dynamic>.from(order as Map)),
          )
          .toList(),
    );
  }
}
