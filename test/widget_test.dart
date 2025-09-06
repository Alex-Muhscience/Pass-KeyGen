import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
<<<<<<< HEAD
import 'package:keygen/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame with a default theme mode.
    await tester.pumpWidget(const MyApp(initialThemeMode: ThemeMode.system));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
=======
import 'package:pass_keygen/main.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(
      initialThemeMode: ThemeMode.system,
      initialLocale: Locale('en'),
    ));

    // Verify that the app starts without errors
    expect(find.byType(MaterialApp), findsOneWidget);
>>>>>>> 5e93ef0 (Update Android build configuration and dependencies)
  });
}
