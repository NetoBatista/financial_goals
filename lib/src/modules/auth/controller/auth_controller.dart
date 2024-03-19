import 'package:financial_goals/src/modules/auth/data/interface/iauth_service.dart';
import 'package:financial_goals/src/modules/auth/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthController extends ValueNotifier<AuthState> {
  final IAuthService _authService;
  AuthController(this._authService) : super(AuthInitialState());

  Future<void> init() async {
    try {
      var currentUser = _authService.getCurrentCredential();
      if (currentUser == null) {
        await signInAnonymous();
      }
      Modular.to.navigate('/home/');
    } catch (error) {
      value = AuthErrorState('erro ao autenticar, por favor tente novamente');
    }
  }

  Future<void> signInAnonymous() => _authService.anonymous();
}
