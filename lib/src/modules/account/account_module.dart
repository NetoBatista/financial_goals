import 'package:financial_goals/src/modules/account/controller/account_controller.dart';
import 'package:financial_goals/src/modules/auth/auth_module.dart';
import 'package:financial_goals/src/modules/account/ui/account_page.dart';
import 'package:financial_goals/src/modules/purchase/purchase_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AccountModule extends Module {
  @override
  List<Module> get imports {
    return [
      AuthModule(),
      PurchaseModule(),
    ];
  }

  @override
  void binds(i) {
    i.addSingleton(AccountController.new);
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => AccountPage(
        controller: Modular.get(),
        purchaseStore: Modular.get(),
        purchaseController: Modular.get(),
      ),
    );
  }
}
