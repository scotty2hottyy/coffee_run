// lib/screens/coffee_run_screen.dart

import 'package:flutter/material.dart';

import '../models/coffee_order.dart';

class CoffeeRunScreen extends StatefulWidget {
  final List<CoffeeOrder> currentOrders;

  final void Function(String name, String order, double price) onAddOrder;
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
  State<CoffeeRunScreen> createState() => _CoffeeRunScreenState();
}

class _CoffeeRunScreenState extends State<CoffeeRunScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _orderController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _orderController.dispose();
    _priceController.dispose();

    super.dispose();
  }

  void _addOrder() {
    final name = _nameController.text.trim();
    final order = _orderController.text.trim();
    final priceText = _priceController.text.trim();
    final price = double.tryParse(priceText);

    if (name.isEmpty ||
        order.isEmpty ||
        price == null ||
        !price.isFinite ||
        price < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter a coworker name, coffee order, and valid price.',
          ),
        ),
      );

      return;
    }

    widget.onAddOrder(name, order, price);

    _nameController.clear();
    _orderController.clear();
    _priceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.currentOrders.fold<double>(
      0,
      (sum, order) => sum + order.price,
    );

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

          TextField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Price',
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
                ? const Center(child: Text('No orders yet.'))
                : ListView.builder(
                    itemCount: widget.currentOrders.length,
                    itemBuilder: (context, index) {
                      final order = widget.currentOrders[index];

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.coffee),
                          title: Text(order.coworkerName),
                          subtitle: Text(
                            '${order.order}\n\$${order.price.toStringAsFixed(2)}',
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'save') {
                                widget.onSaveOrder(order);
                              }

                              if (value == 'delete') {
                                widget.onRemoveOrder(index);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'save',
                                child: Text('Save Order'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Remove'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          if (widget.currentOrders.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

          if (widget.currentOrders.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: widget.onCompleteRun,
                icon: const Icon(Icons.check),
                label: const Text('Complete Coffee Run'),
              ),
            ),
        ],
      ),
    );
  }
}
