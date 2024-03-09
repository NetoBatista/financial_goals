import 'package:financial_goals/src/modules/transaction/constant/transaction_type_constant.dart';

class TransactionTypeTranslate {
  static final Map<String, String> _mapTypes = {
    TransactionTypeConstant.receipt: "entrada",
    TransactionTypeConstant.expense: "saída",
  };

  static String translate(String type) {
    return _mapTypes[type] ?? '';
  }
}
