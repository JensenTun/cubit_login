import 'package:cubit_login/cubit/auth_state.dart';
import 'package:cubit_login/service/firebase_auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuthService authService;

  AuthCubit(this.authService) : super(const AuthInitial());

  Future<void> signup(String email, String password, String name) async {
    emit(const AuthLoading());
    try {
      final user = await authService.signUp(
        email: email,
        password: password,
        name: name,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    try {
      final user = await authService.login(email: email, password: password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    try {
      await authService.logout();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void checkCurrentUser() {
    final user = authService.getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }
}
