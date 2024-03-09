import 'package:financial_goals/src/modules/goal/controller/create_goal_controller.dart';
import 'package:financial_goals/src/modules/goal/iu/create_goal_component.dart';
import 'package:financial_goals/src/modules/goal/model/goal_model.dart';
import 'package:financial_goals/src/modules/home/component/goal_component.dart';
import 'package:financial_goals/src/modules/home/component/transaction_component.dart';
import 'package:financial_goals/src/modules/home/controller/home_controller.dart';
import 'package:financial_goals/src/modules/home/state/home_state.dart';
import 'package:financial_goals/src/modules/home/store/goal_store.dart';
import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:financial_goals/src/modules/transaction/model/transaction_model.dart';
import 'package:financial_goals/src/modules/transaction/store/transaction_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:signals/signals_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatefulWidget {
  final CreateGoalController createGoalController;
  final GoalStore goalStore;
  final HomeController homeController;
  final TransactionStore transactionStore;
  const HomePage({
    super.key,
    required this.createGoalController,
    required this.goalStore,
    required this.homeController,
    required this.transactionStore,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoalStore get goalStore => widget.goalStore;
  TransactionStore get transactionStore => widget.transactionStore;
  HomeController get homeController => widget.homeController;
  var viewSelected = signal('goal');

  @override
  void initState() {
    super.initState();
    homeController.init();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metas financeiras'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onClickCreateGoal,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: SegmentedButton(
                  segments: const [
                    ButtonSegment<String>(
                      value: 'goal',
                      label: Text('metas'),
                      icon: Icon(Icons.wallet),
                    ),
                    ButtonSegment<String>(
                      value: 'transaction',
                      label: Text('transações'),
                      icon: Icon(Icons.attach_money_outlined),
                    ),
                  ],
                  selected: <String>{viewSelected.watch(context)},
                  onSelectionChanged: (Set<String> value) {
                    viewSelected.set(value.last);
                  },
                ),
              ),
              const SizedBox(height: 16),
              buildGoals(),
              buildTransaction(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGoals() {
    if (viewSelected.value == "transaction") {
      return const SizedBox();
    }
    return Column(
      children: [
        Visibility(
          visible: homeController.value is HomeLoadingState,
          child: Skeletonizer(
            enabled: true,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                var goalModel = DocumentFirestoreModel<GoalModel>(
                  id: '',
                  document: GoalModel.empty(),
                );
                return GoalComponent(
                  goalModel: goalModel,
                  transactionStore: transactionStore,
                );
              },
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: goalStore.goals.watch(context).length,
          itemBuilder: (BuildContext context, int index) {
            var goalModel = goalStore.goals.value.elementAt(index);
            return GoalComponent(
              goalModel: goalModel,
              transactionStore: transactionStore,
            );
          },
        )
      ],
    );
  }

  Widget buildTransaction() {
    if (viewSelected.value == "goal") {
      return const SizedBox();
    }
    return Column(
      children: [
        Visibility(
          visible: homeController.value is HomeLoadingState,
          child: Skeletonizer(
            enabled: true,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                var transactionModel = DocumentFirestoreModel<TransactionModel>(
                  id: '',
                  document: TransactionModel.empty(),
                );
                return TransactionComponent(
                  goalName: '',
                  documentFirestoreModel: transactionModel,
                  onTap: null,
                );
              },
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactionStore.transactions.watch(context).length,
          itemBuilder: (BuildContext context, int index) {
            var transaction = transactionStore.transactions.value.elementAt(
              index,
            );
            var goalModel = goalStore.goals.value.firstWhere(
              (x) => x.id == transaction.document.goalId,
            );
            return TransactionComponent(
              documentFirestoreModel: transaction,
              onTap: null,
              goalName: goalModel.document.name,
            );
          },
        )
      ],
    );
  }

  void onClickCreateGoal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: CreateGoalComponent(
            controller: widget.createGoalController,
            store: goalStore,
          ),
        );
      },
    );
  }
}
