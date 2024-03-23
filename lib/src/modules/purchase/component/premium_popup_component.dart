import 'package:financial_goals/src/modules/purchase/controller/purchase_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PremiumPopUpComponent extends StatelessWidget {
  final PurchaseController controller;
  const PremiumPopUpComponent({
    required this.controller,
    super.key,
  });

  final text = '''
Com o plano gratuito você já tem a praticidade de gerenciar até 3 metas financeiras. Mas por que se limitar? O Plano Premium é a chave para uma organização financeira sem fronteiras!

✅ Metas Ilimitadas: Liberdade para definir todas as metas que desejar. 

✅ Apoio Contínuo: Contribua para o desenvolvimento e aprimoramento do aplicativo. 

✅ Foco no Futuro: Invista em suas finanças com ferramentas que crescem com você.''';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
              ),
              SizedBox(width: 8),
              Text(
                'Torne-se premium',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.star,
                color: Colors.amber,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'por apenas R\$ 4,99',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          Text(text),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () async {
              var response = await controller.continueToPayment();
              if (response) {
                await Modular.to.pushNamed('/purchase/');
                Modular.to.pop();
              }
            },
            child: const Text('quero conhecer'),
          ),
        ],
      ),
    );
  }
}
