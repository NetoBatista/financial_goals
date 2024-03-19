import 'package:financial_goals/src/modules/goal/controller/update_goal_controller.dart';
import 'package:financial_goals/src/modules/goal/model/goal_model.dart';
import 'package:financial_goals/src/modules/goal/state/update_goal_state.dart';
import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:financial_goals/src/modules/home/store/goal_store.dart';
import 'package:financial_goals/src/util/currency_input_format_util.dart';
import 'package:financial_goals/src/util/format_util.dart';
import 'package:financial_goals/src/validator/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class UpdateGoalComponent extends StatefulWidget {
  final UpdateGoalController controller;
  final DocumentFirestoreModel<GoalModel> documentFirestore;
  final GoalStore store;
  const UpdateGoalComponent({
    super.key,
    required this.controller,
    required this.documentFirestore,
    required this.store,
  });

  @override
  State<UpdateGoalComponent> createState() => _UpdateGoalComponentState();
}

class _UpdateGoalComponentState extends State<UpdateGoalComponent> {
  UpdateGoalController get controller => widget.controller;

  final dateTextEdittingController = TextEditingController(
    text: FormatUtil.dateTimeToLongString(DateTime.now()),
  );

  GoalModel get _goalModel => widget.documentFirestore.document;
  GoalStore get store => widget.store;

  @override
  void initState() {
    super.initState();
    dateTextEdittingController.text = FormatUtil.dateTimeToLongString(
      _goalModel.finalDate,
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    context.watch<UpdateGoalController>();
    var state = controller.value;
    var loadingState = state is UpdateGoalLoadingState;
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
              enabled: !loadingState,
              initialValue: _goalModel.name,
              validator: FormValidator.requiredField,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: 'nome da meta',
                prefixIcon: const Icon(Icons.wallet),
                counterText: '',
              ),
              onFieldSubmitted: (String? newValue) {
                onClickUpdateGoal();
              },
              maxLength: 100,
              onChanged: (String newValue) {
                _goalModel.name = newValue;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.number,
              enabled: !loadingState,
              inputFormatters: [CurrencyInputFormatUtil()],
              initialValue: FormatUtil.doubleToMoney(_goalModel.value),
              validator: FormValidator.requiredMoneyValue,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: 'valor final',
                prefixIcon: const Icon(Icons.attach_money_outlined),
                counterText: '',
              ),
              maxLength: 14,
              onFieldSubmitted: (String? newValue) {
                onClickUpdateGoal();
              },
              onChanged: (String newValue) {
                var value = newValue.replaceAll('.', '').replaceAll(',', '.');
                _goalModel.value = double.parse(value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: dateTextEdittingController,
              readOnly: true,
              enabled: !loadingState,
              onTap: () async {
                var response = await showDatePicker(
                  context: context,
                  initialDate: _goalModel.finalDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 366 * 100)),
                );
                if (response == null) {
                  return;
                }
                _goalModel.finalDate = response;
                dateTextEdittingController.text =
                    FormatUtil.dateTimeToLongString(response);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: 'data final',
                prefixIcon: const Icon(Icons.calendar_month_outlined),
              ),
            ),
            const SizedBox(height: 16),
            if (state is UpdateGoalErrorState)
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
              onPressed: loadingState ? null : onClickUpdateGoal,
              child: const Text('atualizar'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: loadingState ? null : onClickRemoveGoal,
              child: const Text('remover'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> onClickUpdateGoal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    var response = await controller.update(widget.documentFirestore);
    if (response == null) {
      return;
    }

    var goals = store.goals.value.toList();
    var index = goals.indexWhere((x) => x.id == widget.documentFirestore.id);
    goals.removeAt(index);
    goals.insert(index, response);
    store.goals.set(goals);

    Modular.to.pop(response);
  }

  Future<void> onClickRemoveGoal() async {
    var remove = await showDialog<bool?>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'essa ação não é reversível e todas as transações também serão apagadas',
              ),
              SizedBox(height: 8),
              Text('deseja continuar mesmo assim?')
            ],
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
    var goals = store.goals.value.toList();
    goals.removeWhere((x) => x.id == widget.documentFirestore.id);
    store.goals.set(goals);
    Modular.to.popUntil((route) => route.settings.name == '/home/');
  }
}
