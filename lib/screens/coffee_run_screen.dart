// lib/screens/coffee_run_screen.dart

import 'package:flutter/material.dart';
import '../models/coffee_order.dart';

class CoffeeRunScreen extends StatefulWidget {
  final List<CoffeeOrder> currentOrders;

  final void Function(String name, String order) onAddOrder;
  final void Function(int index) onRemoveOrder;
  final void Function(CoffeeOrder order) onSaveOrder;
  final VoidCallback onCompleteRun;

  const CoffeeRunScreen({
    super.key,
    required this.currentOrders,
    required this.onAddOrder,
    required this.onRemoveOrder,
    required this.onSaveOrder,
    required this.onCompleteRun,
  });

  @override
  State<CoffeeRunScreen> createState() =>
      _CoffeeRunScreenState();
}

class _CoffeeRunScreenState
    extends State<CoffeeRunScreen> {
  final TextEditingController _nameController =
  TextEditingController();

  final TextEditingController _orderController =
  TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _orderController.dispose();

    super.dispose();
  }

  void _addOrder() {
    final name = _nameController.text.trim();
    final order = _orderController.text.trim();

    if (name.isEmpty || order.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter a coworker name and coffee order.',
          ),
        ),
      );

      return;
    }

    widget.onAddOrder(name, order);

    _nameController.clear();
    _orderController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Coworker Name',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _orderController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Coffee Order',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _addOrder,
              icon: const Icon(Icons.add),
              label: const Text('Add Order'),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: widget.currentOrders.isEmpty
                ? const Center(
              child: Text('No orders yet.'),
            )
                : ListView.builder(
              itemCount:
              widget.currentOrders.length,
              itemBuilder: (context, index) {
                final order =
                widget.currentOrders[index];

                return Card(
                  child: ListTile(
                    leading:
                    const Icon(Icons.coffee),
                    title: Text(
                      order.coworkerName,
                    ),
                    subtitle:
                    Text(order.order),
                    trailing:
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'save') {
                          widget.onSaveOrder(
                            order,
                          );
                        }

                        if (value ==
                            'delete') {
                          widget
                              .onRemoveOrder(
                            index,
                          );
                        }
                      },
                      itemBuilder:
                          (context) => const [
                        PopupMenuItem(
                          value: 'save',
                          child: Text(
                            'Save Order',
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Remove',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          if (widget.currentOrders.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed:
                widget.onCompleteRun,
                icon: const Icon(Icons.check),
                label: const Text(
                  'Complete Coffee Run',
                ),
              ),
            ),
        ],
      ),
    );
  }
}