import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:financial_goals/src/modules/transaction/model/transaction_model.dart';
import 'package:signals/signals.dart';

class TransactionStore {
  final transactions = signal(<DocumentFirestoreModel<TransactionModel>>[]);
}
