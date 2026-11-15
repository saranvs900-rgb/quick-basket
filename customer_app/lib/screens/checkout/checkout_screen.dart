import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || cart.itemCount == 0) return;
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter delivery address')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final supabase = Supabase.instance.client;

      // 1. Create order
      final order = await supabase.from('orders').insert({
        'user_id': user.id,
        'status': 'Order Placed',
        'total_amount': cart.subtotal,
        'delivery_fee': cart.deliveryFee,
        'discount': 0,
        'final_amount': cart.grandTotal,
        'address': {'fullAddress': _addressController.text.trim()},
      }).select().single();

      final orderId = order['id'] as String;

      // 2. Create order items
      final items = cart.items.values
          .map((e) => {
                'order_id': orderId,
                'product_id': e.productId,
                'name': e.name,
                'price': e.price,
                'quantity': e.quantity,
                'image_url': e.imageUrl,
              })
          .toList();

      await supabase.from('order_items').insert(items);

      cart.clear();

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(orderId: orderId),
        ),
        (route) => route.isFirst,
      );
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order: $e')),
        );
      }
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
          const Text('Delivery Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _addressController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'House no, Street, Area, City',
            ),
          ),
          const SizedBox(height: 24),
          const Text('Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.money, color: AppColors.primary),
              title: const Text('Cash on Delivery'),
              trailing: Radio(value: true, groupValue: true, onChanged: (_) {}),
            ),
          ),
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
                      Text('₹${cart.grandTotal.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.primary)),
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
