import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gemini_ai/service/auth.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthServices authServices;
  LoginBloc(this.authServices) : super(LoginInitial()) {
    on<SignInWithGoogleEvent>(signInWithGoogleEvent);
  }

  void signInWithGoogleEvent(
      SignInWithGoogleEvent event, Emitter<LoginState> emitter) async {
    try {
      final isSignIn = await authServices.signInWithGoogle();
      if (isSignIn) {
        emitter.call(const LoginSuccessState(successMsg: 'LoggedIn'));
      } else {
        emitter.call(
            const LoginFailureState(errorMsg: 'Error while google sign-in'));
      }
    } catch (e) {
      emitter.call(LoginFailureState(errorMsg: '$e'));
    }
  }
}
