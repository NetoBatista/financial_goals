import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:financial_goals/src/modules/purchase/model/purchase_model.dart';
import 'package:signals/signals.dart';

class PurchaseStore {
  final purchase = signal<DocumentFirestoreModel<PurchaseModel>?>(null);
}
