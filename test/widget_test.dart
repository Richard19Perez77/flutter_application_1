import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/home_page.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that MaterialApp exists
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify that ChangeNotifierProvider is present
    expect(find.byWidgetPredicate((widget) =>
      widget is ChangeNotifierProvider<MyAppState>), findsOneWidget);

    // Verify that home is set to MyHomePage
    expect(find.byType(MyHomePage), findsOneWidget);
  });
}
