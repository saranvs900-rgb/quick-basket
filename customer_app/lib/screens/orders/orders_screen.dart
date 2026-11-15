import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_theme.dart';
import 'order_tracking_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Please login')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: FutureBuilder(
        future: Supabase.instance.client
            .from('orders')
            .select()
            .eq('user_id', user.id)
            .order('created_at', ascending: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = List<Map<String, dynamic>>.from(snapshot.data ?? []);
          if (docs.isEmpty) {
            return const Center(
              child: Text('No orders yet',
                  style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final data = docs[i];
              final id = data['id'] as String;
              final status = data['status'] ?? 'Order Placed';
              final amount = (data['final_amount'] ?? 0).toDouble();

              return Card(
                child: ListTile(
                  title: Text(
                      'Order #${id.length > 8 ? id.substring(0, 8).toUpperCase() : id}'),
                  subtitle: Text(status),
                  trailing: Text('₹${amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderTrackingScreen(orderId: id),
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
