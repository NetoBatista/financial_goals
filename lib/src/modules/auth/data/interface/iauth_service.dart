import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthService {
  User? getCurrentCredential();
  Future<void> anonymous();
}
