import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: FutureBuilder(
        future: supabase
            .from('products')
            .select()
            .eq('id', productId)
            .maybeSingle(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data;
          if (data == null) {
            return const Center(child: Text('Product not found'));
          }

          final name = data['name'] ?? '';
          final price = (data['price'] ?? 0).toDouble();
          final mrp = (data['mrp'] ?? 0).toDouble();
          final unit = data['unit'] ?? '';
          final description = data['description'] ?? '';
          final images = data['image_urls'] as List? ?? [];
          final imageUrl = images.isNotEmpty ? images[0] as String : null;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      height: 280,
                      color: Colors.grey.shade100,
                      child: imageUrl != null
                          ? Image.network(imageUrl, fit: BoxFit.contain)
                          : const Icon(Icons.image, size: 80),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(unit,
                              style: const TextStyle(
                                  color: AppColors.textSecondary)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text('₹${price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary)),
                              if (mrp > price) ...[
                                const SizedBox(width: 10),
                                Text('₹${mrp.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: AppColors.textSecondary)),
                              ],
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text('Description',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16)),
                          const SizedBox(height: 6),
                          Text(
                            description.isEmpty
                                ? 'Fresh quality product delivered fast.'
                                : description,
                            style: const TextStyle(
                                color: AppColors.textSecondary, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<CartProvider>().addItem(
                              productId: productId,
                              name: name,
                              price: price,
                              imageUrl: imageUrl,
                              unit: unit,
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to cart'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Add to Cart'),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
