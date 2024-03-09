abstract class CreateTransactionState {}

class CreateTransactionInitialState extends CreateTransactionState {}

class CreateTransactionLoadingState extends CreateTransactionState {}

class CreateTransactionSuccessState extends CreateTransactionState {}

class CreateTransactionErrorState extends CreateTransactionState {
  String error;
  CreateTransactionErrorState(this.error);
}
