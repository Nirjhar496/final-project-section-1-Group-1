import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/firebase_service.dart';

class InventoryProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Product> _products = [];
  StreamSubscription<List<Product>>? _productsSubscription;

  List<Product> get products => _products;

  InventoryProvider() {
    fetchProducts();
  }

  int get totalProducts => _products.length;

  int get totalQuantity {
    return _products.fold(0, (sum, product) => sum + product.quantity);
  }

  List<String> get categories {
    final List<String> categories = ['All'];
    for (var product in _products) {
      if (!categories.contains(product.category)) {
        categories.add(product.category);
      }
    }
    return categories;
  }

  List<Product> getFilteredProducts(String searchQuery, String category) {
    return _products.where((product) {
      final nameMatches = product.name.toLowerCase().contains(searchQuery.toLowerCase());
      final categoryMatches = category == 'All' || product.category == category;
      return nameMatches && categoryMatches;
    }).toList();
  }

  void fetchProducts() {
    _productsSubscription?.cancel();
    _productsSubscription = _firebaseService.getProducts().listen((products) {
      _products = products;
      notifyListeners();
    }, onError: (error) {
      // Handle errors, e.g., show a message to the user
      print("Error fetching products: $error");
    });
  }

  Future<void> addProduct(Product product) async {
    try {
      await _firebaseService.addProduct(product);
      // No need to manually add to _products, stream will update it
    } catch (e) {
      print("Error adding product: $e");
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _firebaseService.updateProduct(product);
    } catch (e) {
      print("Error updating product: $e");
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firebaseService.deleteProduct(productId);
    } catch (e) {
      print("Error deleting product: $e");
      rethrow;
    }
  }

  @override
  void dispose() {
    _productsSubscription?.cancel();
    super.dispose();
  }
}