import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';
import 'order_tracking_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Scaffold(body: Center(child: Text('Please login')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No orders yet',
                  style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (_, i) {
              final doc = snapshot.data!.docs[i];
              final data = doc.data() as Map<String, dynamic>;
              final status = data['status'] ?? 'Order Placed';
              final amount = (data['finalAmount'] ?? 0).toDouble();

              return Card(
                child: ListTile(
                  title: Text('Order #${doc.id.substring(0, 8).toUpperCase()}'),
                  subtitle: Text(status),
                  trailing: Text(
                    '₹${amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderTrackingScreen(orderId: doc.id),
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
