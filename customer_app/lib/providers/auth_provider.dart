import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  Session? get session => _supabase.auth.currentSession;
  User? get user => _supabase.auth.currentUser;
  bool get isLoggedIn => session != null;

  AuthProvider() {
    _supabase.auth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }

  /// Send OTP to phone (E.164 format, e.g. +919876543210)
  Future<void> signInWithPhone(String phone) async {
    await _supabase.auth.signInWithOtp(phone: phone);
  }

  /// Verify the OTP received on phone
  Future<AuthResponse> verifyPhoneOtp({
    required String phone,
    required String token,
  }) async {
    final res = await _supabase.auth.verifyOTP(
      type: OtpType.sms,
      phone: phone,
      token: token,
    );
    notifyListeners();
    return res;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    notifyListeners();
  }
}
