import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youapp/widgets/form_fields/custom_input_field.dart';

void main() {
  group(
    'CustomInputField',
    () {
      testWidgets(
        'calls onSubmitted when text is submitted',
        (WidgetTester tester) async {
          final controller = TextEditingController();
          String submittedText = '';

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: CustomInputField(
                  hintText: 'Enter text',
                  controller: controller,
                  onChanged: (_) {},
                  onSubmitted: (value) => submittedText = value,
                ),
              ),
            ),
          );

          await tester.enterText(find.byType(TextField), 'Test input');
          await tester.testTextInput.receiveAction(TextInputAction.done);

          expect(submittedText, 'Test input');
        },
      );

      testWidgets(
        'calls onChanged when text changes',
        (WidgetTester tester) async {
          final controller = TextEditingController();
          String changedText = '';

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: CustomInputField(
                  hintText: 'Enter text',
                  controller: controller,
                  onChanged: (value) => changedText = value,
                  onSubmitted: (_) {},
                ),
              ),
            ),
          );

          await tester.enterText(find.byType(TextField), 'Test input');

          expect(changedText, 'Test input');
        },
      );

      testWidgets(
        'obscureText toggles visibility when suffix icon is tapped',
        (WidgetTester tester) async {
          final controller = TextEditingController();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: CustomInputField(
                  hintText: 'Enter password',
                  obscureText: true,
                  controller: controller,
                  onChanged: (_) {},
                  onSubmitted: (_) {},
                ),
              ),
            ),
          );

          expect(find.byIcon(Icons.visibility_off), findsOneWidget);

          await tester.tap(find.byType(IconButton));
          await tester.pump();

          expect(find.byIcon(Icons.visibility), findsOneWidget);

          await tester.tap(find.byType(IconButton));
          await tester.pump();

          expect(find.byIcon(Icons.visibility_off), findsOneWidget);
        },
      );

      testWidgets(
        'renders correctly with provided properties',
        (WidgetTester tester) async {
          final controller = TextEditingController();
          final focusNode = FocusNode();
          const suffixIcon = Icon(Icons.search);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: CustomInputField(
                  hintText: 'Custom hint',
                  obscureText: false,
                  controller: controller,
                  onChanged: (_) {},
                  onSubmitted: (_) {},
                  focusNode: focusNode,
                  suffixIcon: suffixIcon,
                ),
              ),
            ),
          );

          final textField = tester.widget<TextField>(find.byType(TextField));

          expect(find.text('Custom hint'), findsOneWidget);
          expect(textField.obscureText, isFalse);
          expect(textField.controller, controller);
          expect(textField.focusNode, focusNode);
          expect(find.byWidget(suffixIcon), findsOneWidget);
        },
      );
    },
  );
}
