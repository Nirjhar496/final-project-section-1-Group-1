
import 'package:flutter/foundation.dart';

class Product {
  String id;
  String name;
  int quantity;
  String category;
  String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.imageUrl,
  });
}
