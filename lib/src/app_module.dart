import 'package:financial_goals/src/modules/auth/ui/auth_page.dart';
import 'package:financial_goals/src/modules/goal/goal_module.dart';
import 'package:financial_goals/src/modules/home/home_module.dart';
import 'package:financial_goals/src/modules/account/account_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  List<Module> get imports {
    return [
      HomeModule(),
      GoalModule(),
    ];
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => AuthPage(controller: Modular.get()),
    );
    r.module(
      '/home',
      module: HomeModule(),
    );
    r.module(
      '/goal',
      module: GoalModule(),
    );
    r.module(
      '/account',
      module: AccountModule(),
    );
  }
}
