import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory/models/product.dart';
import 'package:inventory/providers/inventory_provider.dart';
import 'package:inventory/screens/dashboard_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../mocks.mocks.dart';

void main() {
  late MockInventoryProvider mockInventoryProvider;

  setUp(() {
    mockInventoryProvider = MockInventoryProvider();
    when(() => mockInventoryProvider.products).thenReturn([
      Product(
        id: '1',
        name: 'Test Product 1',
        quantity: 10,
        category: 'Category A',
        imageUrl: '',
        createdAt: Timestamp.now(),
      ),
      Product(
        id: '2',
        name: 'Test Product 2',
        quantity: 0,
        category: 'Category B',
        imageUrl: '',
        createdAt: Timestamp.now(),
      ),
      Product(
        id: '3',
        name: 'Test Product 3',
        quantity: 3,
        category: 'Category A',
        imageUrl: '',
        createdAt: Timestamp.now(),
      ),
    ]);
    when(() => mockInventoryProvider.totalProducts).thenReturn(3);
    when(() => mockInventoryProvider.totalQuantity).thenReturn(13);
    when(() => mockInventoryProvider.outOfStockProducts).thenReturn(1);
    when(() => mockInventoryProvider.lowStockProductCount).thenReturn(1);
  });

  Future<void> pumpDashboardScreen(WidgetTester tester) async {
    when(() => mockInventoryProvider.dataState).thenReturn(DataState.success);

    await tester.pumpWidget(
      ChangeNotifierProvider<InventoryProvider>.value(
        value: mockInventoryProvider,
        child: const MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );
  }

  testWidgets('DashboardScreen shows correct summary data',
      (WidgetTester tester) async {
    await pumpDashboardScreen(tester);

    // Let the UI build
    await tester.pump();

    // Verify the summary cards
    expect(find.text('Total Products'), findsOneWidget);
    expect(find.descendant(of: find.widgetWithText(Card, 'Total Products'), matching: find.text('3')), findsOneWidget);

    expect(find.text('Total Quantity'), findsOneWidget);
    expect(find.descendant(of: find.widgetWithText(Card, 'Total Quantity'), matching: find.text('13')), findsOneWidget);

    expect(find.text('Low Stock'), findsOneWidget);
    expect(find.descendant(of: find.widgetWithText(Card, 'Low Stock'), matching: find.text('1')), findsOneWidget);
    
    expect(find.text('Out of Stock'), findsOneWidget);
    expect(find.descendant(of: find.widgetWithText(Card, 'Out of Stock'), matching: find.text('1')), findsOneWidget);
  });

  testWidgets('DashboardScreen shows loading indicator',
      (WidgetTester tester) async {
    // Make the mock return loading state
    when(() => mockInventoryProvider.dataState).thenReturn(DataState.loading);

    await pumpDashboardScreen(tester);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('DashboardScreen shows error message',
      (WidgetTester tester) async {
    // Make the mock return error state
    when(() => mockInventoryProvider.dataState).thenReturn(DataState.error);
    when(() => mockInventoryProvider.errorMessage).thenReturn('Test Error');

    await pumpDashboardScreen(tester);
    await tester.pump();

    expect(find.text('Failed to load data: Test Error'), findsOneWidget);
  });
}
