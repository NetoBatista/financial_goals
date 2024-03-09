abstract class CreateGoalState {}

class CreateGoalInitialState extends CreateGoalState {}

class CreateGoalLoadingState extends CreateGoalState {}

class CreateGoalSuccessState extends CreateGoalState {}

class CreateGoalErrorState extends CreateGoalState {
  String error;
  CreateGoalErrorState(this.error);
}
