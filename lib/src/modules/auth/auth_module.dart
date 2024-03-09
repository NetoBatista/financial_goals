import 'package:financial_goals/src/modules/auth/controller/auth_controller.dart';
import 'package:financial_goals/src/modules/auth/data/interface/iauth_service.dart';
import 'package:financial_goals/src/modules/auth/data/service/auth_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addSingleton<IAuthService>(AuthService.new);
  }

  @override
  void binds(i) {
    i.addSingleton(AuthController.new);
  }
}
