import 'package:flutter/material.dart';
import 'package:inventory/models/product.dart';
import 'package:inventory/providers/inventory_provider.dart';
import 'package:inventory/widgets/add_edit_product_sheet.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductDetailModal extends StatelessWidget {
  final Product product;

  const ProductDetailModal({super.key, required this.product});

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(ctx).pop(); // Close dialog
              Navigator.of(context).pop(); // Close modal
              Provider.of<InventoryProvider>(context, listen: false)
                  .deleteProduct(product.id);
            },
          ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context) {
    Navigator.of(context).pop(); // Close current modal first
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddEditProductSheet(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return CustomScrollView(
          controller: controller,
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(product.name,
                    style: const TextStyle(color: Colors.white)),
                background: Hero(
                  tag: 'product-image-${product.id}',
                  child: product.imageUrl.isNotEmpty
                      ? Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 100),
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.inventory_2_outlined,
                              size: 100, color: Colors.grey),
                        ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _buildDetailRow(
                        context, 'Category', product.category, Icons.category),
                    const Divider(height: 32),
                    _buildDetailRow(context, 'Quantity',
                        product.quantity.toString(), Icons.format_list_numbered,
                        trailing: _buildStockStatusChip(product)),
                    const Divider(height: 32),
                    _buildDetailRow(
                        context,
                        'Date Added',
                        DateFormat.yMMMd().format(product.createdAt.toDate()),
                        Icons.calendar_today),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _showEditSheet(context),
                          icon: const Icon(Icons.edit_note),
                          label: const Text('Edit'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _showDeleteConfirmation(context),
                          icon: const Icon(Icons.delete_forever),
                          label: const Text('Delete'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.error,
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(
      BuildContext context, String title, String value, IconData icon,
      {Widget? trailing}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              Text(value, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Chip _buildStockStatusChip(Product product) {
    if (product.isOutOfStock) {
      return const Chip(
          label: Text('Out of Stock'), backgroundColor: Colors.red);
    } else if (product.isLowStock) {
      return const Chip(label: Text('Low Stock'), backgroundColor: Colors.orange);
    } else {
      return const Chip(label: Text('In Stock'), backgroundColor: Colors.green);
    }
  }
}
