import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youapp/widgets/form_fields/custom_form_field.dart';

void main() {
  testWidgets(
    'CustomFormField widget test',
    (WidgetTester tester) async {
      const String label = 'Name';
      final TextEditingController controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomFormField(
              label: label,
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('$label:'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(controller.text, isEmpty);

      await tester.enterText(find.byType(TextFormField), 'John Doe');
      await tester.pumpAndSettle();

      expect(controller.text, 'John Doe');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomFormField(
              label: label,
              controller: controller,
              readOnly: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'Jane Doe');
      await tester.pumpAndSettle();

      expect(controller.text, 'John Doe');
    },
  );
}
