import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/home_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Widget testApp;

  setUp(() {
    testApp = ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(home: MyHomePage()),
    );
  });

  testWidgets('App launches and shows Home Page UI', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testApp);
    await tester.pumpAndSettle();

    expect(find.text('Like'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('Clicking "Next" changes word pair', (WidgetTester tester) async {
    await tester.pumpWidget(testApp);
    await tester.pumpAndSettle();

    expect(find.text('Next'), findsOneWidget); // Ensure button exists

    final wordBefore = tester.widget<Text>(find.byKey(Key('word_first'))).data;
    print("Before clicking Next: $wordBefore");

    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.pumpAndSettle();

    final wordAfter = tester.widget<Text>(find.byKey(Key('word_first'))).data;
    print("After clicking Next: $wordAfter");

    expect(wordBefore, isNot(equals(wordAfter)));
  });

  testWidgets('Navigates to Favorites Page', (WidgetTester tester) async {
    await tester.pumpWidget(testApp);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    // (Optional) Ensure it contains the exact text
    final Text noFavoritesText = tester.widget(find.byKey(Key('no_favorites_yet')));
    expect(noFavoritesText.data, equals('No favorites yet.'));
  });

  testWidgets('Navigates back to Home Page', (WidgetTester tester) async {
    await tester.pumpWidget(testApp);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();

    expect(find.text('Like'), findsOneWidget);
  });
}
