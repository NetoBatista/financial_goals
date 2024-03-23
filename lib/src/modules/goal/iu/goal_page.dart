import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:financial_goals/src/modules/goal/controller/update_goal_controller.dart';
import 'package:financial_goals/src/modules/goal/iu/update_goal_component.dart';
import 'package:financial_goals/src/modules/goal/model/goal_model.dart';
import 'package:financial_goals/src/modules/home/store/goal_store.dart';
import 'package:financial_goals/src/modules/transaction/constant/transaction_type_constant.dart';
import 'package:financial_goals/src/modules/transaction/controller/create_transaction_controller.dart';
import 'package:financial_goals/src/modules/transaction/controller/update_transaction_controller.dart';
import 'package:financial_goals/src/modules/transaction/model/transaction_model.dart';
import 'package:financial_goals/src/modules/transaction/store/transaction_store.dart';
import 'package:financial_goals/src/modules/transaction/ui/create_transaction_component.dart';
import 'package:financial_goals/src/modules/transaction/ui/transaction_component.dart';
import 'package:financial_goals/src/modules/transaction/ui/update_transaction_component.dart';
import 'package:financial_goals/src/util/format_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:signals/signals_flutter.dart';

class GoalPage extends StatefulWidget {
  final DocumentFirestoreModel<GoalModel> goalModel;
  final GoalStore goalStore;
  final CreateTransactionController createTransactionController;
  final UpdateTransactionController updateTransactionController;
  final TransactionStore transactionStore;
  final UpdateGoalController updateGoalController;
  const GoalPage({
    super.key,
    required this.goalModel,
    required this.goalStore,
    required this.createTransactionController,
    required this.updateTransactionController,
    required this.transactionStore,
    required this.updateGoalController,
  });

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  GoalStore get store => widget.goalStore;
  TransactionStore get transactionStore => widget.transactionStore;

  final goalModel = signal(
    DocumentFirestoreModel(
      id: '',
      document: GoalModel.empty(),
    ),
  );

  @override
  void initState() {
    super.initState();
    goalModel.set(widget.goalModel);
  }

  @override
  Widget build(BuildContext context) {
    goalModel.watch(context);
    var transactions = transactionsOfGoal();
    return Scaffold(
      appBar: null,
      floatingActionButton: FloatingActionButton(
        onPressed: onClickCreateTransaction,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                IconButton(
                  onPressed: Modular.to.pop,
                  icon: const Icon(Icons.arrow_back_outlined),
                  iconSize: 32,
                ),
                const SizedBox(height: 8),
                Card(
                  child: InkWell(
                    onTap: onClickUpdateGoal,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  goalModel.value.document.name,
                                  style: const TextStyle(fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Icon(Icons.edit),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getValueGoalTransaction()),
                              Text(
                                FormatUtil.dateTimeToLongString(
                                  goalModel.value.document.finalDate,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: percentTransactionToTotal() / 100,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text('${percentTransactionToTotal().toInt()} %'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    var transaction = transactions.elementAt(
                      index,
                    );
                    return TransactionComponent(
                      documentFirestoreModel: transaction,
                      onTap: () {
                        onClickUpdateTransaction(transaction);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DocumentFirestoreModel<TransactionModel>> transactionsOfGoal() {
    return transactionStore.transactions
        .watch(context)
        .where(
          (x) => x.document.goalId == goalModel.value.id,
        )
        .toList();
  }

  Future<void> onClickUpdateGoal() async {
    var copyGoal = goalModel.value.document.copyWith();
    var response =
        await showModalBottomSheet<DocumentFirestoreModel<GoalModel>?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: UpdateGoalComponent(
            controller: widget.updateGoalController,
            store: store,
            documentFirestore: DocumentFirestoreModel(
              id: goalModel.value.id,
              document: copyGoal,
            ),
          ),
        );
      },
    );
    if (response == null) {
      return;
    }

    goalModel.set(response);
  }

  void onClickCreateTransaction() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: CreateTransactionComponent(
            controller: widget.createTransactionController,
            goalId: goalModel.value.id,
            store: transactionStore,
          ),
        );
      },
    );
  }

  void onClickUpdateTransaction(
    DocumentFirestoreModel<TransactionModel> transactionModel,
  ) {
    var copyTransaction = transactionModel.document.copyWith();
    showModalBottomSheet<DocumentFirestoreModel<TransactionModel>?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: UpdateTransactionComponent(
            controller: widget.updateTransactionController,
            store: transactionStore,
            documentFirestore: DocumentFirestoreModel(
              id: transactionModel.id,
              document: copyTransaction,
            ),
          ),
        );
      },
    );
  }

  String getValueGoalTransaction() {
    String response = "";
    response += FormatUtil.doubleToMoney(
      totalTransactions(),
      symbol: true,
    );

    response += " de ";

    response += FormatUtil.stringToMoney(
      goalModel.value.document.value.toString(),
      symbol: true,
    );

    return response;
  }

  double totalTransactions() {
    var response = .0;
    for (var transaction in transactionsOfGoal()) {
      if (transaction.document.type == TransactionTypeConstant.receipt) {
        response += transaction.document.value;
      } else {
        response -= transaction.document.value;
      }
    }
    return response;
  }

  double percentTransactionToTotal() {
    var valueTotalTransactions = totalTransactions();
    var valueTotalGoal = goalModel.value.document.value;

    if (valueTotalTransactions == 0) {
      return 0;
    }

    return (valueTotalTransactions * 100) / valueTotalGoal;
  }
}
