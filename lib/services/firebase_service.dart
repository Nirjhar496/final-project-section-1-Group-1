import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collectionPath = 'products';

  late final CollectionReference<Product> _productsCollection;

  FirebaseService() {
    _productsCollection =
        _db.collection(_collectionPath).withConverter<Product>(
              fromFirestore: (snapshot, _) => Product.fromFirestore(snapshot),
              toFirestore: (product, _) => product.toMap(),
            );
  }

  // Fetch all products with real-time updates
  Stream<List<Product>> getProductsStream() {
    return _productsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      try {
        return snapshot.docs.map((doc) => doc.data()).toList();
      } catch (e) {
        // Log the error for debugging
        // Re-throw a more specific error
        throw Exception('Failed to parse product data.');
      }
    });
  }

  // Add a new product
  Future<void> addProduct(Product product) async {
    try {
      await _productsCollection.add(product);
    } on FirebaseException catch (e) {
      throw Exception('Error adding product: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred while adding the product.');
    }
  }

  // Update an existing product
  Future<void> updateProduct(Product product) async {
    try {
      await _productsCollection.doc(product.id).update(product.toMap());
    } on FirebaseException catch (e) {
      throw Exception('Error updating product: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred while updating the product.');
    }
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    try {
      await _productsCollection.doc(productId).delete();
    } on FirebaseException catch (e) {
      throw Exception('Error deleting product: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred while deleting the product.');
    }
  }
}