import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'products_screen.dart';
import 'orders_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Basket Admin'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF2E7D32)),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text('Products'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Orders'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminOrdersScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dashboard Overview',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _StatCard(
                    title: 'Total Orders',
                    stream: FirebaseFirestore.instance
                        .collection('orders')
                        .snapshots(),
                    icon: Icons.shopping_bag,
                    color: Colors.blue,
                  ),
                  _StatCard(
                    title: 'Products',
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                    icon: Icons.inventory,
                    color: Colors.orange,
                  ),
                  _StatCard(
                    title: 'Customers',
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('role', isEqualTo: 'customer')
                        .snapshots(),
                    icon: Icons.people,
                    color: Colors.purple,
                  ),
                  _StatCard(
                    title: 'Delivery Partners',
                    stream: FirebaseFirestore.instance
                        .collection('delivery_partners')
                        .snapshots(),
                    icon: Icons.delivery_dining,
                    color: Colors.teal,
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

class _StatCard extends StatelessWidget {
  final String title;
  final Stream<QuerySnapshot> stream;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.stream,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          final count = snapshot.data?.docs.length ?? 0;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 32, color: color),
                const Spacer(),
                Text('$count',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold)),
                Text(title, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }
}
