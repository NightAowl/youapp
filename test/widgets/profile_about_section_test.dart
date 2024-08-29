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
import 'package:youapp/widgets/about_info.dart';
import 'package:youapp/widgets/edit_profile_form.dart';
import 'package:youapp/widgets/form_fields/custom_dropdown_field.dart';
import 'package:youapp/widgets/form_fields/custom_form_field.dart';
import 'package:youapp/widgets/form_fields/custom_number_field.dart';
import 'package:youapp/widgets/profile_about_header.dart';
import 'package:youapp/widgets/profile_about_section.dart';

@GenerateNiceMocks([MockSpec<AuthBloc>(), MockSpec<ProfileBloc>()])
import 'profile_about_section_test.mocks.dart';

void main() {
  group(
    'ProfileAboutSection',
    () {
      late MockAuthBloc mockAuthBloc;
      late MockProfileBloc mockProfileBloc;
      setUp(() {
        mockAuthBloc = MockAuthBloc();
        mockProfileBloc = MockProfileBloc();
      });

      testWidgets(
        'renders correctly when ProfileSuccess',
        (WidgetTester tester) async {
          const profile = {
            'data': {
              'birthday': '1990-01-01 00:00:00.000',
              'height': 175,
              'weight': 70,
            },
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

          final profileState = ProfileSuccess(profile);
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
                child: Scaffold(
                  body: ListView(
                    children: const [
                      ProfileAboutSection(profile: profile),
                    ],
                  ),
                ),
              ),
            ),
          );

          expect(find.byType(ProfileAboutHeader), findsOneWidget);
          expect(find.byType(AboutInfo), findsOneWidget);
          expect(find.byType(EditProfileForm), findsNothing);
        },
      );

      testWidgets(
        'switches to edit mode when edit icon is tapped',
        (WidgetTester tester) async {
          final profile = {
            'data': {
              'name': 'John Doe',
              'birthday': '1990-01-01 00:00:00.000',
              'height': 175,
              'weight': 70,
            },
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

          final profileState = ProfileSuccess(profile);
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
                child: Scaffold(
                  body: ListView(
                    children: [
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          if (state is ProfileSuccess) {
                            final Map<String, dynamic> profileData =
                                state.data['data'];
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
        },
      );

      testWidgets(
        'calls handleSave with updated profile data',
        (tester) async {
          final currentDate = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          );

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

          when(mockProfileBloc.state).thenReturn(
            ProfileSuccess({'data': updatedProfile}),
          );
          when(mockProfileBloc.stream).thenAnswer(
            (_) => Stream.value(ProfileSuccess({'data': updatedProfile})),
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
                      ProfileAboutSection(profile: updatedProfile),
                    ],
                  ),
                ),
              ),
            ),
          );

          await tester.tap(find.byIcon(Icons.edit));
          await tester.pumpAndSettle();

          await tester.enterText(
            find.byType(CustomFormField).at(0),
            'Jane Doe',
          );

          await tester.tap(find.byType(CustomDropdownField).first);
          await tester.pumpAndSettle();
          await tester.tap(find.text('Female'));

          final customDateFieldFinder = find.byKey(
            const Key('custom_date_field'),
          );

          await tester.pumpAndSettle();
          await tester.tap(customDateFieldFinder);
          await tester.pumpAndSettle();

          await tester.tap(find.text(currentDate.day.toString()));
          await tester.pumpAndSettle();
          await tester.tap(find.text('OK'));
          await tester.pumpAndSettle();

          await tester.enterText(find.byType(CustomNumberField).at(0), '170');
          await tester.pumpAndSettle();
          await tester.enterText(find.byType(CustomNumberField).at(1), '60');

          await tester.pumpAndSettle();
          await tester.ensureVisible(find.byKey(const Key('save_button')));
          await tester.tap(find.byKey(const Key('save_button')));
          await tester.pumpAndSettle();

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
        },
      );
    },
  );
}
