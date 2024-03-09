import 'package:financial_goals/src/modules/goal/model/goal_model.dart';
import 'package:financial_goals/src/model/document_firestore_model.dart';

abstract class IGoalService {
  Future<DocumentFirestoreModel<GoalModel>> create(GoalModel goal);
  Future<void> update(DocumentFirestoreModel<GoalModel> goal);
  Future<void> delete(
    DocumentFirestoreModel<GoalModel> goal,
  );
}
