import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final double price;
  final double mrp;
  final String unit;
  final List<String> imageUrls;
  final int stock;
  final bool isActive;
  final List<String> tags;
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.price,
    required this.mrp,
    required this.unit,
    required this.imageUrls,
    required this.stock,
    required this.isActive,
    this.tags = const [],
    required this.createdAt,
  });

  double get discountPercent =>
      mrp > 0 ? ((mrp - price) / mrp * 100).roundToDouble() : 0;

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      categoryId: data['categoryId'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      mrp: (data['mrp'] ?? 0).toDouble(),
      unit: data['unit'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      stock: data['stock'] ?? 0,
      isActive: data['isActive'] ?? true,
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'price': price,
      'mrp': mrp,
      'unit': unit,
      'imageUrls': imageUrls,
      'stock': stock,
      'isActive': isActive,
      'tags': tags,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  @override
  List<Object?> get props => [id, name, price, stock];
}
