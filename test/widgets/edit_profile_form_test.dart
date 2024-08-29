import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:youapp/utils/zodiac_horoscope_calculator.dart';
import 'package:youapp/widgets/edit_profile_form.dart';
import 'package:youapp/widgets/form_fields/custom_date_field.dart';
import 'package:youapp/widgets/form_fields/custom_dropdown_field.dart';
import 'package:youapp/widgets/form_fields/custom_form_field.dart';
import 'package:youapp/widgets/form_fields/custom_number_field.dart';
import 'package:youapp/widgets/image_picker.dart';

void main() {
  group(
    'EditProfileForm',
    () {
      late Map<String, dynamic> profile;
      late Function(Map<String, dynamic>) onSaveMock;

      setUp(() {
        profile = {
          'name': 'John Doe',
          'birthday': '1990-01-01 00:00:00.000',
          'height': 180,
          'weight': 80,
        };
        onSaveMock = (data) {};
      });

      testWidgets(
        'renders all form fields',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ListView(
                  children: [
                    EditProfileForm(
                      profile: profile,
                      onSave: onSaveMock,
                    ),
                  ],
                ),
              ),
            ),
          );

          expect(find.byType(CustomImagePicker), findsOneWidget);
          expect(find.byType(CustomFormField), findsNWidgets(3));
          expect(find.byType(CustomDropdownField), findsOneWidget);
          expect(find.byType(CustomDateField), findsOneWidget);
          expect(find.byType(CustomNumberField), findsNWidgets(2));
          expect(find.byType(TextButton), findsOneWidget);
        },
      );

      testWidgets(
        'populates form fields with profile data',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ListView(
                  children: [
                    EditProfileForm(
                      profile: profile,
                      onSave: onSaveMock,
                    ),
                  ],
                ),
              ),
            ),
          );

          expect(find.text('John Doe'), findsOneWidget);
          expect(
            find.text(
              DateFormat('dd MM yyyy').format(
                DateTime.parse(profile['birthday']),
              ),
            ),
            findsOneWidget,
          );
          expect(
            find.text(
              ZodiacHoroscopeCalculator.getHoroscope(
                DateTime.parse(profile['birthday']),
              ),
            ),
            findsOneWidget,
          );
          expect(
            find.text(
              ZodiacHoroscopeCalculator.getZodiac(
                DateTime.parse(profile['birthday']),
              ),
            ),
            findsOneWidget,
          );
          expect(find.text('180'), findsOneWidget);
          expect(find.text('80'), findsOneWidget);
        },
      );

      testWidgets(
        'calls onSave callback with updated profile data',
        (tester) async {
          final currentDate = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          );
          final profile = {
            'name': 'John Doe',
            'birthday': '1990-01-01 00:00:00.000',
            'height': 180,
            'weight': 80,
          };
          final updatedProfile = {
            'name': 'Jane Doe',
            'birthday': currentDate.toString(),
            'height': 170,
            'weight': 60,
          };

          bool onSaveCallbackTriggered = false;
          void onSaveMock(data) {
            expect(data, updatedProfile);
            onSaveCallbackTriggered = true;
          }

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ListView(
                  children: [
                    EditProfileForm(
                      profile: profile,
                      onSave: onSaveMock,
                    ),
                  ],
                ),
              ),
            ),
          );

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
          await tester.ensureVisible(find.text('Save & Update'));
          await tester.tap(find.text('Save & Update'));
          await tester.pumpAndSettle();

          expect(onSaveCallbackTriggered, isTrue);
        },
      );
    },
  );
}
