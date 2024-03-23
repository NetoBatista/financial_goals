import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_goals/src/modules/goal/model/goal_model.dart';
import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:financial_goals/src/modules/purchase/interface/igoal_service.dart';

class GoalService implements IGoalService {
  late CollectionReference<Map<String, dynamic>> _collection;
  GoalService() {
    _collection = FirebaseFirestore.instance.collection('goal');
  }

  @override
  Future<List<DocumentFirestoreModel<GoalModel>>> getAll(String userId) async {
    var goals = await _collection
        .where(
          'userId',
          isEqualTo: userId,
        )
        .get();

    List<DocumentFirestoreModel<GoalModel>> response = [];
    for (var goal in goals.docs) {
      var document = DocumentFirestoreModel(
        id: goal.id,
        document: GoalModel.fromMap(goal.data()),
      );
      response.add(document);
    }

    return response;
  }
}
