import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum OrderStatus {
  placed,
  confirmed,
  preparing,
  readyForPickup,
  outForDelivery,
  delivered,
  cancelled,
}

extension OrderStatusExt on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.preparing:
        return 'Preparing Order';
      case OrderStatus.readyForPickup:
        return 'Ready for Pickup';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  static OrderStatus fromString(String value) {
    switch (value) {
      case 'Order Confirmed':
        return OrderStatus.confirmed;
      case 'Preparing Order':
        return OrderStatus.preparing;
      case 'Ready for Pickup':
        return OrderStatus.readyForPickup;
      case 'Out for Delivery':
        return OrderStatus.outForDelivery;
      case 'Delivered':
        return OrderStatus.delivered;
      case 'Cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.placed;
    }
  }
}

class OrderItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;

  const OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}

class OrderModel extends Equatable {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final double deliveryFee;
  final double discount;
  final double finalAmount;
  final OrderStatus status;
  final Map<String, dynamic> address;
  final String? paymentId;
  final String? deliveryPartnerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Map<String, dynamic>> statusHistory;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.deliveryFee,
    required this.discount,
    required this.finalAmount,
    required this.status,
    required this.address,
    this.paymentId,
    this.deliveryPartnerId,
    required this.createdAt,
    required this.updatedAt,
    this.statusHistory = const [],
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      items: (data['items'] as List? ?? [])
          .map((e) => OrderItem.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      deliveryFee: (data['deliveryFee'] ?? 0).toDouble(),
      discount: (data['discount'] ?? 0).toDouble(),
      finalAmount: (data['finalAmount'] ?? 0).toDouble(),
      status: OrderStatusExt.fromString(data['status'] ?? 'Order Placed'),
      address: Map<String, dynamic>.from(data['address'] ?? {}),
      paymentId: data['paymentId'],
      deliveryPartnerId: data['deliveryPartnerId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      statusHistory: List<Map<String, dynamic>>.from(data['statusHistory'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': totalAmount,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'finalAmount': finalAmount,
      'status': status.displayName,
      'address': address,
      'paymentId': paymentId,
      'deliveryPartnerId': deliveryPartnerId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'statusHistory': statusHistory,
    };
  }

  @override
  List<Object?> get props => [id, status, finalAmount];
}
