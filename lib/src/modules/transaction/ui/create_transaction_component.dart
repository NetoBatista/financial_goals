import 'package:financial_goals/src/modules/transaction/constant/transaction_type_constant.dart';
import 'package:financial_goals/src/modules/transaction/controller/create_transaction_controller.dart';
import 'package:financial_goals/src/modules/transaction/model/transaction_model.dart';
import 'package:financial_goals/src/modules/transaction/state/create_transaction_state.dart';
import 'package:financial_goals/src/modules/transaction/store/transaction_store.dart';
import 'package:financial_goals/src/translate/transaction_type_translate.dart';
import 'package:financial_goals/src/util/currency_input_format_util.dart';
import 'package:financial_goals/src/util/format_util.dart';
import 'package:financial_goals/src/validator/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:signals/signals_flutter.dart';

class CreateTransactionComponent extends StatefulWidget {
  final CreateTransactionController controller;
  final String goalId;
  final TransactionStore store;
  const CreateTransactionComponent({
    super.key,
    required this.controller,
    required this.goalId,
    required this.store,
  });

  @override
  State<CreateTransactionComponent> createState() =>
      _CreateTransactionComponentState();
}

class _CreateTransactionComponentState
    extends State<CreateTransactionComponent> {
  CreateTransactionController get controller => widget.controller;

  final dateTextEdittingController = TextEditingController(
    text: FormatUtil.dateTimeToLongString(DateTime.now()),
  );

  final _transactionModel = TransactionModel.empty();
  var transactionType = signal(TransactionTypeConstant.receipt);

  @override
  void initState() {
    super.initState();
    _transactionModel.goalId = widget.goalId;
    _transactionModel.type = TransactionTypeConstant.receipt;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    context.watch<CreateTransactionController>();
    var state = controller.value;
    var loadingState = state is CreateTransactionLoadingState;
    var bottom = MediaQuery.of(context).viewInsets.bottom + 10;
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: SizedBox(
                width: 24,
                child: Divider(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SegmentedButton(
              segments: [
                ButtonSegment<String>(
                  value: TransactionTypeConstant.receipt,
                  label: Text(
                    TransactionTypeTranslate.translate(
                      TransactionTypeConstant.receipt,
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_upward_outlined,
                    color: Colors.green,
                  ),
                ),
                ButtonSegment<String>(
                  value: TransactionTypeConstant.expense,
                  label: Text(
                    TransactionTypeTranslate.translate(
                      TransactionTypeConstant.expense,
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_downward_outlined,
                    color: Colors.red,
                  ),
                ),
              ],
              selected: <String>{transactionType.watch(context)},
              onSelectionChanged: (Set<String> value) {
                transactionType.set(value.last);
                _transactionModel.type = transactionType.value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.number,
              enabled: !loadingState,
              inputFormatters: [CurrencyInputFormatUtil()],
              validator: FormValidator.requiredMoneyValue,
              initialValue: "0,00",
              onFieldSubmitted: (String? newValue) {
                onClickCreateTransaction();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: 'valor da transação',
                prefixIcon: const Icon(Icons.attach_money_outlined),
                counterText: '',
              ),
              maxLength: 14,
              onChanged: (String newValue) {
                var value = newValue.replaceAll('.', '').replaceAll(',', '.');
                _transactionModel.value = double.parse(value);
              },
            ),
            const SizedBox(height: 16),
            if (state is CreateTransactionErrorState)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outlined,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(state.error),
                  ],
                ),
              ),
            FilledButton(
              onPressed: loadingState ? null : onClickCreateTransaction,
              child: const Text('adicionar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onClickCreateTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_transactionModel.value == 0) {
      return;
    }
    var response = await controller.create(_transactionModel);
    if (response == null) {
      return;
    }
    var transactions = widget.store.transactions.value.toList();
    transactions.insert(0, response);
    widget.store.transactions.set(transactions);
    Modular.to.pop();
  }
}
