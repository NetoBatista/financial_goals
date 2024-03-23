import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:financial_goals/src/modules/purchase/interface/ipurchase_service.dart';
import 'package:financial_goals/src/modules/purchase/model/purchase_model.dart';

class PurchaseService implements IPurchaseService {
  late CollectionReference<Map<String, dynamic>> _collection;
  PurchaseService() {
    _collection = FirebaseFirestore.instance.collection('purchase');
  }

  @override
  Future<DocumentFirestoreModel<PurchaseModel>> create(
    PurchaseModel purchase,
  ) async {
    var response = await _collection.add(purchase.toMap());
    return DocumentFirestoreModel<PurchaseModel>(
      id: response.id,
      document: purchase,
    );
  }

  @override
  Future<void> delete(
    DocumentFirestoreModel<PurchaseModel> goal,
  ) async {
    return _collection.doc(goal.id).delete();
  }

  @override
  Future<DocumentFirestoreModel<PurchaseModel>?> get(
    String userId,
  ) async {
    var goals = await _collection
        .where(
          'userId',
          isEqualTo: userId,
        )
        .get();

    for (var goal in goals.docs) {
      return DocumentFirestoreModel(
        id: goal.id,
        document: PurchaseModel.fromMap(goal.data()),
      );
    }

    return null;
  }
}
