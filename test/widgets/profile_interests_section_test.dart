import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youapp/views/add_interest_screen.dart';
import 'package:youapp/widgets/profile_interests_section.dart';

void main() {
  testWidgets(
    'ProfileInterestsSection displays correctly with interests',
    (WidgetTester tester) async {
      final List<String> testInterests = ['Cooking', 'Reading', 'Traveling'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileInterestsSection(interests: testInterests),
          ),
        ),
      );

      expect(find.text('Interest'), findsOneWidget);

      expect(find.byIcon(Icons.edit), findsOneWidget);

      for (final interest in testInterests) {
        expect(find.text(interest), findsOneWidget);
      }

      expect(find.byType(Chip), findsNWidgets(testInterests.length));
    },
  );

  testWidgets(
    'ProfileInterestsSection displays correctly with no interests',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileInterestsSection(interests: []),
          ),
        ),
      );

      expect(find.text('Interest'), findsOneWidget);

      expect(find.byIcon(Icons.edit), findsOneWidget);

      expect(find.text('Add in your interest to find a better match'),
          findsOneWidget);

      expect(find.byType(Chip), findsNothing);
    },
  );

  testWidgets(
    'ProfileInterestsSection navigates to AddInterestScreen when edit is tapped',
    (WidgetTester tester) async {
      final List<String> testInterests = ['Cooking', 'Reading'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileInterestsSection(interests: testInterests),
          ),
          routes: {
            AddInterestScreen.routeName: (context) => const AddInterestScreen(),
          },
        ),
      );

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(find.byType(AddInterestScreen), findsOneWidget);
    },
  );
}
