import 'package:financial_goals/src/modules/goal/controller/create_goal_controller.dart';
import 'package:financial_goals/src/modules/goal/model/goal_model.dart';
import 'package:financial_goals/src/modules/goal/state/create_goal_state.dart';
import 'package:financial_goals/src/modules/home/store/goal_store.dart';
import 'package:financial_goals/src/util/currency_input_format_util.dart';
import 'package:financial_goals/src/util/format_util.dart';
import 'package:financial_goals/src/validator/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CreateGoalComponent extends StatefulWidget {
  final CreateGoalController controller;
  final GoalStore store;
  const CreateGoalComponent({
    super.key,
    required this.controller,
    required this.store,
  });

  @override
  State<CreateGoalComponent> createState() => _CreateGoalComponentState();
}

class _CreateGoalComponentState extends State<CreateGoalComponent> {
  CreateGoalController get controller => widget.controller;
  GoalStore get store => widget.store;

  final dateTextEdittingController = TextEditingController(
    text: FormatUtil.dateTimeToLongString(DateTime.now()),
  );

  final _goalModel = GoalModel.empty();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    context.watch<CreateGoalController>();
    var state = controller.value;
    var loadingState = state is CreateGoalLoadingState;
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
              validator: FormValidator.requiredField,
              onFieldSubmitted: (String? newValue) {
                onClickCreateGoal();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: 'nome da meta',
                prefixIcon: const Icon(Icons.wallet),
                counterText: '',
              ),
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
              initialValue: "0,00",
              validator: FormValidator.requiredMoneyValue,
              onFieldSubmitted: (String? newValue) {
                onClickCreateGoal();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: 'valor final',
                prefixIcon: const Icon(Icons.attach_money_outlined),
                counterText: '',
              ),
              maxLength: 14,
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
                  lastDate: DateTime.now().add(const Duration(days: 366)),
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
            if (state is CreateGoalErrorState)
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
              onPressed: loadingState ? null : onClickCreateGoal,
              child: const Text('adicionar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onClickCreateGoal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    var response = await controller.create(_goalModel);
    if (response == null) {
      return;
    }
    var goals = store.goals.value;
    goals.insert(0, response);
    store.goals.set(goals, force: true);
    Modular.to.pop(response);
  }
}
