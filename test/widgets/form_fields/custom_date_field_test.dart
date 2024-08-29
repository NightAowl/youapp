import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:youapp/widgets/form_fields/custom_date_field.dart';

void main() {
  testWidgets(
    'CustomDateField widget test',
    (WidgetTester tester) async {
      const String label = 'Date of Birth';
      final TextEditingController controller = TextEditingController();
      late DateTime selectedDate;

      void onDateSelected(DateTime date) {
        selectedDate = date;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDateField(
              label: label,
              controller: controller,
              onDateSelected: onDateSelected,
            ),
          ),
        ),
      );

      expect(find.text('$label:'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(controller.text, isEmpty);

      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      final DateTime selectedDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      await tester.tap(find.text(DateFormat('dd').format(selectedDateTime)));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(controller.text, isNotEmpty);
      expect(selectedDate, isNotNull);
      expect(selectedDate, selectedDateTime);
    },
  );
}
