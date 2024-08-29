import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youapp/widgets/gradient_scaffold.dart';

void main() {
  group(
    'GradientScaffold',
    () {
      testWidgets(
        'renders correctly with body',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: GradientScaffold(
                body: Text('Test Body'),
              ),
            ),
          );

          expect(find.byType(GradientScaffold), findsOneWidget);
          expect(find.byType(Scaffold), findsOneWidget);
          expect(find.text('Test Body'), findsOneWidget);
        },
      );

      testWidgets(
        'renders correctly with appBar',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: GradientScaffold(
                appBar: AppBar(title: const Text('Test AppBar')),
                body: const Text('Test Body'),
              ),
            ),
          );

          expect(find.byType(GradientScaffold), findsOneWidget);
          expect(find.byType(Scaffold), findsOneWidget);
          expect(find.text('Test AppBar'), findsOneWidget);
          expect(find.text('Test Body'), findsOneWidget);
        },
      );

      testWidgets(
        'has correct gradient',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: GradientScaffold(
                body: Container(),
              ),
            ),
          );

          final container =
              tester.widget<Container>(find.byType(Container).first);
          final decoration = container.decoration as BoxDecoration;
          final gradient = decoration.gradient as LinearGradient;

          expect(gradient.begin, Alignment.topRight);
          expect(gradient.end, Alignment.bottomLeft);
          expect(gradient.colors, [
            const Color.fromARGB(255, 31, 66, 71),
            const Color.fromARGB(255, 13, 29, 35),
            const Color.fromARGB(255, 9, 20, 26),
          ]);
        },
      );

      testWidgets(
        'extends body behind AppBar',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: GradientScaffold(
                appBar: AppBar(title: const Text('Test AppBar')),
                body: Container(),
              ),
            ),
          );

          final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
          expect(scaffold.extendBodyBehindAppBar, isTrue);
        },
      );
    },
  );
}
