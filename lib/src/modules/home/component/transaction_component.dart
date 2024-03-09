import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:financial_goals/src/modules/transaction/constant/transaction_type_constant.dart';
import 'package:financial_goals/src/modules/transaction/model/transaction_model.dart';
import 'package:financial_goals/src/util/format_util.dart';
import 'package:flutter/material.dart';

class TransactionComponent extends StatelessWidget {
  final DocumentFirestoreModel<TransactionModel> documentFirestoreModel;
  final void Function()? onTap;
  final String goalName;
  const TransactionComponent({
    super.key,
    required this.goalName,
    required this.documentFirestoreModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Visibility(
                    visible: documentFirestoreModel.document.type ==
                        TransactionTypeConstant.receipt,
                    child: const Icon(
                      Icons.arrow_upward_outlined,
                      color: Colors.green,
                    ),
                  ),
                  Visibility(
                    visible: documentFirestoreModel.document.type ==
                        TransactionTypeConstant.expense,
                    child: const Icon(
                      Icons.arrow_downward_outlined,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      goalName,
                      style: const TextStyle(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    FormatUtil.doubleToMoney(
                      documentFirestoreModel.document.value,
                      symbol: true,
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    FormatUtil.dateTimeToLongString(
                      documentFirestoreModel.document.transactionDate,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
