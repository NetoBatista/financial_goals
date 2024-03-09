import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_goals/src/modules/goal/interface/igoal_service.dart';
import 'package:financial_goals/src/modules/goal/model/goal_model.dart';
import 'package:financial_goals/src/model/document_firestore_model.dart';

class GoalService implements IGoalService {
  late CollectionReference<Map<String, dynamic>> _collection;
  GoalService() {
    _collection = FirebaseFirestore.instance.collection('goal');
  }
  @override
  Future<DocumentFirestoreModel<GoalModel>> create(GoalModel goal) async {
    var response = await _collection.add(goal.toMap());
    return DocumentFirestoreModel<GoalModel>(
      id: response.id,
      document: goal,
    );
  }

  @override
  Future<void> update(DocumentFirestoreModel<GoalModel> goal) async {
    var document = goal.document;
    return _collection.doc(goal.id).update(
      {
        'name': document.name,
        'value': document.value,
        'finalDate': document.finalDate.millisecondsSinceEpoch,
      },
    );
  }

  @override
  Future<void> delete(
    DocumentFirestoreModel<GoalModel> goal,
  ) async {
    return _collection.doc(goal.id).delete();
  }
}
