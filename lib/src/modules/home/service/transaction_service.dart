import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:financial_goals/src/modules/home/interface/itransaction_service.dart';
import 'package:financial_goals/src/modules/transaction/model/transaction_model.dart';

class TransactionService implements ITransactionService {
  late CollectionReference<Map<String, dynamic>> _collection;
  TransactionService() {
    _collection = FirebaseFirestore.instance.collection('transaction');
  }

  @override
  Future<List<DocumentFirestoreModel<TransactionModel>>> getAll(
    String goalId,
  ) async {
    var transactions = await _collection
        .where(
          'goalId',
          isEqualTo: goalId,
        )
        .get();

    List<DocumentFirestoreModel<TransactionModel>> response = [];
    for (var transaction in transactions.docs) {
      var document = DocumentFirestoreModel(
        id: transaction.id,
        document: TransactionModel.fromMap(transaction.data()),
      );
      response.add(document);
    }

    response.sort(
      (a, b) => b.document.transactionDate.compareTo(
        a.document.transactionDate,
      ),
    );

    return response;
  }
}
