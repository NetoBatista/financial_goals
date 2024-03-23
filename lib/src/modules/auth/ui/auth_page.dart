import 'package:financial_goals/src/modules/auth/controller/auth_controller.dart';
import 'package:financial_goals/src/modules/auth/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthPage extends StatefulWidget {
  final AuthController controller;
  const AuthPage({super.key, required this.controller});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AuthController>();
    var widget = buildLoading();
    var state = controller.value;
    if (state is AuthErrorState) {
      widget = buildError(state.error);
    }
    return Scaffold(
      body: widget,
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildError(String error) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(error),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: controller.signInAnonymous,
            child: const Text('tentar novamente'),
          ),
        ],
      ),
    );
  }
}
