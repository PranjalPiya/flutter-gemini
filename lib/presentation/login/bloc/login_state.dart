part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoadingState extends LoginState {}

final class LoginSuccessState extends LoginState {
  final String? successMsg;
  final dynamic successResponse;
  const LoginSuccessState({required this.successMsg, this.successResponse});
}

final class LoginFailureState extends LoginState {
  final String? errorMsg;

  const LoginFailureState({required this.errorMsg});
}

final class GoogleSignInLoadingState extends LoginState {}

final class GoogleSignInSuccessState extends LoginState {
  final String? successMsg;
  final dynamic successResponse;

  const GoogleSignInSuccessState(
      {required this.successMsg, this.successResponse});
}

final class GoogleSignInFailedState extends LoginState {
  final String? errorMsg;

  const GoogleSignInFailedState({required this.errorMsg});
}

final class LogoutLoadingState extends LoginState {}

final class LogoutSuccessState extends LoginState {
  final String? successMsg;

  const LogoutSuccessState({required this.successMsg});
}

final class LogoutFailedState extends LoginState {
  final String? errorMsg;

  const LogoutFailedState({required this.errorMsg});
}
