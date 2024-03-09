abstract class UpdateGoalState {}

class UpdateGoalInitialState extends UpdateGoalState {}

class UpdateGoalLoadingState extends UpdateGoalState {}

class UpdateGoalSuccessState extends UpdateGoalState {}

class UpdateGoalErrorState extends UpdateGoalState {
  String error;
  UpdateGoalErrorState(this.error);
}
