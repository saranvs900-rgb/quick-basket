import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  Future<void> _updateStatus(String status) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
      'statusHistory': FieldValue.arrayUnion([
        {'status': status, 'at': Timestamp.now()}
      ]),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          final address = data['address'] as Map<String, dynamic>? ?? {};
          final status = data['status'] ?? '';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Status: $status',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text('Delivery Address',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              Text(address['fullAddress'] ?? 'N/A'),
              const SizedBox(height: 24),
              const Text('Update Status',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (status != 'Out for Delivery' && status != 'Delivered')
                    ElevatedButton(
                      onPressed: () => _updateStatus('Out for Delivery'),
                      child: const Text('Out for Delivery'),
                    ),
                  if (status == 'Out for Delivery')
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () => _updateStatus('Delivered'),
                      child: const Text('Mark Delivered'),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
