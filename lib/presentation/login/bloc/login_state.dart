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
