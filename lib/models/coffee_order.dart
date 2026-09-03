// lib/models/coffee_order.dart

class CoffeeOrder {
  final String coworkerName;
  final String order;

  CoffeeOrder({required this.coworkerName, required this.order});

  Map<String, dynamic> toJson() {
    return {'coworkerName': coworkerName, 'order': order};
  }

  factory CoffeeOrder.fromJson(Map<String, dynamic> json) {
    final coworkerName = json['coworkerName'];
    final order = json['order'];

    if (coworkerName is! String || order is! String) {
      throw const FormatException('Invalid coffee order data.');
    }

    return CoffeeOrder(coworkerName: coworkerName, order: order);
  }
}
