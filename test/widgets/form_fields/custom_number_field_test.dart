import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youapp/widgets/form_fields/custom_number_field.dart';

void main() {
  testWidgets(
    'CustomNumberField widget test',
    (WidgetTester tester) async {
      const String label = 'Height';
      const String suffixText = 'cm';
      final TextEditingController controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomNumberField(
              label: label,
              controller: controller,
              suffixText: suffixText,
            ),
          ),
        ),
      );

      expect(find.text('$label:'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text(suffixText), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), '175');
      await tester.pumpAndSettle();

      expect(controller.text, '175');
    },
  );
}
