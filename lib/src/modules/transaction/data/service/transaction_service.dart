import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:financial_goals/src/modules/transaction/data/interface/itransaction_service.dart';
import 'package:financial_goals/src/modules/transaction/model/transaction_model.dart';

class TransactionService implements ITransactionService {
  late CollectionReference<Map<String, dynamic>> _collection;
  TransactionService() {
    _collection = FirebaseFirestore.instance.collection('transaction');
  }
  @override
  Future<DocumentFirestoreModel<TransactionModel>> create(
    TransactionModel transaction,
  ) async {
    var response = await _collection.add(transaction.toMap());
    return DocumentFirestoreModel<TransactionModel>(
      id: response.id,
      document: transaction,
    );
  }

  @override
  Future<void> update(
    DocumentFirestoreModel<TransactionModel> transaction,
  ) async {
    var document = transaction.document;
    return _collection.doc(transaction.id).update(
      {
        'value': document.value,
      },
    );
  }

  @override
  Future<void> delete(
    DocumentFirestoreModel<TransactionModel> transaction,
  ) async {
    return _collection.doc(transaction.id).delete();
  }
}
