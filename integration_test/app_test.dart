import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/home_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launches and shows Home Page UI', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appStateProvider.overrideWith(() => MyAppState()), // Corrected override
        ],
        child: const MaterialApp(home: MyHomePage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Like'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('Clicking "Next" changes word pair', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appStateProvider.overrideWith(() => MyAppState()), // Corrected override
        ],
        child: const MaterialApp(home: MyHomePage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Next'), findsOneWidget);

    final textFinder = find.byKey(const Key('word_first'));
    expect(textFinder, findsOneWidget);

    final wordBefore = (tester.widget<Text>(textFinder)).data ?? '';
    print("Before clicking Next: $wordBefore");

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    final wordAfter = (tester.widget<Text>(textFinder)).data ?? '';
    print("After clicking Next: $wordAfter");

    expect(wordBefore, isNot(equals(wordAfter)));
  });

  testWidgets('Navigates to Favorites Page', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appStateProvider.overrideWith(() => MyAppState()),
        ],
        child: const MaterialApp(home: MyHomePage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    final noFavoritesText = tester.widget<Text>(find.byKey(const Key('no_favorites_yet')));
    expect(noFavoritesText.data, equals('No favorites yet.'));
  });

  testWidgets('Navigates back to Home Page', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appStateProvider.overrideWith(() => MyAppState()),
        ],
        child: const MaterialApp(home: MyHomePage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();

    expect(find.text('Like'), findsOneWidget);
  });
}
