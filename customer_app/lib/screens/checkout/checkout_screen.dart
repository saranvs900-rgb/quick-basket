import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';
import '../orders/order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  bool _loading = false;

  Future<void> _placeOrder() async {
    final cart = context.read<CartProvider>();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || cart.itemCount == 0) return;
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter delivery address')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final orderRef = FirebaseFirestore.instance.collection('orders').doc();
      final items = cart.items.values
          .map((e) => {
                'productId': e.productId,
                'name': e.name,
                'price': e.price,
                'quantity': e.quantity,
                'imageUrl': e.imageUrl,
              })
          .toList();

      await orderRef.set({
        'userId': user.uid,
        'items': items,
        'totalAmount': cart.subtotal,
        'deliveryFee': cart.deliveryFee,
        'discount': 0,
        'finalAmount': cart.grandTotal,
        'status': 'Order Placed',
        'address': {
          'fullAddress': _addressController.text.trim(),
        },
        'paymentId': null,
        'deliveryPartnerId': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'statusHistory': [
          {
            'status': 'Order Placed',
            'at': FieldValue.serverTimestamp(),
          }
        ],
      });

      cart.clear();

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(orderId: orderRef.id),
        ),
        (route) => route.isFirst,
      );
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Delivery Address',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _addressController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'House no, Street, Area, City',
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Payment Method',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.money, color: AppColors.primary),
              title: const Text('Cash on Delivery'),
              trailing: Radio(value: true, groupValue: true, onChanged: (_) {}),
            ),
          ),
          // Placeholder for Razorpay
          Card(
            child: ListTile(
              leading: const Icon(Icons.payment, color: Colors.blue),
              title: const Text('Pay Online (Razorpay)'),
              subtitle: const Text('Coming soon - add keys to enable'),
              trailing: const Icon(Icons.lock_outline),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Configure Razorpay keys to enable')),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Items Total'),
                      Text('₹${cart.subtotal.toStringAsFixed(0)}'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Delivery Fee'),
                      Text(cart.deliveryFee == 0
                          ? 'FREE'
                          : '₹${cart.deliveryFee.toStringAsFixed(0)}'),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('To Pay',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        '₹${cart.grandTotal.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loading ? null : _placeOrder,
            child: _loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Place Order'),
          ),
        ],
      ),
    );
  }
}
