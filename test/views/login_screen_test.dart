import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:youapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:youapp/blocs/auth_bloc/auth_event.dart';
import 'package:youapp/blocs/auth_bloc/auth_state.dart';
import 'package:youapp/blocs/profile_bloc/profile_bloc.dart';
import 'package:youapp/blocs/profile_bloc/profile_state.dart';
import 'package:youapp/views/login_screen.dart';
import 'package:youapp/views/profile_screen.dart';
import 'package:youapp/widgets/form_fields/custom_input_field.dart';
import 'package:youapp/widgets/gradient_filled_button.dart';

@GenerateNiceMocks([MockSpec<AuthBloc>(), MockSpec<ProfileBloc>()])
import 'login_screen_test.mocks.dart';

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockProfileBloc mockProfileBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockProfileBloc = MockProfileBloc();
  });

  Widget createWidgetUnderTest(AuthState authState) {
    when(mockAuthBloc.state).thenReturn(authState);
    when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(authState));

    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: BlocProvider(
          create: (context) => mockProfileBloc,
          child: const LoginScreen(),
        ),
      ),
      routes: {
        ProfileScreen.routeName: (_) => const ProfileScreen(),
      },
    );
  }

  testWidgets(
    'LoginScreen displays correctly',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(AuthInitial()));

      expect(find.text('Login'), findsNWidgets(2));
      expect(find.byType(CustomInputField), findsNWidgets(2));
      expect(find.text('Enter Username/Email'), findsOneWidget);
      expect(find.text('Enter Password'), findsOneWidget);
      expect(find.text('No account?'), findsOneWidget);
      expect(find.text('Register here'), findsOneWidget);
    },
  );

  testWidgets(
    'Login button is disabled when fields are empty',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(AuthInitial()));

      final loginButton = find.widgetWithText(GradientFilledButton, 'Login');
      expect(
        tester.widget<GradientFilledButton>(loginButton).isEnabled,
        isFalse,
      );
    },
  );

  testWidgets(
    'Login button is enabled when fields are filled',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(AuthInitial()));

      await tester.enterText(
        find.byType(TextField).first,
        'test@example.com',
      );
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.pumpAndSettle();

      final loginButton = find.widgetWithText(GradientFilledButton, 'Login');
      expect(
        tester.widget<GradientFilledButton>(loginButton).isEnabled,
        isTrue,
      );
    },
  );

  testWidgets(
    'Tapping login button adds LoginEvent to AuthBloc',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(AuthInitial()));

      await tester.enterText(
        find.byType(TextField).first,
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextField).last,
        'password123',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(GradientFilledButton, 'Login'));
      await tester.pumpAndSettle();

      final capturedEvents = verify(mockAuthBloc.add(captureAny)).captured;
      expect(capturedEvents.length, 1);

      final loginEvent = capturedEvents.first as LoginEvent;
      expect(loginEvent.email, 'test@example.com');
      expect(loginEvent.password, 'password123');
    },
  );

  testWidgets(
    'Shows loading indicator when AuthLoading state is emitted',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(AuthLoading()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'Shows error message when AuthFailure state is emitted',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          AuthFailure('Login failed'),
        ),
      );
      await tester.pump();

      expect(find.text('Login failed'), findsOneWidget);
    },
  );

  testWidgets(
    'Tapping login button adds LoginEvent to AuthBloc and navigates to ProfileScreen on success',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(AuthInitial()));

      await tester.enterText(
        find.byType(TextField).first,
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextField).last,
        'password123',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(GradientFilledButton, 'Login'));
      await tester.pumpAndSettle();

      final capturedEvents = verify(mockAuthBloc.add(captureAny)).captured;
      expect(capturedEvents.length, 1);

      final loginEvent = capturedEvents.first as LoginEvent;
      expect(loginEvent.email, 'test@example.com');
      expect(loginEvent.password, 'password123');

      when(mockAuthBloc.state).thenReturn(
        AuthSuccess(
          {
            'access_token': 'test_token',
            'data': {
              'email': 'test@example.com',
              'username': 'tester',
            }
          },
          'test_token',
        ),
      );

      when(mockAuthBloc.stream).thenAnswer(
        (_) => Stream.value(
          AuthSuccess(
            {
              'access_token': 'test_token',
              'data': {
                'email': 'test@example.com',
                'username': 'tester',
              }
            },
            'test_token',
          ),
        ),
      );

      when(mockProfileBloc.state).thenReturn(ProfileLoading());
      when(mockProfileBloc.stream).thenAnswer(
        (_) => Stream.fromIterable(
          [
            ProfileLoading(),
            ProfileSuccess(
              const {
                'data': {
                  'username': 'tester',
                  'name': 'Test User',
                  'birthday': '1990-01-01 00:00:00.000',
                  'height': 175,
                  'weight': 70,
                  'interests': ['Reading', 'Coding'],
                }
              },
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);
    },
  );
}
