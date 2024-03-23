import 'package:financial_goals/src/modules/purchase/controller/purchase_controller.dart';
import 'package:financial_goals/src/modules/purchase/state/purchase_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PurchasePage extends StatefulWidget {
  final PurchaseController controller;
  const PurchasePage({
    required this.controller,
    super.key,
  });

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  PurchaseController get controller => widget.controller;

  final text = '''
Com o plano gratuito você já tem a praticidade de gerenciar até 3 metas financeiras. Mas por que se limitar? O Plano Premium é a chave para uma organização financeira sem fronteiras!

✅ Metas Ilimitadas: Liberdade para definir todas as metas que desejar. 

✅ Apoio Contínuo: Contribua para o desenvolvimento e aprimoramento do aplicativo. 

✅ Foco no Futuro: Invista em suas finanças com ferramentas que crescem com você.''';

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  @override
  void dispose() {
    controller.disposeSubscription();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<PurchaseController>();
    var state = controller.value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('conta premium'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
              Text(text),
              const SizedBox(height: 8),
              const Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'acesso premium',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Text(
                        'R\$ 4,99',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Visibility(
                visible: state is PurchaseLoadingState,
                child: const LinearProgressIndicator(),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed:
                    state is PurchaseInitialState || state is PurchaseErrorState
                        ? controller.buyProduct
                        : null,
                child: const Text('realizar pagamento'),
              ),
              const SizedBox(height: 8),
              if (state is PurchaseErrorState)
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(state.error),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
