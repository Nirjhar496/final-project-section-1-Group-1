import 'package:flutter/material.dart';
import 'package:inventory/models/product.dart';
import 'package:inventory/widgets/product_detail_modal.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Hero(
          tag: 'product-image-${product.id}',
          child: CircleAvatar(
            backgroundImage:
                product.imageUrl.isNotEmpty ? NetworkImage(product.imageUrl) : null,
            child: product.imageUrl.isEmpty
                ? const Icon(Icons.inventory_2_outlined)
                : null,
          ),
        ),
        title: Text(product.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(product.category),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Qty: ${product.quantity}'),
            if (product.isLowStock)
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.orange, size: 16)
          ],
        ),
        onTap: () => _showProductDetails(context, product),
      ),
    );
  }

  void _showProductDetails(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ProductDetailModal(product: product),
    );
  }
}
