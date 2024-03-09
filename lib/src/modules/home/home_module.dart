import 'package:financial_goals/src/modules/auth/auth_module.dart';
import 'package:financial_goals/src/modules/goal/goal_module.dart';
import 'package:financial_goals/src/modules/home/controller/home_controller.dart';
import 'package:financial_goals/src/modules/home/interface/igoal_service.dart';
import 'package:financial_goals/src/modules/home/service/goal_service.dart';
import 'package:financial_goals/src/modules/home/store/goal_store.dart';
import 'package:financial_goals/src/modules/home/ui/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports {
    return [
      AuthModule(),
      GoalModule(),
    ];
  }

  @override
  void binds(i) {
    i.addSingleton(HomeController.new);
    i.addSingleton(GoalStore.new);
    i.addSingleton<IGoalService>(GoalService.new);
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => HomePage(
        createGoalController: Modular.get(),
        goalStore: Modular.get(),
        homeController: Modular.get(),
        transactionStore: Modular.get(),
      ),
    );
  }
}
