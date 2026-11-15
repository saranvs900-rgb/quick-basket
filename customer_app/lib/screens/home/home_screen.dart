import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_theme.dart';
import '../product/product_list_screen.dart';
import '../product/product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text('QUICK BASKET', style: TextStyle(fontSize: 16)),
            Text(
              'Fresh Groceries. Fast Delivery.',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: open search
            },
          ),
          IconButton(
            icon: const Icon(Icons.location_on_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // Promo banner
          Container(
            margin: const EdgeInsets.all(16),
            height: 140,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Get 50% OFF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'on your first order',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),

          // Categories
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Shop by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 110,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .orderBy('order')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  // Fallback static categories
                  final cats = [
                    'Fruits',
                    'Vegetables',
                    'Dairy',
                    'Snacks',
                    'Beverages',
                    'Rice',
                    'Personal Care',
                    'Household',
                  ];
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: cats.length,
                    itemBuilder: (_, i) => _CategoryChip(
                      name: cats[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductListScreen(categoryName: cats[i]),
                        ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    return _CategoryChip(
                      name: data['name'] ?? '',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductListScreen(
                            categoryId: docs[i].id,
                            categoryName: data['name'],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Popular Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('products')
                .where('isActive', isEqualTo: true)
                .limit(10)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final products = snapshot.data!.docs;
              if (products.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No products yet. Add some from Admin Dashboard.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length,
                itemBuilder: (_, i) {
                  final data = products[i].data() as Map<String, dynamic>;
                  return _ProductCard(
                    id: products[i].id,
                    name: data['name'] ?? '',
                    price: (data['price'] ?? 0).toDouble(),
                    mrp: (data['mrp'] ?? 0).toDouble(),
                    unit: data['unit'] ?? '',
                    imageUrl: (data['imageUrls'] as List?)?.isNotEmpty == true
                        ? data['imageUrls'][0]
                        : null,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const _CategoryChip({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.category, color: AppColors.primary),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final double mrp;
  final String unit;
  final String? imageUrl;

  const _ProductCard({
    required this.id,
    required this.name,
    required this.price,
    required this.mrp,
    required this.unit,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: id),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade100,
                child: imageUrl != null
                    ? Image.network(imageUrl!, fit: BoxFit.cover)
                    : const Icon(Icons.image, size: 48, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(unit,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₹${price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      if (mrp > price) ...[
                        const SizedBox(width: 6),
                        Text(
                          '₹${mrp.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
