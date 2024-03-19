import 'package:financial_goals/src/modules/purchase/component/premium_popup_component.dart';
import 'package:flutter/material.dart';

class PremiumComponent extends StatelessWidget {
  const PremiumComponent({super.key});

  final text = '''
metas financeiras ilimitadas, suporte prioritário e a certeza de estar contribuindo para um app que cresce com você''';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              content: PremiumPopUpComponent(),
            );
          },
        );
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
