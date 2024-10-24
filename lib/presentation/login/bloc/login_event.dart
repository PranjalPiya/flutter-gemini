part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressedEvent extends LoginEvent {}

class SignInWithGoogleEvent extends LoginEvent {}

class LogoutButtonPressedEvent extends LoginEvent {}
