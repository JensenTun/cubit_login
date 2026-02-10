import 'package:cubit_login/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension FirebaseUser on User {
  AppUser toUser() {
    return AppUser(id: uid, email: email ?? '', name: displayName ?? '');
  }
}
