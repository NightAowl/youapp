import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youapp/widgets/form_fields/custom_dropdown_field.dart';

void main() {
  testWidgets(
    'CustomDropdownField widget test',
    (WidgetTester tester) async {
      const String label = 'Gender';
      final TextEditingController controller = TextEditingController();
      final List<String> items = ['Male', 'Female', 'Other'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDropdownField(
              label: label,
              controller: controller,
              items: items,
            ),
          ),
        ),
      );

      expect(find.text('$label:'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      expect(controller.text, isEmpty);

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);
      expect(find.text('Other'), findsOneWidget);

      await tester.tap(find.text('Female'));
      await tester.pumpAndSettle();

      expect(controller.text, 'Female');
    },
  );
}
