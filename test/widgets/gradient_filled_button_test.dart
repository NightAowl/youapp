import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youapp/widgets/gradient_filled_button.dart';

void main() {
  group(
    'GradientFilledButton',
    () {
      testWidgets(
        'renders correctly when enabled',
        (WidgetTester tester) async {
          bool buttonPressed = false;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: GradientFilledButton(
                  text: 'Enabled Button',
                  onPressed: () => buttonPressed = true,
                  isEnabled: true,
                ),
              ),
            ),
          );

          final buttonFinder = find.byType(GradientFilledButton);
          expect(buttonFinder, findsOneWidget);

          final textFinder = find.text('Enabled Button');
          expect(textFinder, findsOneWidget);

          final container = tester.widget<Container>(find.byType(Container));
          final decoration = container.decoration as BoxDecoration;
          expect(decoration.gradient, isNotNull);
          expect(decoration.boxShadow, isNotEmpty);

          await tester.tap(buttonFinder);
          expect(buttonPressed, isTrue);
        },
      );

      testWidgets(
        'renders correctly when disabled',
        (WidgetTester tester) async {
          bool buttonPressed = false;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: GradientFilledButton(
                  text: 'Disabled Button',
                  onPressed: () => buttonPressed = true,
                  isEnabled: false,
                ),
              ),
            ),
          );

          final buttonFinder = find.byType(GradientFilledButton);
          expect(buttonFinder, findsOneWidget);

          final textFinder = find.text('Disabled Button');
          expect(textFinder, findsOneWidget);

          final container = tester.widget<Container>(find.byType(Container));
          final decoration = container.decoration as BoxDecoration;
          expect(decoration.gradient, isNotNull);
          expect(decoration.boxShadow, isEmpty);

          await tester.tap(buttonFinder);
          expect(buttonPressed, isFalse);
        },
      );

      testWidgets(
        'has correct dimensions',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: GradientFilledButton(
                  text: 'Test Button',
                  onPressed: () {},
                  isEnabled: true,
                ),
              ),
            ),
          );

          final container = tester.widget<Container>(find.byType(Container));
          expect(container.constraints!.maxWidth, double.infinity);
          expect(container.constraints!.maxHeight, 48.0);
        },
      );

      testWidgets(
        'has correct text style',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: GradientFilledButton(
                  text: 'Test Button',
                  onPressed: () {},
                  isEnabled: true,
                ),
              ),
            ),
          );

          final textWidget = tester.widget<Text>(find.byType(Text));
          expect(textWidget.style!.fontSize, 22.0);
          expect(textWidget.style!.fontWeight, FontWeight.bold);
          expect(textWidget.style!.color, Colors.white);
        },
      );
    },
  );
}
