import 'package:financial_goals/src/modules/transaction/controller/create_transaction_controller.dart';
import 'package:financial_goals/src/modules/transaction/controller/update_transaction_controller.dart';
import 'package:financial_goals/src/modules/transaction/data/interface/itransaction_service.dart';
import 'package:financial_goals/src/modules/transaction/data/service/transaction_service.dart';
import 'package:financial_goals/src/modules/transaction/store/transaction_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TransactionModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(TransactionStore.new);
    i.addSingleton(CreateTransactionController.new);
    i.addSingleton(UpdateTransactionController.new);
    i.addSingleton<ITransactionService>(TransactionService.new);
  }
}
