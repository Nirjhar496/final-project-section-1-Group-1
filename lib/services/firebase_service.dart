import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionPath = 'products';

  // Fetch all products with real-time updates
  Stream<List<Product>> getProducts() {
    return _db.collection(_collectionPath).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }

  // Add a new product
  Future<void> addProduct(Product product) async {
    try {
      await _db.collection(_collectionPath).add(product.toMap());
    } catch (e) {
      // Handle potential errors, e.g., by logging them
      print('Error adding product: $e');
      rethrow;
    }
  }

  // Update an existing product
  Future<void> updateProduct(Product product) async {
    try {
      await _db.collection(_collectionPath).doc(product.id).update(product.toMap());
    } catch (e) {
      print('Error updating product: $e');
      rethrow;
    }
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    try {
      await _db.collection(_collectionPath).doc(productId).delete();
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }
}