import 'package:financial_goals/src/modules/goal/model/goal_model.dart';
import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:signals/signals.dart';

class GoalStore {
  final goals = signal(<DocumentFirestoreModel<GoalModel>>[]);
}
