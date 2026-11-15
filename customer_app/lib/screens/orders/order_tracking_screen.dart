import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_theme.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  static const statuses = [
    'Order Placed',
    'Order Confirmed',
    'Preparing Order',
    'Ready for Pickup',
    'Out for Delivery',
    'Delivered',
  ];

  Map<String, dynamic>? _order;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _load();
    _subscribe();
  }

  Future<void> _load() async {
    final data = await Supabase.instance.client
        .from('orders')
        .select()
        .eq('id', widget.orderId)
        .maybeSingle();
    if (mounted) setState(() => _order = data);
  }

  void _subscribe() {
    _channel = Supabase.instance.client
        .channel('order-${widget.orderId}')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'orders',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: widget.orderId,
          ),
          callback: (payload) {
            setState(() => _order = payload.newRecord);
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    if (_channel != null) {
      Supabase.instance.client.removeChannel(_channel!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStatus = _order?['status'] ?? 'Order Placed';
    final currentIndex = statuses.indexOf(currentStatus);
    final isCancelled = currentStatus == 'Cancelled';

    return Scaffold(
      appBar: AppBar(title: const Text('Track Order')),
      body: _order == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Order #${widget.orderId.length > 8 ? widget.orderId.substring(0, 8).toUpperCase() : widget.orderId}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
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
                              fontWeight: isCurrent
                                  ? FontWeight.bold
                                  : FontWeight.normal,
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
            ),
    );
  }
}
