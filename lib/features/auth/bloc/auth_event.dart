import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

/// User typed a phone and tapped “Send OTP”
class AuthPhoneSubmitted extends AuthEvent {
  final String phone; // e.g. +60...
  const AuthPhoneSubmitted(this.phone);
}

/// User entered the 6-digit OTP and tapped “Verify”
class AuthOtpSubmitted extends AuthEvent {
  final String phone;
  final String code; // 6 digits
  const AuthOtpSubmitted(this.phone, this.code);
}

/// Optional: sign out
class AuthSignedOut extends AuthEvent {
  const AuthSignedOut();
}
