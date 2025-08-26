import 'package:equatable/equatable.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool showPassword;
  final LoginStatus status;

  const LoginState({
    this.email = '',
    this.password = '',
    this.showPassword = false,
    this.status = LoginStatus.initial,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? showPassword,
    LoginStatus? status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [email, password, showPassword, status];
}
