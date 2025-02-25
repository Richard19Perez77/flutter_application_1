import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/big_card.dart';
import 'package:english_words/english_words.dart';

void main() {
  testWidgets('BigCard displays the WordPair correctly', (WidgetTester tester) async {
    // Create a sample word pair
    final testPair = WordPair('hello', 'world');

    // Build the widget inside a MaterialApp (to provide a Theme)
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BigCard(pair: testPair),
        ),
      ),
    );

    // Verify if the text from the WordPair is displayed correctly
    expect(find.text('hello'), findsOneWidget);
    expect(find.text('world'), findsOneWidget);

    // Ensure the card exists in the widget tree
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('BigCard uses the correct text styles', (WidgetTester tester) async {
    final testPair = WordPair('test', 'style');

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: Scaffold(
          body: BigCard(pair: testPair),
        ),
      ),
    );

    final Text helloText = tester.widget(find.text('test'));
    final Text worldText = tester.widget(find.text('style'));

    // Verify text styles
    expect(helloText.style?.fontWeight, FontWeight.w200);
    expect(worldText.style?.fontWeight, FontWeight.bold);
  });
}
