abstract class PurchaseState {}

class PurchaseInitialState extends PurchaseState {}

class PurchaseLoadingState extends PurchaseState {}

class PurchasePremiumState extends PurchaseState {}

class PurchaseErrorState extends PurchaseState {
  final String error;
  PurchaseErrorState(this.error);
}
