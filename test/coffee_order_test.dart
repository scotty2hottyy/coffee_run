import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_run/models/coffee_order.dart';

void main() {
  test('CoffeeOrder JSON serialization preserves price', () {
    final order = CoffeeOrder(
      coworkerName: 'Scott',
      order: 'Large Latte',
      price: 5.75,
    );

    final json = order.toJson();
    final decodedOrder = CoffeeOrder.fromJson(json);

    expect(json['price'], 5.75);
    expect(decodedOrder.coworkerName, 'Scott');
    expect(decodedOrder.order, 'Large Latte');
    expect(decodedOrder.price, 5.75);
  });

  test('CoffeeOrder.fromJson defaults missing legacy price to 0.0', () {
    final order = CoffeeOrder.fromJson({
      'coworkerName': 'Hope',
      'order': 'Caramel Latte',
    });

    expect(order.price, 0.0);
  });

  test('CoffeeOrder.fromJson defaults null legacy price to 0.0', () {
    final order = CoffeeOrder.fromJson({
      'coworkerName': 'Taylor',
      'order': 'Cold Brew',
      'price': null,
    });

    expect(order.price, 0.0);
  });

  test('CoffeeOrder.fromJson safely decodes integer and double prices', () {
    final integerPriceOrder = CoffeeOrder.fromJson({
      'coworkerName': 'Alex',
      'order': 'Drip Coffee',
      'price': 4,
    });
    final doublePriceOrder = CoffeeOrder.fromJson({
      'coworkerName': 'Jordan',
      'order': 'Mocha',
      'price': 4.5,
    });

    expect(integerPriceOrder.price, 4.0);
    expect(doublePriceOrder.price, 4.5);
  });
}
