import 'package:financial_goals/src/modules/auth/data/interface/iauth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService implements IAuthService {
  @override
  User? getCurrentCredential() => FirebaseAuth.instance.currentUser;
  @override
  Future<void> anonymous() => FirebaseAuth.instance.signInAnonymously();
}
