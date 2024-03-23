abstract class AccountState {}

class AccountInitialState extends AccountState {}

class AccountAuthenticatedState extends AccountState {}

class AccountErrorState extends AccountState {
  final String error;
  AccountErrorState(this.error);
}
