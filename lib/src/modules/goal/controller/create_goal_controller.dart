import 'package:financial_goals/src/modules/auth/data/interface/iauth_service.dart';
import 'package:financial_goals/src/modules/goal/interface/igoal_service.dart';
import 'package:financial_goals/src/modules/goal/model/goal_model.dart';
import 'package:financial_goals/src/modules/goal/state/create_goal_state.dart';
import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:flutter/foundation.dart';

class CreateGoalController extends ValueNotifier<CreateGoalState> {
  final IAuthService _authService;
  final IGoalService _goalService;
  CreateGoalController(
    this._authService,
    this._goalService,
  ) : super(CreateGoalInitialState());

  Future<DocumentFirestoreModel<GoalModel>?> create(GoalModel goal) async {
    try {
      value = CreateGoalLoadingState();
      goal.userId = _authService.getCurrentCredential()!.uid;
      var response = await _goalService.create(goal);
      value = CreateGoalSuccessState();
      return response;
    } catch (error) {
      value = CreateGoalErrorState('ocorreu um erro ao cadastrar a meta');
      return null;
    }
  }
}
