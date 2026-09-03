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
}
