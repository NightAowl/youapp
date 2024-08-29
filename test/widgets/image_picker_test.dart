import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youapp/widgets/image_picker.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(
    'plugins.flutter.io/image_picker',
  );

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'pickImage') {
          return '/test/path/image.jpg';
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets(
    'ImagePicker displays default icon and text',
    (WidgetTester tester) async {
      // Arrange
      final imageController = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomImagePicker(imageController: imageController),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.text('Add image'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    },
  );

  testWidgets(
    'ImagePicker picks an image and updates UI',
    (WidgetTester tester) async {
      final imageController = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomImagePicker(imageController: imageController),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(imageController.text, '/test/path/image.jpg');
      expect(find.byIcon(Icons.add_rounded), findsNothing);
      expect(find.byType(Container), findsOneWidget);
    },
  );
}
