abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthErrorState extends AuthState {
  String error;
  AuthErrorState(this.error);
}
