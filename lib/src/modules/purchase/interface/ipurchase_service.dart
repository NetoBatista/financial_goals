import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:financial_goals/src/modules/purchase/model/purchase_model.dart';

abstract class IPurchaseService {
  Future<DocumentFirestoreModel<PurchaseModel>?> get(
    String userId,
  );
  Future<void> delete(
    DocumentFirestoreModel<PurchaseModel> goal,
  );
  Future<DocumentFirestoreModel<PurchaseModel>> create(
    PurchaseModel purchase,
  );
}
