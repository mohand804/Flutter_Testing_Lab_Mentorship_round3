import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

void main() {
  group('Shopping Cart', () {
    testWidgets('Add item to cart', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Total Items: 0'), findsOneWidget);

      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      expect(find.text('Total Items: 1'), findsOneWidget);
      expect(find.text('Apple iPhone'), findsOneWidget);
      expect(find.text('Cart is empty'), findsNothing);
    });

    testWidgets('Delete item from cart', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      expect(find.text('Total Items: 1'), findsOneWidget);
      expect(find.text('Apple iPhone'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Total Items: 0'), findsOneWidget);
      expect(find.text('Apple iPhone'), findsNothing);
    });

    testWidgets('Calculate total amount with discount', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      expect(find.text('Subtotal: \$999.99'), findsOneWidget);
      expect(find.text('Total Discount: \$100.00'), findsOneWidget);
      expect(find.text('Total Amount: \$899.99'), findsOneWidget);

      await tester.tap(find.text('Add Galaxy'));
      await tester.pump();

      expect(find.text('Subtotal: \$1899.98'), findsOneWidget);
      expect(find.text('Total Discount: \$235.00'), findsOneWidget);
      expect(find.text('Total Amount: \$1664.98'), findsOneWidget);
    });

    testWidgets('Multiple quantity changes calculate correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pump();

      expect(find.text('Total Items: 3'), findsOneWidget);
      expect(find.text('Total Amount: \$2699.97'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove).first);
      await tester.pump();

      expect(find.text('Total Items: 2'), findsOneWidget);
      expect(find.text('Total Amount: \$1799.98'), findsOneWidget);
    });

    testWidgets('100% discount makes item free', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      await tester.tap(find.text('Add Free Sample'));
      await tester.pump();

      expect(find.text('Subtotal: \$50.00'), findsOneWidget);
      expect(find.text('Total Discount: \$50.00'), findsOneWidget);
      expect(find.text('Total Amount: \$0.00'), findsOneWidget);
      expect(find.text('Discount: 100%'), findsOneWidget);
    });

    testWidgets('Empty cart has zero totals', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCart())),
      );

      expect(find.text('Total Items: 0'), findsOneWidget);
      expect(find.text('Subtotal: \$0.00'), findsOneWidget);
      expect(find.text('Total Discount: \$0.00'), findsOneWidget);
      expect(find.text('Cart is empty'), findsOneWidget);
    });
  });
}
