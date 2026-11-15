import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../home/main_shell.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;

  const OrderConfirmationScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle,
                      size: 64, color: AppColors.success),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Order Placed!',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Order ID: ${orderId.substring(0, 8).toUpperCase()}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your fresh groceries will be delivered soon.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MainShell()),
                      (_) => false,
                    );
                  },
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
