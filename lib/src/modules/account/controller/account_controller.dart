import 'package:financial_goals/src/modules/account/state/account_state.dart';
import 'package:financial_goals/src/modules/auth/data/interface/iauth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AccountController extends ValueNotifier<AccountState> {
  final IAuthService _authService;
  AccountController(this._authService) : super(AccountInitialState());

  User? get user => _authService.getCurrentCredential();

  Future<void> init() async {
    try {
      var currentUser = _authService.getCurrentCredential();
      if (currentUser == null) {
        return;
      }
      if (currentUser.isAnonymous) {
        return;
      }
      value = AccountAuthenticatedState();
    } catch (error) {
      value = AccountErrorState(
        'ocorreu um erro ao tentar carregar os dados da sua conta',
      );
    }
  }

  Future<void> signInGoogle() async {
    await _authService.signInGoogle();
    await init();
  }

  Future<void> removeAccount() async {
    await _authService.signInSilently();
    await _authService.removeAccount();
    if (user == null) {
      Modular.to.navigate('/');
    }
  }
}
