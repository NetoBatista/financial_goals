import 'package:financial_goals/src/modules/account/controller/account_controller.dart';
import 'package:financial_goals/src/modules/account/state/account_state.dart';
import 'package:financial_goals/src/modules/purchase/component/premium_component.dart';
import 'package:financial_goals/src/modules/purchase/controller/purchase_controller.dart';
import 'package:financial_goals/src/modules/purchase/store/purchase_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AccountPage extends StatefulWidget {
  final AccountController controller;
  final PurchaseStore purchaseStore;
  final PurchaseController purchaseController;
  const AccountPage({
    required this.controller,
    required this.purchaseStore,
    required this.purchaseController,
    super.key,
  });

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  AccountController get controller => widget.controller;
  PurchaseController get purchageController => widget.purchaseController;
  PurchaseStore get purchaseStore => widget.purchaseStore;

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AccountController>();
    var state = controller.value;
    var stateInitial = state is AccountInitialState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('minha conta'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              PremiumComponent(
                purchaseStore: purchaseStore,
                controller: purchageController,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 8),
                          Text(controller.user?.email ?? 'sem conta'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Visibility(
                visible: !stateInitial,
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('remover conta'),
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'tem certeza que deseja remover a sua conta? todos os dados serão apagados e essa ação não é reversível',
                              ),
                              SizedBox(height: 8),
                              Text(
                                'caso sua conta seja premium, esse recurso também será removido',
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: controller.removeAccount,
                              child: const Text('confirmar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'remover conta',
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Visibility(
                visible: state is AccountInitialState,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Percebemos que você não possui uma conta vinculada. Para garantir que suas metas e dados financeiros estejam seguros e acessíveis em qualquer dispositivo, recomendamos criar e vincular sua conta. É rápido, fácil e gratuito, assim você não corre o risco de perder suas informações!',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Visibility(
                visible: state is AccountInitialState,
                child: FilledButton(
                  onPressed: controller.signInGoogle,
                  child: const Text('entrar com google'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
