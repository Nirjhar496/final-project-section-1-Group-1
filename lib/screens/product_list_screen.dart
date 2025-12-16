import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:inventory/providers/inventory_provider.dart';
import 'package:inventory/widgets/add_edit_product_sheet.dart';
import 'package:inventory/widgets/product_grid_item.dart';
import 'package:inventory/widgets/product_list_item.dart';
import 'package:inventory/widgets/responsive.dart';
import 'package:provider/provider.dart';
import 'package:inventory/models/product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddEditSheet({Product? product}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddEditProductSheet(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddEditSheet,
        label: const Text('Add Product'),
        icon: const Icon(Icons.add),
        heroTag: 'add-product-fab',
      ),
      body: Consumer<InventoryProvider>(
        builder: (context, provider, child) {
          switch (provider.dataState) {
            case DataState.loading:
              return const Center(child: CircularProgressIndicator());
            case DataState.error:
              return Center(child: Text('Error: ${provider.errorMessage}'));
            case DataState.success:
              return _buildProductList(context, provider);
          }
        },
      ),
    );
  }

  Widget _buildProductList(BuildContext context, InventoryProvider provider) {
    final filteredProducts =
        provider.getFilteredProducts(_searchController.text, _selectedCategory);

    if (provider.products.isEmpty) {
      return const Center(
        child: Text(
          'No products yet. Tap "Add Product" to start!',
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: [
        _buildFilterControls(provider),
        Expanded(
          child: filteredProducts.isEmpty
              ? const Center(child: Text('No products found.'))
              : Responsive(
                  mobile: _ProductListView(products: filteredProducts),
                  tablet: _ProductGridView(products: filteredProducts),
                ),
        ),
      ],
    );
  }

  Padding _buildFilterControls(InventoryProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search by name',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration:
                      const InputDecoration(labelText: 'Filter by category'),
                  items: provider.categories
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedCategory = value!),
                ),
              ),
              if (_selectedCategory != 'All')
                IconButton(
                  icon: const Icon(Icons.clear_all),
                  onPressed: () => setState(() => _selectedCategory = 'All'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductListView extends StatelessWidget {
  final List<Product> products;

  const _ProductListView({required this.products});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: ProductListItem(product: products[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductGridView extends StatelessWidget {
  final List<Product> products;

  const _ProductGridView({required this.products});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Responsive.isTablet(context) ? 3 : 4,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        padding: const EdgeInsets.all(16.0),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: Responsive.isTablet(context) ? 3 : 4,
            duration: const Duration(milliseconds: 375),
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: ProductGridItem(product: products[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

