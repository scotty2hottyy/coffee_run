// lib/screens/saved_orders_screen.dart

import 'package:flutter/material.dart';
import '../models/coffee_order.dart';

class SavedOrdersScreen extends StatelessWidget {
  final List<CoffeeOrder> savedOrders;

  final void Function(CoffeeOrder order)
  onUseOrder;

  final void Function(int index)
  onDeleteOrder;

  const SavedOrdersScreen({
    super.key,
    required this.savedOrders,
    required this.onUseOrder,
    required this.onDeleteOrder,
  });

  @override
  Widget build(BuildContext context) {
    if (savedOrders.isEmpty) {
      return const Center(
        child: Text(
          'No saved orders yet.',
          style: TextStyle(fontSize: 20),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: savedOrders.length,
      itemBuilder: (context, index) {
        final order = savedOrders[index];

        return Card(
          child: ListTile(
            leading: const Icon(
              Icons.bookmark,
            ),
            title: Text(
              order.coworkerName,
            ),
            subtitle: Text(
              order.order,
            ),
            trailing: Wrap(
              children: [
                IconButton(
                  tooltip:
                  'Add to Coffee Run',
                  onPressed: () {
                    onUseOrder(order);
                  },
                  icon: const Icon(
                    Icons.add_circle,
                  ),
                ),
                IconButton(
                  tooltip:
                  'Delete Saved Order',
                  onPressed: () {
                    onDeleteOrder(index);
                  },
                  icon: const Icon(
                    Icons.delete,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}