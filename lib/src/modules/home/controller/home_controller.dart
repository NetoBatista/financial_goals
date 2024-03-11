import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:financial_goals/src/modules/auth/data/interface/iauth_service.dart';
import 'package:financial_goals/src/modules/home/interface/igoal_service.dart';
import 'package:financial_goals/src/modules/home/interface/itransaction_service.dart';
import 'package:financial_goals/src/modules/home/state/home_state.dart';
import 'package:financial_goals/src/modules/home/store/goal_store.dart';
import 'package:financial_goals/src/modules/transaction/model/transaction_model.dart';
import 'package:financial_goals/src/modules/transaction/store/transaction_store.dart';
import 'package:flutter/material.dart';

class HomeController extends ValueNotifier<HomeState> {
  final IGoalService _goalService;
  final IAuthService _authService;
  final GoalStore _goalStore;
  final TransactionStore _transactionStore;
  final ITransactionService _transactionService;
  HomeController(
    this._goalService,
    this._authService,
    this._goalStore,
    this._transactionStore,
    this._transactionService,
  ) : super(HomeInitialState());

  Future<void> init() async {
    try {
      value = HomeLoadingState();

      var userId = _authService.getCurrentCredential()!.uid;
      var goals = await _goalService.getAll(userId);

      var transactions = <DocumentFirestoreModel<TransactionModel>>[];
      for (var goal in goals) {
        var transactionsOfGoal = await _transactionService.getAll(goal.id);
        transactions.addAll(transactionsOfGoal);
      }

      _goalStore.goals.set(goals);
      _transactionStore.transactions.set(transactions);

      value = HomeSuccessState();
    } catch (error) {
      value = HomeErrorState('erro ao buscar dados');
    }
  }

  bool canCreateGoal() {
    return _goalStore.goals.value.length < 3;
  }
}
