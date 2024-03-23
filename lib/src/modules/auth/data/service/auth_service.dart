import 'package:financial_goals/src/modules/auth/data/interface/iauth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService implements IAuthService {
  final _googleSignIn = GoogleSignIn();

  @override
  User? getCurrentCredential() => FirebaseAuth.instance.currentUser;

  @override
  Future<void> anonymous() => FirebaseAuth.instance.signInAnonymously();

  @override
  Future<void> signInGoogle() async {
    OAuthCredential? credential;
    try {
      await _googleSignIn.signOut();
      var googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return;
      }
      var googleSignInAuthentication = await googleSignInAccount.authentication;
      credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use' && credential != null) {
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Future<void> signInSilently() async {
    try {
      var googleSignInAccount = await _googleSignIn.signInSilently();
      if (googleSignInAccount == null) {
        return;
      }
      var googleSignInAuthentication = await googleSignInAccount.authentication;
      var credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (_) {}
  }

  @override
  Future<void>? removeAccount() => FirebaseAuth.instance.currentUser?.delete();
}
