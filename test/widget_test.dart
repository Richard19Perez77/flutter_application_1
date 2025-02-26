import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/home_page.dart';

void main() {
  testWidgets('App launches with ProviderScope and MyHomePage', (WidgetTester tester) async {
    // Build our app wrapped in ProviderScope and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        child: const MyApp(),
      ),
    );

    // Verify that MaterialApp exists
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify that ProviderScope is present
    expect(find.byWidgetPredicate((widget) => widget is ProviderScope), findsOneWidget);

    // Verify that home is set to MyHomePage
    expect(find.byType(MyHomePage), findsOneWidget);
  });
}
