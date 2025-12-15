import 'package:flutter/material.dart';
import 'package:inventory/models/product.dart';
import 'package:inventory/widgets/product_detail_modal.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;
  final Animation<double> animation;

  const ProductGridItem({
    super.key,
    required this.product,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _showProductDetails(context, product),
            child: GridTile(
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Qty: ${product.quantity}'),
                trailing: product.isLowStock
                    ? const Icon(Icons.warning_amber_rounded,
                        color: Colors.orange)
                    : null,
              ),
              child: Hero(
                tag: 'product-image-${product.id}',
                child: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          return progress == null
                              ? child
                              : const Center(
                                  child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 50);
                        },
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.inventory_2_outlined,
                            size: 50, color: Colors.grey),
                      ),
              ),
            ),
          ),
        ),
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
