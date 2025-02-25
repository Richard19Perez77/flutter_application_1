import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/app_state.dart';
import 'package:flutter_application_1/home_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launches and navigates correctly', (WidgetTester tester) async {
    // Start the app
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp(home: MyHomePage()),
      ),
    );

    // Wait for initial rendering
    await tester.pumpAndSettle();

    // Verify the app starts at the home page
    expect(find.text('Like'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Tap the "Next" button and ensure the word pair changes
    final wordBefore = tester.widget<Text>(find.byType(Text).first).data;
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    final wordAfter = tester.widget<Text>(find.byType(Text).first).data;

    expect(wordBefore, isNot(equals(wordAfter)));

    // Navigate to Favorites page
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    // Ensure the Favorites page is displayed
    expect(find.text('No favorites yet.'), findsOneWidget);

    // Navigate back to Home
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();

    // Ensure Home page is displayed again
    expect(find.text('Like'), findsOneWidget);
  });
}
