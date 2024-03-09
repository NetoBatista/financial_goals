abstract class UpdateTransactionState {}

class UpdateTransactionInitialState extends UpdateTransactionState {}

class UpdateTransactionLoadingState extends UpdateTransactionState {}

class UpdateTransactionSuccessState extends UpdateTransactionState {}

class UpdateTransactionErrorState extends UpdateTransactionState {
  String error;
  UpdateTransactionErrorState(this.error);
}
