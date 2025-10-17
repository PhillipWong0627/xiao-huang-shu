import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _secure = const FlutterSecureStorage();

  AuthBloc({bool initialAuthed = false})
      : super(
            initialAuthed ? const Authenticated('Mock User') : AuthInitial()) {
    on<AuthPhoneSubmitted>(_onPhoneSubmitted);
    on<AuthOtpSubmitted>(_onOtpSubmitted);
    on<AuthSignedOut>(_onSignedOut);
  }

  // Fake store for the last phone we "sent" to (to keep it simple)
  String? _lastPhone;

  Future<void> _onPhoneSubmitted(
    AuthPhoneSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (event.phone.trim().isEmpty || !event.phone.startsWith('+')) {
      emit(const AuthError('Please enter phone in E.164 format, e.g. +60...'));
      return;
    }
    emit(AuthLoading());
    // Mock sending SMS (delay to simulate network)
    await Future.delayed(const Duration(milliseconds: 800));
    _lastPhone = event.phone;
    emit(AuthCodeSent(event.phone));
  }

  Future<void> _onOtpSubmitted(
    AuthOtpSubmitted e,
    Emitter<AuthState> emit,
  ) async {
    if (_lastPhone == null || _lastPhone != e.phone) {
      emit(const AuthError('Phone number mismatch. Please request OTP again.'));
      return;
    }
    if (e.code.length != 6) {
      emit(const AuthError('Code must be 6 digits.'));
      return;
    }

    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 600));

    // 🔐 Fake verification rule:
    // Use 123456 as the “correct” OTP. Anything else fails.
    if (e.code == '123456') {
      await _secure.write(key: 'jwt', value: 'mock-token');
      emit(const Authenticated('Mock User'));
    } else {
      emit(const AuthError('Invalid code. Try 123456 for demo.'));
    }
  }

  Future<void> _onSignedOut(
    AuthSignedOut e,
    Emitter<AuthState> emit,
  ) async {
    await _secure.delete(key: 'jwt');
    emit(AuthInitial());
  }
}
