import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

/// After we “send” the OTP
class AuthCodeSent extends AuthState {
  final String phone;
  const AuthCodeSent(this.phone);
  @override
  List<Object?> get props => [phone];
}

class Authenticated extends AuthState {
  final String userName; // mock user display name
  const Authenticated(this.userName);
  @override
  List<Object?> get props => [userName];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}
