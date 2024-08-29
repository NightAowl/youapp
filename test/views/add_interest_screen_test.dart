import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:youapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:youapp/blocs/auth_bloc/auth_state.dart';
import 'package:youapp/blocs/profile_bloc/profile_bloc.dart';
import 'package:youapp/blocs/profile_bloc/profile_event.dart';
import 'package:youapp/blocs/profile_bloc/profile_state.dart';
import 'package:youapp/views/add_interest_screen.dart';

@GenerateMocks([AuthBloc, ProfileBloc])
import 'add_interest_screen_test.mocks.dart';

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockProfileBloc mockProfileBloc;
  final List<String> initialInterests = ['Reading', 'Music'];

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockProfileBloc = MockProfileBloc();
  });

  testWidgets(
    'AddInterestScreen saves interests and navigates back',
    (WidgetTester tester) async {
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

      when(mockProfileBloc.state).thenReturn(
        ProfileSuccess(const {'data': {}}),
      );
      when(mockProfileBloc.stream).thenAnswer(
        (_) => Stream.value(ProfileSuccess(const {'data': {}})),
      );

      when(mockProfileBloc.add(any)).thenReturn(null);

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

      for (final interest in initialInterests) {
        expect(find.text(interest), findsOneWidget);
      }

      await tester.enterText(find.byType(TextField), 'Cooking');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Travel');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 1));

      final capturedEvents = verify(
        mockProfileBloc.add(captureAny),
      ).captured;

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
    },
  );

  testWidgets('AddInterestScreen shows error when saving fails',
      (WidgetTester tester) async {
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

    when(mockProfileBloc.state).thenReturn(ProfileSuccess(const {'data': {}}));
    when(mockProfileBloc.stream).thenAnswer(
      (_) => Stream.value(ProfileSuccess(const {'data': {}})),
    );

    when(mockProfileBloc.add(any)).thenThrow(Exception('Failed to save'));

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

    await tester.enterText(find.byType(TextField), 'Cooking');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Failed to save interests'), findsOneWidget);
  });
}
