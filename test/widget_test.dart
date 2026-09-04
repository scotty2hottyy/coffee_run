import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_run/main.dart';

void main() {
  testWidgets('Coffee Run app smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const CoffeeRunApp());
    await tester.pump();

    expect(find.text('Coffee Run'), findsWidgets);
    expect(find.text('No orders yet.'), findsOneWidget);
  });

  testWidgets('adds order with price and shows running total', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const CoffeeRunApp());
    await tester.pump();

    await tester.enterText(
      find.widgetWithText(TextField, 'Coworker Name'),
      'Scott',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Coffee Order'),
      'Large Latte',
    );
    await tester.enterText(find.widgetWithText(TextField, 'Price'), '5.75');
    await tester.tap(find.text('Add Order'));
    await tester.pump();

    expect(find.text('Scott'), findsOneWidget);
    expect(find.text('Large Latte\n\$5.75'), findsOneWidget);
    expect(find.text('Total: \$5.75'), findsOneWidget);
  });
}
