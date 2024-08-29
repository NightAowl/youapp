import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:youapp/blocs/auth_bloc/auth_event.dart';
import 'package:youapp/blocs/profile_bloc/profile_bloc.dart';
import 'package:youapp/blocs/profile_bloc/profile_event.dart';
import 'package:youapp/blocs/profile_bloc/profile_state.dart';
import 'package:youapp/main.dart' as app;
import 'package:youapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:youapp/blocs/auth_bloc/auth_state.dart';
import 'package:mockito/mockito.dart';
import 'package:youapp/views/add_interest_screen.dart';
import 'package:youapp/views/login_screen.dart';
import 'package:youapp/views/profile_screen.dart';
import 'package:youapp/widgets/about_info.dart';
import 'package:youapp/widgets/edit_profile_form.dart';
import 'package:youapp/widgets/form_fields/custom_dropdown_field.dart';
import 'package:youapp/widgets/form_fields/custom_form_field.dart';
import 'package:youapp/widgets/form_fields/custom_number_field.dart';
import 'package:youapp/widgets/gradient_filled_button.dart';
import 'package:youapp/widgets/profile_about_header.dart';
import 'package:youapp/widgets/profile_about_section.dart';
import 'package:youapp/widgets/profile_interests_section.dart';

@GenerateNiceMocks([
  MockSpec<AuthBloc>(),
  MockSpec<ProfileBloc>(),
  MockSpec<NavigatorObserver>(),
])
import 'app_test.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthBloc mockAuthBloc;
  late MockProfileBloc mockProfileBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockProfileBloc = MockProfileBloc();
  });

  group(
    'End-to-end test',
    () {
      testWidgets(
        'Full user journey',
        (WidgetTester tester) async {
          app.main();
          await tester.pumpAndSettle();

          // Test Registration
          await registrationTest(
            tester: tester,
            mockAuthBloc: mockAuthBloc,
          );

          // Test Login
          await loginTest(
            tester: tester,
            mockAuthBloc: mockAuthBloc,
            mockProfileBloc: mockProfileBloc,
          );

          // Test Viewing Profile
          await viewProfileTest(
            tester: tester,
            mockAuthBloc: mockAuthBloc,
            mockProfileBloc: mockProfileBloc,
          );

          // Test Editing Profile
          await editProfileTest(
            tester: tester,
            mockAuthBloc: mockAuthBloc,
            mockProfileBloc: mockProfileBloc,
          );

          // Test Adding Interests
          await addInterestTest(
            tester: tester,
            mockAuthBloc: mockAuthBloc,
            mockProfileBloc: mockProfileBloc,
          );
        },
      );
    },
  );
}

Future<void> registrationTest({
  required WidgetTester tester,
  required MockAuthBloc mockAuthBloc,
}) async {
  await tester.tap(find.text('Register'));
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
  await tester.enterText(find.byType(TextField).at(1), 'tester');
  await tester.enterText(find.byType(TextField).at(2), 'password123');
  await tester.enterText(find.byType(TextField).at(3), 'password123');
  await tester.pumpAndSettle();

  final registerButton = find.widgetWithText(GradientFilledButton, 'Register');
  expect(tester.widget<GradientFilledButton>(registerButton).isEnabled, isTrue);
  await tester.tap(registerButton);
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

  expect(find.byType(LoginScreen), findsOneWidget);
}

Future<void> loginTest({
  required WidgetTester tester,
  required MockAuthBloc mockAuthBloc,
  required MockProfileBloc mockProfileBloc,
}) async {
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField).first, 'test@example.com');
  await tester.enterText(find.byType(TextField).last, 'password123');
  await tester.pumpAndSettle();

  final loginButton = find.widgetWithText(GradientFilledButton, 'Login');
  expect(tester.widget<GradientFilledButton>(loginButton).isEnabled, isTrue);
  await tester.tap(loginButton);
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
}

Future<void> viewProfileTest({
  required WidgetTester tester,
  required MockAuthBloc mockAuthBloc,
  required MockProfileBloc mockProfileBloc,
}) async {
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
  expect(find.text('@tester,'), findsOneWidget);
  expect(find.byType(ProfileAboutSection), findsOneWidget);
  expect(find.byType(ProfileInterestsSection), findsOneWidget);
}

Future<void> editProfileTest({
  required WidgetTester tester,
  required MockAuthBloc mockAuthBloc,
  required MockProfileBloc mockProfileBloc,
}) async {
  final currentDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  final initialProfile = {
    'data': {
      'name': 'John Doe',
      'birthday': '1990-01-01 00:00:00.000',
      'height': 175,
      'weight': 70,
    },
  };

  final updatedProfile = {
    'name': 'Jane Doe',
    'birthday': currentDate.toString(),
    'height': 170,
    'weight': 60,
  };

  final authState = AuthSuccess(
    {
      'access_token': 'test_token',
      'data': {
        'email': 'test@example.com',
        'username': 'test_user',
      },
    },
    'test_token',
  );

  when(mockAuthBloc.state).thenReturn(authState);
  when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(authState));

  when(mockProfileBloc.state).thenReturn(ProfileSuccess(initialProfile));
  when(mockProfileBloc.stream).thenAnswer(
    (_) => Stream.fromIterable(
      [
        ProfileSuccess(initialProfile),
        ProfileSuccess({'data': updatedProfile}),
      ],
    ),
  );

  when(mockProfileBloc.add(any)).thenReturn(null);

  await tester.pumpWidget(
    MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: Scaffold(
          body: ListView(
            children: [
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileSuccess) {
                    final Map<String, dynamic> profileData = state.data['data'];
                    return ProfileAboutSection(profile: profileData);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );

  expect(find.byType(ProfileAboutHeader), findsOneWidget);
  expect(find.byType(AboutInfo), findsOneWidget);
  expect(find.byType(EditProfileForm), findsNothing);

  await tester.tap(find.byIcon(Icons.edit));
  await tester.pumpAndSettle();

  expect(find.byType(ProfileAboutHeader), findsOneWidget);
  expect(find.byType(AboutInfo), findsNothing);
  expect(find.byType(EditProfileForm), findsOneWidget);

  await tester.enterText(find.byType(CustomFormField).at(0), 'Jane Doe');
  await tester.tap(find.byType(CustomDropdownField).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Female'));

  final customDateFieldFinder = find.byKey(const Key('custom_date_field'));
  await tester.tap(customDateFieldFinder);
  await tester.pumpAndSettle();
  await tester.tap(find.text(currentDate.day.toString()));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(CustomNumberField).at(0), '170');
  await tester.enterText(find.byType(CustomNumberField).at(1), '60');

  await tester.pumpAndSettle();
  await tester.ensureVisible(find.byKey(const Key('save_button')));
  await tester.tap(find.byKey(const Key('save_button')));
  await tester.pumpAndSettle();

  final capturedEvents = verify(mockProfileBloc.add(captureAny)).captured;

  expect(capturedEvents.whereType<UpdateProfileEvent>().length, 1);
  expect(capturedEvents.whereType<GetProfileEvent>().length, 1);
}

Future<void> addInterestTest({
  required WidgetTester tester,
  required MockAuthBloc mockAuthBloc,
  required MockProfileBloc mockProfileBloc,
}) async {
  final initialInterests = ['Reading', 'Music'];

  when(mockAuthBloc.state).thenReturn(
    AuthSuccess(
      {
        'access_token': 'test_token',
        'data': {
          'email': 'test@example.com',
          'username': 'test_user',
        },
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
            'username': 'test_user',
          },
        },
        'test_token',
      ),
    ),
  );

  when(mockProfileBloc.state).thenReturn(
    ProfileSuccess(
      {
        'data': {'interests': initialInterests}
      },
    ),
  );
  when(mockProfileBloc.stream).thenAnswer(
    (_) => Stream.value(
      ProfileSuccess(
        {
          'data': {'interests': initialInterests}
        },
      ),
    ),
  );

  when(mockProfileBloc.add(any)).thenAnswer((invocation) {
    final event = invocation.positionalArguments.first as UpdateProfileEvent;
    if (event.interests.contains('Fail')) {
      throw Exception('Failed to save');
    }
    return;
  });

  await tester.pumpWidget(
    MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const AddInterestScreen(),
              settings: RouteSettings(
                arguments: initialInterests,
              ),
            );
          },
        ),
      ),
    ),
  );

  await tester.enterText(find.byType(TextField).at(0), 'Cooking');
  await tester.enterText(find.byType(TextField).at(1), 'Travel');
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();

  final capturedEvents = verify(mockProfileBloc.add(captureAny)).captured;

  expect(
    capturedEvents.whereType<UpdateProfileEvent>().length,
    1,
  );

  expect(
    capturedEvents.whereType<GetProfileEvent>().length,
    1,
  );

  final updateEvent = capturedEvents.firstWhere(
    (e) => e is UpdateProfileEvent,
  ) as UpdateProfileEvent;
  expect(updateEvent.token, 'test_token');
  expect(updateEvent.interests, ['Reading', 'Music', 'Cooking', 'Travel']);

  expect(find.byType(SnackBar), findsOneWidget);
  expect(find.text('Interests saved successfully'), findsOneWidget);

  // Test failure scenario
  when(mockProfileBloc.add(any)).thenAnswer((invocation) {
    throw Exception('Failed to save');
  });

  await tester.enterText(find.byType(TextField).at(0), 'Fail');
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();

  expect(find.byType(SnackBar), findsOneWidget);
  expect(find.text('Failed to save interests'), findsOneWidget);
}
