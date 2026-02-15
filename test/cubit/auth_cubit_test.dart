import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cubit_login/screens/login_screen.dart';
import 'package:cubit_login/cubit/auth_cubit.dart';
import 'package:cubit_login/service/firebase_auth_service.dart';

class MockAuthService extends Mock implements FirebaseAuthService {}

void main() {
  late AuthCubit authCubit;

  setUp(() {
    authCubit = AuthCubit(MockAuthService());
  });

  tearDown(() async {
    await authCubit.close();
  });

  testWidgets('Login screen shows email & password fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: const LoginScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Login'), findsOneWidget);
  });
}
