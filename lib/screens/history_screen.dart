// lib/screens/history_screen.dart

import 'package:flutter/material.dart';

import '../models/coffee_run_history.dart';

class HistoryScreen extends StatelessWidget {
  final List<CoffeeRunHistory> history;

  const HistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(
        child: Text(
          'No coffee run history yet.',
          style: TextStyle(fontSize: 20),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final run = history[index];
        final total = run.orders.fold<double>(
          0,
          (sum, order) => sum + order.price,
        );

        return Card(
          child: ExpansionTile(
            leading: const Icon(Icons.history),
            title: Text('${run.orders.length} Orders'),
            subtitle: Text(
              '${run.date.month}/${run.date.day}/${run.date.year}\n'
              'Total: \$${total.toStringAsFixed(2)}',
            ),
            children: run.orders.map((order) {
              return ListTile(
                leading: const Icon(Icons.coffee),
                title: Text(order.coworkerName),
                subtitle: Text(
                  '${order.order}\n\$${order.price.toStringAsFixed(2)}',
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
