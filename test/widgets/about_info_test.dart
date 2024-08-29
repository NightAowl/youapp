import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:youapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:youapp/blocs/auth_bloc/auth_state.dart';
import 'package:youapp/blocs/profile_bloc/profile_bloc.dart';
import 'package:youapp/blocs/profile_bloc/profile_state.dart';
import 'package:youapp/utils/zodiac_horoscope_calculator.dart';
import 'package:youapp/widgets/about_info.dart';

@GenerateNiceMocks([MockSpec<AuthBloc>(), MockSpec<ProfileBloc>()])
import 'about_info_test.mocks.dart';

void main() {
  group(
    'AboutInfo',
    () {
      late MockAuthBloc mockAuthBloc;
      late MockProfileBloc mockProfileBloc;

      setUp(() {
        mockAuthBloc = MockAuthBloc();
        mockProfileBloc = MockProfileBloc();
      });

      testWidgets(
        'renders CircularProgressIndicator when ProfileLoading',
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

          final profileState = ProfileLoading();
          when(mockProfileBloc.state).thenReturn(profileState);
          when(mockProfileBloc.stream).thenAnswer(
            (_) => Stream.value(profileState),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: MultiBlocProvider(
                providers: [
                  BlocProvider<AuthBloc>.value(value: mockAuthBloc),
                  BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
                ],
                child: const AboutInfo(),
              ),
            ),
          );

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      );

      testWidgets(
        'renders profile info when ProfileSuccess',
        (WidgetTester tester) async {
          final authState = AuthSuccess({}, 'token');
          when(mockAuthBloc.state).thenReturn(authState);
          when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(authState));

          final profileState = ProfileSuccess(
            const {
              'data': {
                'birthday': '1990-01-01 00:00:00.000',
                'height': 175,
                'weight': 70,
              },
            },
          );
          when(mockProfileBloc.state).thenReturn(profileState);
          when(mockProfileBloc.stream).thenAnswer(
            (_) => Stream.value(profileState),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: MultiBlocProvider(
                providers: [
                  BlocProvider<AuthBloc>.value(value: mockAuthBloc),
                  BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
                ],
                child: const AboutInfo(),
              ),
            ),
          );

          final horoscope = ZodiacHoroscopeCalculator.getHoroscope(
            DateTime.parse('1990-01-01 00:00:00.000'),
          );
          final zodiac = ZodiacHoroscopeCalculator.getZodiac(
            DateTime.parse('1990-01-01 00:00:00.000'),
          );

          const expectedBirthdayText = 'Birthday: 01 / 01 / 1990 (Age 34)';
          final expectedHoroscopeText = 'Horoscope: $horoscope';
          final expectedZodiacText = 'Zodiac: $zodiac';
          const expectedHeightText = 'Height: 175 cm';
          const expectedWeightText = 'Weight: 70 kg';

          expect(
            find.text(expectedBirthdayText, findRichText: true),
            findsOneWidget,
          );
          expect(
            find.text(expectedHoroscopeText, findRichText: true),
            findsOneWidget,
          );
          expect(
            find.text(expectedZodiacText, findRichText: true),
            findsOneWidget,
          );
          expect(
            find.text(expectedHeightText, findRichText: true),
            findsOneWidget,
          );
          expect(
            find.text(expectedWeightText, findRichText: true),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders error message when ProfileFailure',
        (WidgetTester tester) async {
          final authState = AuthSuccess({}, 'token');
          when(mockAuthBloc.state).thenReturn(authState);
          when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(authState));

          final profileState = ProfileFailure('Failed to load profile');
          when(mockProfileBloc.state).thenReturn(profileState);
          when(mockProfileBloc.stream).thenAnswer(
            (_) => Stream.value(profileState),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: MultiBlocProvider(
                providers: [
                  BlocProvider<AuthBloc>.value(value: mockAuthBloc),
                  BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
                ],
                child: const AboutInfo(),
              ),
            ),
          );

          expect(find.text('Failed to load profile info'), findsOneWidget);
        },
      );

      testWidgets(
        'renders placeholder text when no profile info',
        (WidgetTester tester) async {
          final authState = AuthSuccess({}, 'token');
          when(mockAuthBloc.state).thenReturn(authState);
          when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(authState));

          final profileState = ProfileSuccess(
            const {
              'data': {
                'birthday': '',
                'height': null,
                'weight': null,
              }
            },
          );
          when(mockProfileBloc.state).thenReturn(profileState);
          when(mockProfileBloc.stream).thenAnswer(
            (_) => Stream.value(profileState),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: MultiBlocProvider(
                providers: [
                  BlocProvider<AuthBloc>.value(value: mockAuthBloc),
                  BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
                ],
                child: const AboutInfo(),
              ),
            ),
          );

          expect(
            find.text('Add in your info to help others know you better'),
            findsOneWidget,
          );
        },
      );
    },
  );
}
