import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:financial_goals/src/modules/transaction/model/transaction_model.dart';

abstract class ITransactionService {
  Future<List<DocumentFirestoreModel<TransactionModel>>> getAll(String goalId);
}
