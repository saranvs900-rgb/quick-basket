import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  Future<void> _updateStatus(String orderId, String status) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _assignPartner(String orderId, String partnerId) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'deliveryPartnerId': partnerId,
      'status': 'Ready for Pickup',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              final status = data['status'] ?? '';
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  title: Text(
                      'Order #${docs[i].id.substring(0, 8).toUpperCase()}'),
                  subtitle: Text('$status • ₹${data['finalAmount']}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Address: ${(data['address'] as Map?)?['fullAddress'] ?? 'N/A'}'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: [
                              ElevatedButton(
                                onPressed: () =>
                                    _updateStatus(docs[i].id, 'Order Confirmed'),
                                child: const Text('Confirm'),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    _updateStatus(docs[i].id, 'Preparing Order'),
                                child: const Text('Preparing'),
                              ),
                              ElevatedButton(
                                onPressed: () => _updateStatus(
                                    docs[i].id, 'Ready for Pickup'),
                                child: const Text('Ready'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                onPressed: () =>
                                    _updateStatus(docs[i].id, 'Cancelled'),
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Simple assign - in production show a dropdown of partners
                          ElevatedButton.icon(
                            onPressed: () async {
                              // For demo: assign to first available partner
                              final partners = await FirebaseFirestore.instance
                                  .collection('delivery_partners')
                                  .limit(1)
                                  .get();
                              if (partners.docs.isNotEmpty) {
                                await _assignPartner(
                                    docs[i].id, partners.docs.first.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Partner assigned')),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.person_add),
                            label: const Text('Assign Delivery Partner'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
