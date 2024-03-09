import 'package:financial_goals/src/modules/auth/data/interface/iauth_service.dart';
import 'package:financial_goals/src/modules/goal/interface/igoal_service.dart';
import 'package:financial_goals/src/modules/goal/model/goal_model.dart';
import 'package:financial_goals/src/modules/goal/state/update_goal_state.dart';
import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:flutter/foundation.dart';

class UpdateGoalController extends ValueNotifier<UpdateGoalState> {
  final IAuthService _authService;
  final IGoalService _goalService;
  UpdateGoalController(
    this._authService,
    this._goalService,
  ) : super(UpdateGoalInitialState());

  Future<DocumentFirestoreModel<GoalModel>?> update(
    DocumentFirestoreModel<GoalModel> goal,
  ) async {
    try {
      value = UpdateGoalLoadingState();
      goal.document.userId = _authService.getCurrentCredential()!.uid;
      await _goalService.update(goal);
      value = UpdateGoalSuccessState();
      return goal;
    } catch (error) {
      value = UpdateGoalErrorState('ocorreu um erro ao atualizar a meta');
      return null;
    }
  }

  Future<bool> delete(
    DocumentFirestoreModel<GoalModel> goal,
  ) async {
    try {
      value = UpdateGoalLoadingState();
      await _goalService.delete(goal);
      value = UpdateGoalSuccessState();
      return true;
    } catch (error) {
      value = UpdateGoalErrorState('ocorreu um erro ao deletar a meta');
      return false;
    }
  }
}
