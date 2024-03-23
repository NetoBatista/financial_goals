import 'package:financial_goals/src/modules/auth/auth_module.dart';
import 'package:financial_goals/src/modules/goal/controller/create_goal_controller.dart';
import 'package:financial_goals/src/modules/goal/controller/update_goal_controller.dart';
import 'package:financial_goals/src/modules/goal/interface/igoal_service.dart';
import 'package:financial_goals/src/modules/goal/iu/goal_page.dart';
import 'package:financial_goals/src/modules/goal/service/goal_service.dart';
import 'package:financial_goals/src/modules/transaction/transaction_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class GoalModule extends Module {
  @override
  List<Module> get imports {
    return [
      AuthModule(),
      TransactionModule(),
    ];
  }

  @override
  void binds(i) {
    i.addSingleton(CreateGoalController.new);
    i.addSingleton(UpdateGoalController.new);
    i.addSingleton<IGoalService>(GoalService.new);
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => GoalPage(
        goalModel: r.args.data,
        updateGoalController: Modular.get(),
        goalStore: Modular.get(),
        createTransactionController: Modular.get(),
        updateTransactionController: Modular.get(),
        transactionStore: Modular.get(),
      ),
    );
  }
}
