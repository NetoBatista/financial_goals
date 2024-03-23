import 'package:financial_goals/src/modules/auth/auth_module.dart';
import 'package:financial_goals/src/modules/goal/goal_module.dart';
import 'package:financial_goals/src/modules/home/home_module.dart';
import 'package:financial_goals/src/modules/home/store/goal_store.dart';
import 'package:financial_goals/src/modules/purchase/controller/purchase_controller.dart';
import 'package:financial_goals/src/modules/purchase/interface/igoal_service.dart';
import 'package:financial_goals/src/modules/purchase/interface/ipurchase_service.dart';
import 'package:financial_goals/src/modules/purchase/interface/itransaction_service.dart';
import 'package:financial_goals/src/modules/purchase/service/goal_service.dart';
import 'package:financial_goals/src/modules/purchase/service/purchase_service.dart';
import 'package:financial_goals/src/modules/purchase/service/transaction_service.dart';
import 'package:financial_goals/src/modules/purchase/store/purchase_store.dart';
import 'package:financial_goals/src/modules/purchase/ui/purchage_page.dart';
import 'package:financial_goals/src/modules/transaction/store/transaction_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PurchaseModule extends Module {
  @override
  List<Module> get imports {
    return [
      AuthModule(),
    ];
  }

  @override
  void binds(i) {
    i.addSingleton(PurchaseController.new);
    i.addSingleton(PurchaseStore.new);
    i.addSingleton<IPurchaseService>(PurchaseService.new);
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => PurchasePage(
        controller: Modular.get(),
      ),
    );
  }
}
