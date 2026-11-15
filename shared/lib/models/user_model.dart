import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum UserRole { customer, admin, deliveryPartner }

class UserModel extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? photoUrl;
  final UserRole role;
  final DateTime createdAt;
  final List<String> fcmTokens;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
    required this.role,
    required this.createdAt,
    this.fcmTokens = const [],
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      photoUrl: data['photoUrl'],
      role: _roleFromString(data['role'] ?? 'customer'),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      fcmTokens: List<String>.from(data['fcmTokens'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'role': role.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'fcmTokens': fcmTokens,
    };
  }

  static UserRole _roleFromString(String value) {
    switch (value) {
      case 'admin':
        return UserRole.admin;
      case 'delivery_partner':
      case 'deliveryPartner':
        return UserRole.deliveryPartner;
      default:
        return UserRole.customer;
    }
  }

  @override
  List<Object?> get props => [uid, name, email, phone, role];
}
