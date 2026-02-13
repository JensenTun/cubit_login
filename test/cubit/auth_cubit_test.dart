import 'package:bloc_test/bloc_test.dart';
import 'package:cubit_login/cubit/auth_cubit.dart';
import 'package:cubit_login/cubit/auth_state.dart';
import 'package:cubit_login/models/app_user.dart';
import 'package:cubit_login/service/firebase_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements FirebaseAuthService {}

void main() {
  late AuthCubit authCubit;
  late MockAuthService mockAuthService;

  final testUser = AppUser(id: '1', email: 'test@mail.com', name: 'Jesen');

  setUp(() {
    mockAuthService = MockAuthService();
    authCubit = AuthCubit(mockAuthService);
  });

  tearDown(() {
    authCubit.close();
  });

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthAuthenticated] when login success',
    build: () {
      when(
        () => mockAuthService.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => testUser);
      return authCubit;
    },
    act: (cubit) => cubit.login('test@mail.com', '123456'),
    expect: () => [const AuthLoading(), AuthAuthenticated(testUser)],
  );

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthFailure] when login fails',
    build: () {
      when(
        () => mockAuthService.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('Login failed'));
      return authCubit;
    },
    act: (cubit) => cubit.login('wrong@mail.com', '123'),
    expect: () => [const AuthLoading(), isA<AuthFailure>()],
  );
}
