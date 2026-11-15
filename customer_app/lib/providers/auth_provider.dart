import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get user => _auth.currentUser;
  bool get isLoggedIn => user != null;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithPhone({
    required String phone,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
        notifyListeners();
      },
      verificationFailed: (e) => onError(e.message ?? 'Verification failed'),
      codeSent: (verificationId, _) => onCodeSent(verificationId),
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<UserCredential?> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final result = await _auth.signInWithCredential(credential);
    await _ensureUserDocument(result.user!);
    notifyListeners();
    return result;
  }

  Future<void> _ensureUserDocument(User user) async {
    final ref = _db.collection('users').doc(user.uid);
    final snap = await ref.get();
    if (!snap.exists) {
      await ref.set({
        'uid': user.uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'phone': user.phoneNumber ?? '',
        'role': 'customer',
        'createdAt': FieldValue.serverTimestamp(),
        'fcmTokens': [],
      });
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
