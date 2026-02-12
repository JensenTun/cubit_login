import 'package:cubit_login/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;
  FirebaseAuthService(this._firebaseAuth);

  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw Exception("Sign up failed..");
    }
    await user.updateDisplayName(name);

    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
    );
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;

    if (user == null) {
      throw Exception("Login failed...");
    }

    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
    );
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  AppUser? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
    );
  }
}
