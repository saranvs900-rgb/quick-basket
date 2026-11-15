import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_theme.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatelessWidget {
  final String? categoryId;
  final String categoryName;

  const ProductListScreen({
    super.key,
    this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('products')
        .where('isActive', isEqualTo: true);

    if (categoryId != null) {
      query = query.where('categoryId', isEqualTo: categoryId);
    }

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No products found'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: data['imageUrls'] != null &&
                          (data['imageUrls'] as List).isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            data['imageUrls'][0],
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.image),
                  title: Text(data['name'] ?? ''),
                  subtitle: Text(
                    '₹${(data['price'] ?? 0).toStringAsFixed(0)} • ${data['unit'] ?? ''}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailScreen(productId: docs[i].id),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
