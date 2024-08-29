import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:youapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:youapp/blocs/auth_bloc/auth_state.dart';
import 'package:youapp/blocs/profile_bloc/profile_bloc.dart';
import 'package:youapp/blocs/profile_bloc/profile_event.dart';
import 'package:youapp/blocs/profile_bloc/profile_state.dart';
import 'package:youapp/views/profile_screen.dart';
import 'package:youapp/widgets/profile_about_section.dart';
import 'package:youapp/widgets/profile_interests_section.dart';

@GenerateNiceMocks([MockSpec<AuthBloc>(), MockSpec<ProfileBloc>()])
import 'profile_screen_test.mocks.dart';

void main() {
  group(
    'ProfileScreen',
    () {
      late MockAuthBloc mockAuthBloc;
      late MockProfileBloc mockProfileBloc;

      setUp(() {
        mockAuthBloc = MockAuthBloc();
        mockProfileBloc = MockProfileBloc();
      });

      testWidgets(
        'renders loading screen when ProfileLoading',
        (WidgetTester tester) async {
          final authState = AuthSuccess({
            'access_token': 'test_token',
            'data': {
              'email': 'test@example.com',
              'username': 'test_user',
            }
          }, 'test_token');
          when(mockAuthBloc.state).thenReturn(authState);
          when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(authState));

          when(mockProfileBloc.state).thenReturn(ProfileLoading());
          when(mockProfileBloc.stream).thenAnswer(
            (_) => Stream.value(ProfileLoading()),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: MultiBlocProvider(
                providers: [
                  BlocProvider<AuthBloc>.value(value: mockAuthBloc),
                  BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
                ],
                child: const ProfileScreen(),
              ),
            ),
          );

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      );

      testWidgets(
        'renders error screen when ProfileFailure',
        (WidgetTester tester) async {
          final authState = AuthSuccess({
            'access_token': 'test_token',
            'data': {'email': 'test@example.com', 'username': 'test_user'}
          }, 'test_token');
          when(mockAuthBloc.state).thenReturn(authState);
          when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(authState));

          when(mockProfileBloc.state).thenReturn(
            ProfileFailure('Error message'),
          );
          when(mockProfileBloc.stream).thenAnswer(
            (_) => Stream.value(ProfileFailure('Error message')),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: MultiBlocProvider(
                providers: [
                  BlocProvider<AuthBloc>.value(value: mockAuthBloc),
                  BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
                ],
                child: const ProfileScreen(),
              ),
            ),
          );

          expect(find.text('Error: Error message'), findsOneWidget);
        },
      );

      testWidgets(
        'renders profile content when ProfileSuccess',
        (WidgetTester tester) async {
          final authState = AuthSuccess(
            {
              'access_token': 'test_token',
              'data': {
                'email': 'test@example.com',
                'username': 'test_user',
              }
            },
            'test_token',
          );
          when(mockAuthBloc.state).thenReturn(authState);
          when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(authState));

          final profileData = {
            'data': {
              'username': 'test_user',
              'name': 'Test User',
              'birthday': '1990-01-01 00:00:00.000',
              'height': 175,
              'weight': 70,
              'interests': ['Reading', 'Coding'],
            }
          };
          when(mockProfileBloc.state).thenReturn(ProfileSuccess(profileData));
          when(mockProfileBloc.stream).thenAnswer(
            (_) => Stream.value(ProfileSuccess(profileData)),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: MultiBlocProvider(
                providers: [
                  BlocProvider<AuthBloc>.value(value: mockAuthBloc),
                  BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
                ],
                child: const ProfileScreen(),
              ),
            ),
          );

          expect(find.text('@test_user,'), findsOneWidget);
          expect(find.byType(ProfileAboutSection), findsOneWidget);
          expect(find.byType(ProfileInterestsSection), findsOneWidget);
        },
      );

      testWidgets(
        'calls GetProfileEvent on init',
        (WidgetTester tester) async {
          final authState = AuthSuccess(
            {
              'access_token': 'test_token',
              'data': {
                'email': 'test@example.com',
                'username': 'test_user',
              }
            },
            'test_token',
          );
          when(mockAuthBloc.state).thenReturn(authState);
          when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(authState));

          when(mockProfileBloc.state).thenReturn(ProfileLoading());
          when(mockProfileBloc.stream).thenAnswer(
            (_) => Stream.value(ProfileLoading()),
          );

          when(mockProfileBloc.add(any)).thenReturn(
            // ignore: void_checks
            ProfileSuccess(
              const {
                'data': {
                  'name': 'John Doe',
                  'birthday': '1990-01-01 00:00:00.000',
                  'height': 175,
                  'weight': 70,
                },
              },
            ),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: MultiBlocProvider(
                providers: [
                  BlocProvider<AuthBloc>.value(value: mockAuthBloc),
                  BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
                ],
                child: const ProfileScreen(),
              ),
            ),
          );

          verify(mockProfileBloc.add(captureAny)).captured.forEach(
            expectAsync1(
              (event) {
                expect(event, isA<GetProfileEvent>());
              },
            ),
          );
        },
      );
    },
  );
}
