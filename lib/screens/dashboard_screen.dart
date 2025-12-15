import 'package:flutter/material.dart';
import 'package:inventory/providers/inventory_provider.dart';
import 'package:inventory/widgets/pie_chart_widget.dart';
import 'package:inventory/widgets/responsive.dart';
import 'package:inventory/widgets/summary_card.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Consumer<InventoryProvider>(
        builder: (context, provider, child) {
          switch (provider.dataState) {
            case DataState.loading:
              return const Center(child: CircularProgressIndicator());
            case DataState.error:
              return Center(
                child: Text(
                  'Failed to load data: ${provider.errorMessage}',
                  textAlign: TextAlign.center,
                ),
              );
            case DataState.success:
              return _buildDashboardContent(context, provider);
          }
        },
      ),
    );
  }

  Widget _buildDashboardContent(
      BuildContext context, InventoryProvider provider) {
    if (provider.products.isEmpty) {
      return const Center(
        child: Text(
          'No products in inventory.\nGo to the Products tab to add some!',
          textAlign: TextAlign.center,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inventory Snapshot',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          _buildSummaryGrid(context, provider),
          const SizedBox(height: 24.0),
          Text(
            'Category Distribution',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            height: 300,
            child: CategoryPieChart(products: provider.products),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryGrid(BuildContext context, InventoryProvider provider) {
    final summaryItems = [
      {
        'title': 'Total Products',
        'value': provider.totalProducts.toString(),
        'icon': Icons.inventory_2_outlined,
        'color': Colors.blue,
      },
      {
        'title': 'Total Quantity',
        'value': provider.totalQuantity.toString(),
        'icon': Icons.format_list_numbered,
        'color': Colors.green,
      },
      {
        'title': 'Low Stock',
        'value':
            provider.products.where((p) => p.isLowStock).length.toString(),
        'icon': Icons.warning_amber_outlined,
        'color': Colors.orange,
      },
      {
        'title': 'Out of Stock',
        'value': provider.outOfStockProducts.toString(),
        'icon': Icons.error_outline,
        'color': Colors.red,
      },
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: Responsive.isMobile(context) ? 1.2 : 1.5,
      ),
      itemCount: summaryItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = summaryItems[index];
        return SummaryCard(
          title: item['title'] as String,
          value: item['value'] as String,
          icon: item['icon'] as IconData,
          color: item['color'] as Color,
        );
      },
    );
  }
}

