import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:youapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:youapp/blocs/auth_bloc/auth_event.dart';
import 'package:youapp/blocs/auth_bloc/auth_state.dart';
import 'package:youapp/views/register_screen.dart';
import 'package:youapp/views/login_screen.dart';
import 'package:youapp/widgets/form_fields/custom_input_field.dart';
import 'package:youapp/widgets/gradient_filled_button.dart';

@GenerateNiceMocks([MockSpec<AuthBloc>(), MockSpec<NavigatorObserver>()])
import 'register_screen_test.mocks.dart';

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockObserver = MockNavigatorObserver();
  });

  Widget createWidgetUnderTest(AuthState authState) {
    when(mockAuthBloc.state).thenReturn(authState);
    when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(authState));

    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const RegisterScreen(),
      ),
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
      },
    );
  }

  testWidgets(
    'RegisterScreen displays correctly',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(AuthInitial()));

      expect(find.text('Register'), findsNWidgets(2));
      expect(find.byType(CustomInputField), findsNWidgets(4));
      expect(find.text('Enter Email'), findsOneWidget);
      expect(find.text('Create Username'), findsOneWidget);
      expect(find.text('Create Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Have an account?'), findsOneWidget);
      expect(find.text('Login here'), findsOneWidget);
    },
  );

  testWidgets(
    'Register button is disabled when fields are empty',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(AuthInitial()));

      final registerButton = find.widgetWithText(
        GradientFilledButton,
        'Register',
      );
      expect(
        tester.widget<GradientFilledButton>(registerButton).isEnabled,
        isFalse,
      );
    },
  );

  testWidgets(
    'Register button is enabled when all fields are filled',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(AuthInitial()));

      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'tester');
      await tester.enterText(find.byType(TextField).at(2), 'password123');
      await tester.enterText(find.byType(TextField).at(3), 'password123');
      await tester.pumpAndSettle();

      final registerButton = find.widgetWithText(
        GradientFilledButton,
        'Register',
      );
      expect(
        tester.widget<GradientFilledButton>(registerButton).isEnabled,
        isTrue,
      );
    },
  );

  testWidgets(
    'Tapping register button adds RegisterEvent to AuthBloc',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(AuthInitial()));

      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'tester');
      await tester.enterText(find.byType(TextField).at(2), 'password123');
      await tester.enterText(find.byType(TextField).at(3), 'password123');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(GradientFilledButton, 'Register'));
      await tester.pumpAndSettle();

      final capturedEvents = verify(mockAuthBloc.add(captureAny)).captured;
      expect(capturedEvents.length, 1);

      final registerEvent = capturedEvents.first as RegisterEvent;
      expect(registerEvent.email, 'test@example.com');
      expect(registerEvent.username, 'tester');
      expect(registerEvent.password, 'password123');
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
          AuthFailure('Registration failed'),
        ),
      );
      await tester.pump();

      expect(find.text('Registration failed'), findsOneWidget);
    },
  );

  testWidgets('Navigates to LoginScreen on successful registration',
      (WidgetTester tester) async {
    when(mockAuthBloc.state).thenReturn(AuthInitial());
    when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthInitial()));

    when(
      mockObserver.didReplace(
        newRoute: anyNamed(LoginScreen.routeName),
        oldRoute: anyNamed(RegisterScreen.routeName),
      ),
    ).thenAnswer((_) {
      mockObserver.navigator?.pushReplacementNamed(LoginScreen.routeName);
    });

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const RegisterScreen(),
        ),
        navigatorObservers: [mockObserver],
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
        },
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'tester');
    await tester.enterText(find.byType(TextField).at(2), 'password123');
    await tester.enterText(find.byType(TextField).at(3), 'password123');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(GradientFilledButton, 'Register'));
    await tester.pumpAndSettle();

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

    await tester.pumpAndSettle();

    final capturedCalls = verify(
      mockObserver.didReplace(
        newRoute: anyNamed(LoginScreen.routeName),
        oldRoute: anyNamed(RegisterScreen.routeName),
      ),
    ).captured;
    expect(capturedCalls.length, 1);

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets(
    'Navigate to login screen when "Login here" is tapped',
    (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const RegisterScreen(),
          ),
          routes: {
            LoginScreen.routeName: (context) => const LoginScreen(),
          },
          navigatorObservers: [mockObserver],
        ),
      );

      expect(find.text('Register'), findsNWidgets(2));

      final loginHereButton = find.text('Login here');
      expect(loginHereButton, findsOneWidget);

      await tester.tap(loginHereButton);
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any)).called(1);

      expect(find.byType(LoginScreen), findsOneWidget);
    },
  );
}
