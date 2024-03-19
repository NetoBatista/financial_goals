import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:financial_goals/src/modules/transaction/controller/update_transaction_controller.dart';
import 'package:financial_goals/src/modules/transaction/model/transaction_model.dart';
import 'package:financial_goals/src/modules/transaction/state/update_transaction_state.dart';
import 'package:financial_goals/src/modules/transaction/store/transaction_store.dart';
import 'package:financial_goals/src/util/currency_input_format_util.dart';
import 'package:financial_goals/src/util/format_util.dart';
import 'package:financial_goals/src/validator/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class UpdateTransactionComponent extends StatefulWidget {
  final UpdateTransactionController controller;
  final DocumentFirestoreModel<TransactionModel> documentFirestore;
  final TransactionStore store;
  const UpdateTransactionComponent({
    super.key,
    required this.controller,
    required this.documentFirestore,
    required this.store,
  });

  @override
  State<UpdateTransactionComponent> createState() =>
      _UpdateTransactionComponentState();
}

class _UpdateTransactionComponentState
    extends State<UpdateTransactionComponent> {
  UpdateTransactionController get controller => widget.controller;
  TransactionModel get _transactionModel => widget.documentFirestore.document;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    context.watch<UpdateTransactionController>();
    var state = controller.value;
    var loadingState = state is UpdateTransactionLoadingState;
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
            TextFormField(
              keyboardType: TextInputType.number,
              enabled: !loadingState,
              inputFormatters: [CurrencyInputFormatUtil()],
              initialValue: FormatUtil.doubleToMoney(_transactionModel.value),
              validator: FormValidator.requiredMoneyValue,
              onFieldSubmitted: (String? newValue) {
                onClickUpdateTransaction();
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
            if (state is UpdateTransactionErrorState)
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
              onPressed: loadingState ? null : onClickUpdateTransaction,
              child: const Text('atualizar'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: loadingState ? null : onClickRemoveTransaction,
              child: const Text('remover'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> onClickUpdateTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    var response = await controller.update(widget.documentFirestore);
    if (response == null) {
      return;
    }

    var transactions = widget.store.transactions.value.toList();
    var index = transactions.indexWhere(
      (x) => x.id == widget.documentFirestore.id,
    );
    transactions.removeAt(index);
    transactions.insert(index, response);
    widget.store.transactions.set(transactions);

    Modular.to.pop();
  }

  Future<void> onClickRemoveTransaction() async {
    var remove = await showDialog<bool?>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'deseja remover essa transação?',
          ),
          actions: [
            ElevatedButton(
              onPressed: Modular.to.pop,
              child: const Text('não'),
            ),
            ElevatedButton(
              onPressed: () => Modular.to.pop(true),
              child: const Text('sim'),
            ),
          ],
        );
      },
    );
    if (remove != true) {
      return;
    }
    var response = await controller.delete(widget.documentFirestore);
    if (!response) {
      return;
    }
    var transactions = widget.store.transactions.value.toList();
    transactions.removeWhere((x) => x.id == widget.documentFirestore.id);
    widget.store.transactions.set(transactions);
    Modular.to.pop();
  }
}
