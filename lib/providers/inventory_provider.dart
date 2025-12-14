
import 'package:flutter/foundation.dart';
import '../models/product.dart';

class InventoryProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(id: '1', name: 'Laptop', quantity: 10, category: 'Electronics'),
    Product(id: '2', name: 'Keyboard', quantity: 25, category: 'Electronics'),
    Product(id: '3', name: 'Mouse', quantity: 50, category: 'Electronics'),
    Product(id: '4', name: 'T-Shirt', quantity: 100, category: 'Apparel'),
    Product(id: '5', name: 'Jeans', quantity: 75, category: 'Apparel'),
  ];

  List<Product> get products => _products;

  // Get filtered and searched products
  List<Product> getFilteredProducts(String query, String category) {
    List<Product> filteredProducts = _products;

    if (category != 'All') {
      filteredProducts = filteredProducts
          .where((product) => product.category == category)
          .toList();
    }

    if (query.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    return filteredProducts;
  }

  // Add a new product
  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  // Update an existing product
  void updateProduct(Product updatedProduct) {
    final index = _products.indexWhere((product) => product.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  // Delete a product
  void deleteProduct(String id) {
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  // Get total number of products
  int get totalProducts => _products.length;

  // Get total quantity of all products
  int get totalQuantity {
    return _products.fold(0, (sum, product) => sum + product.quantity);
  }

  // Get a list of unique categories
  List<String> get categories {
    final categories = _products.map((product) => product.category).toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }
}
