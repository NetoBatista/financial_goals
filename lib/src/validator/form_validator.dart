class FormValidator {
  static String? requiredField(String? value) {
    if (value == null || value.isEmpty) {
      return 'campo obrigatório';
    }
    return null;
  }

  static String? requiredMoneyValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'campo obrigatório';
    }
    var doubleValue = double.parse(
      value.replaceAll(".", "").replaceAll(",", "."),
    );
    if (doubleValue == 0) {
      return 'o valor precisa ser maior que R\$ 0,00';
    }
    return null;
  }
}
