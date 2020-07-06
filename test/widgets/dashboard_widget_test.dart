import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../matchers/matchers.dart';

void main() {
  group('When dashboard is opened', () {
    testWidgets('Should display the main image when the dashboard is open',
        (WidgetTester tester) async {
      await initializeDashboard(tester);

      final mainImage = find.byType(Image);

      expect(mainImage, findsOneWidget);
    });

    testWidgets(
        'Should display the transfer feature when the Dashboard is open',
        (WidgetTester tester) async {
      await initializeDashboard(tester);

      expect(
          find.byWidgetPredicate((widget) =>
              featureItemMatcher(widget, 'Transfer', Icons.monetization_on)),
          findsOneWidget);
    });

    testWidgets(
        'Should display the transaction feed feature when the Dashboard is open',
        (WidgetTester tester) async {
      await initializeDashboard(tester);

      expect(
          find.byWidgetPredicate((widget) => featureItemMatcher(
              widget, 'Transaction feed', Icons.description)),
          findsOneWidget);
    });
  });
}

Future initializeDashboard(WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: Dashboard()));
}
