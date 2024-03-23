import 'package:financial_goals/src/modules/purchase/component/premium_popup_component.dart';
import 'package:financial_goals/src/modules/purchase/controller/purchase_controller.dart';
import 'package:financial_goals/src/modules/purchase/store/purchase_store.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class PremiumComponent extends StatefulWidget {
  final PurchaseStore purchaseStore;
  final PurchaseController controller;
  final void Function()? callBack;
  const PremiumComponent({
    required this.purchaseStore,
    required this.controller,
    this.callBack,
    super.key,
  });

  @override
  State<PremiumComponent> createState() => _PremiumComponentState();
}

class _PremiumComponentState extends State<PremiumComponent> {
  PurchaseStore get purchaseStore => widget.purchaseStore;
  PurchaseController get controller => widget.controller;

  final text = '''
metas financeiras ilimitadas, suporte prioritário e a certeza de estar contribuindo para um app que cresce com você''';

  @override
  Widget build(BuildContext context) {
    purchaseStore.purchase.watch(context);
    if (purchaseStore.purchase.value != null) {
      return const SizedBox();
    }
    return InkWell(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: PremiumPopUpComponent(
                controller: controller,
              ),
            );
          },
        );
        if (widget.callBack != null) {
          widget.callBack!();
        }
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.indigoAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Colors.indigo,
            width: 0.8,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  'clique para saber mais',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
