import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory/models/product.dart';
import 'package:inventory/providers/inventory_provider.dart';
import 'package:inventory/widgets/add_edit_product_sheet.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'mocks.mocks.dart';

void main() {
  group('AddEditProductSheet', () {
    late MockInventoryProvider mockInventoryProvider;

    setUp(() {
      mockInventoryProvider = MockInventoryProvider();
    });

    Future<void> pumpWidget(WidgetTester tester, {Product? product}) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<InventoryProvider>.value(
          value: mockInventoryProvider,
          child: MaterialApp(
            home: Scaffold(
              body: AddEditProductSheet(product: product),
            ),
          ),
        ),
      );
    }

    testWidgets('shows validation errors for empty fields',
        (WidgetTester tester) async {
      await pumpWidget(tester);

      // Tap the save button without entering any data
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Check for validation messages
      expect(find.text('Please enter a name.'), findsOneWidget);
      expect(find.text('Please enter a valid quantity.'), findsOneWidget);
      expect(find.text('Please enter a category.'), findsOneWidget);

      // Verify that addProduct was not called
      verifyNever(mockInventoryProvider.addProduct(any));
    });

    testWidgets('calls addProduct when form is valid',
        (WidgetTester tester) async {
      when(mockInventoryProvider.addProduct(any))
          .thenAnswer((_) async => Future.value());
      await pumpWidget(tester);

      // Enter valid data
      await tester.enterText(
          find.byWidgetPredicate((widget) =>
              widget is TextField && widget.decoration?.labelText == 'Product Name'),
          'Test Product');
      await tester.enterText(
          find.byWidgetPredicate((widget) =>
              widget is TextField && widget.decoration?.labelText == 'Quantity'),
          '10');
      await tester.enterText(
          find.byWidgetPredicate((widget) =>
              widget is TextField && widget.decoration?.labelText == 'Category'),
          'Test Category');

      // Tap the save button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify that addProduct was called
      verify(mockInventoryProvider.addProduct(any)).called(1);
    });
  });
}
