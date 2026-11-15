import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_theme.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  static const statuses = [
    'Order Placed',
    'Order Confirmed',
    'Preparing Order',
    'Ready for Pickup',
    'Out for Delivery',
    'Delivered',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Order')),
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
          final currentStatus = data['status'] ?? 'Order Placed';
          final currentIndex = statuses.indexOf(currentStatus);
          final isCancelled = currentStatus == 'Cancelled';

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Order #${orderId.substring(0, 8).toUpperCase()}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                isCancelled ? 'Cancelled' : currentStatus,
                style: TextStyle(
                  color: isCancelled ? AppColors.error : AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              if (!isCancelled)
                ...List.generate(statuses.length, (i) {
                  final isDone = i <= currentIndex;
                  final isCurrent = i == currentIndex;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDone
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                            ),
                            child: isDone
                                ? const Icon(Icons.check,
                                    size: 14, color: Colors.white)
                                : null,
                          ),
                          if (i < statuses.length - 1)
                            Container(
                              width: 2,
                              height: 40,
                              color: isDone
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          statuses[i],
                          style: TextStyle(
                            fontWeight:
                                isCurrent ? FontWeight.bold : FontWeight.normal,
                            color: isDone
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}
