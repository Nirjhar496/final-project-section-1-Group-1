import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final int quantity;
  final String category;
  final String? imageUrl;
  final Timestamp createdAt;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.imageUrl,
    required this.createdAt,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      quantity: data['quantity'] ?? 0,
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'category': category,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }
}