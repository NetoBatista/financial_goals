import 'package:financial_goals/src/modules/goal/model/goal_model.dart';
import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:financial_goals/src/modules/transaction/constant/transaction_type_constant.dart';
import 'package:financial_goals/src/modules/transaction/model/transaction_model.dart';
import 'package:financial_goals/src/modules/transaction/store/transaction_store.dart';
import 'package:financial_goals/src/util/format_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:signals/signals_flutter.dart';

class GoalComponent extends StatefulWidget {
  final DocumentFirestoreModel<GoalModel> goalModel;
  final TransactionStore transactionStore;
  const GoalComponent({
    super.key,
    required this.goalModel,
    required this.transactionStore,
  });

  @override
  State<GoalComponent> createState() => _GoalComponentState();
}

class _GoalComponentState extends State<GoalComponent> {
  bool animationCompleted = false;
  DocumentFirestoreModel<GoalModel> get goalModel => widget.goalModel;
  TransactionStore get transactionStore => widget.transactionStore;
  List<TransactionModel> get transactions {
    return transactionStore.transactions.value
        .map((e) => e.document)
        .where((x) => x.goalId == goalModel.id)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    transactionStore.transactions.watch(context);
    return Card(
      child: InkWell(
        onTap: () async {
          await Modular.to.pushNamed(
            '/goal/',
            arguments: DocumentFirestoreModel(
              id: goalModel.id,
              document: goalModel.document.copyWith(),
            ),
          );
        },
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
                      goalModel.document.name,
                      style: const TextStyle(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.arrow_forward_outlined)
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: 0,
                      end: totalTransactions(),
                    ),
                    duration: const Duration(seconds: 1),
                    builder: (BuildContext context, double value, _) {
                      value = animationCompleted ? totalTransactions() : value;
                      return Text(getValueGoalTransaction(value));
                    },
                  ),
                  Text(
                    FormatUtil.dateTimeToLongString(
                      goalModel.document.finalDate,
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
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 0,
                        end: percentTransactionToTotal() / 100,
                      ),
                      duration: const Duration(seconds: 1),
                      onEnd: () {
                        animationCompleted = true;
                      },
                      builder: (BuildContext context, double value, _) {
                        value = animationCompleted
                            ? percentTransactionToTotal() / 100
                            : value;
                        return LinearProgressIndicator(
                          value: value,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: 0,
                      end: percentTransactionToTotal() / 100,
                    ),
                    duration: const Duration(seconds: 1),
                    builder: (BuildContext context, double value, _) {
                      value = animationCompleted
                          ? percentTransactionToTotal() / 100
                          : value;
                      return Text('${(value * 100).toInt()} %');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getValueGoalTransaction(double value) {
    String response = "";
    response += FormatUtil.doubleToMoney(
      value,
      symbol: true,
    );

    response += " de ";

    response += FormatUtil.stringToMoney(
      goalModel.document.value.toString(),
      symbol: true,
    );

    return response;
  }

  double totalTransactions() {
    var response = .0;
    for (var transaction in transactions) {
      if (transaction.type == TransactionTypeConstant.receipt) {
        response += transaction.value;
      } else {
        response -= transaction.value;
      }
    }
    return response;
  }

  double percentTransactionToTotal() {
    var valueTotalTransactions = totalTransactions();
    var valueTotalGoal = goalModel.document.value;

    if (valueTotalTransactions == 0) {
      return 0;
    }

    return (valueTotalTransactions * 100) / valueTotalGoal;
  }
}
