import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    final supabase = Supabase.instance.client;

    var query = supabase.from('products').select().eq('is_active', true);
    if (categoryId != null) {
      query = query.eq('category_id', categoryId!);
    }

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: FutureBuilder(
        future: query.then((v) => List<Map<String, dynamic>>.from(v)),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!;
          if (docs.isEmpty) {
            return const Center(child: Text('No products found'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final data = docs[i];
              final images = data['image_urls'] as List? ?? [];
              return Card(
                child: ListTile(
                  leading: images.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(images[0],
                              width: 56, height: 56, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.image),
                  title: Text(data['name'] ?? ''),
                  subtitle: Text(
                      '₹${(data['price'] ?? 0).toStringAsFixed(0)} • ${data['unit'] ?? ''}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailScreen(productId: data['id']),
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
