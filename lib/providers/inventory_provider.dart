import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/firebase_service.dart';

enum DataState { loading, success, error }

class InventoryProvider with ChangeNotifier {
  final FirebaseService _firebaseService;
  List<Product> _products = [];
  StreamSubscription<List<Product>>? _productsSubscription;

  DataState _dataState = DataState.loading;
  String? _errorMessage;

  List<Product> get products => _products;
  DataState get dataState => _dataState;
  String? get errorMessage => _errorMessage;

  InventoryProvider(this._firebaseService) {
    _fetchProductsStream();
  }

  int get totalProducts => _products.length;

  int get totalQuantity {
    return _products.fold(0, (sum, product) => sum + product.quantity);
  }

  int get outOfStockProducts {
    return _products.where((p) => p.quantity == 0).length;
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

  int get lowStockProductCount {
    return _products.where((p) => p.isLowStock).length;
  }

  int get categoryCount {
    return categories.length - 1; // Exclude 'All'
  }

  List<Product> getFilteredProducts(String searchQuery, String category) {
    return _products.where((product) {
      final nameMatches =
          product.name.toLowerCase().contains(searchQuery.toLowerCase());
      final categoryMatches =
          category == 'All' || product.category == category;
      return nameMatches && categoryMatches;
    }).toList();
  }

  void _fetchProductsStream() {
    _dataState = DataState.loading;
    notifyListeners();
    _productsSubscription?.cancel();
    _productsSubscription =
        _firebaseService.getProductsStream().listen((products) {
      _products = products;
      _dataState = DataState.success;
      _errorMessage = null;
      notifyListeners();
    }, onError: (error) {
      _products = [];
      _errorMessage = error.toString();
      _dataState = DataState.error;
      notifyListeners();
    });
  }

  Future<void> addProduct(Product product) async {
    try {
      await _firebaseService.addProduct(product);
    } catch (e) {
      // The stream will update the UI, but we can handle specific errors here if needed
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _firebaseService.updateProduct(product);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firebaseService.deleteProduct(productId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _productsSubscription?.cancel();
    super.dispose();
  }
}