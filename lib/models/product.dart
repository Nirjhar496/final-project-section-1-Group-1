import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class Product {
  final String id;
  final String name;
  final int quantity;
  final String category;
  final String imageUrl;
  final Timestamp createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    required this.imageUrl,
    required this.createdAt,
  });

  // Factory constructor to create a Product from a Firestore document.
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Product(
      id: doc.id,
      name: data['name'] as String? ?? '',
      quantity: data['quantity'] as int? ?? 0,
      category: data['category'] as String? ?? 'General',
      imageUrl: data['imageUrl'] as String? ?? '',
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  // Factory constructor for creating a new, empty product.
  factory Product.initial() {
    return Product(
      id: '',
      name: '',
      quantity: 0,
      category: 'General',
      imageUrl: '',
      createdAt: Timestamp.now(),
    );
  }

  // Method to convert a Product object into a Map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'category': category,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }

  // Method to create a copy of the Product with updated fields.
  Product copyWith({
    String? id,
    String? name,
    int? quantity,
    String? category,
    String? imageUrl,
    Timestamp? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Getter to check if the product is out of stock.
  bool get isOutOfStock => quantity == 0;

  // Getter to check if the product stock is low.
  bool get isLowStock => quantity > 0 && quantity <= 5;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'Product{id: $id, name: $name, quantity: $quantity}';
  }
}