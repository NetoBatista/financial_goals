import 'package:financial_goals/src/modules/goal/model/goal_model.dart';
import 'package:financial_goals/src/model/document_firestore_model.dart';

abstract class IGoalService {
  Future<List<DocumentFirestoreModel<GoalModel>>> getAll(String userId);
}
