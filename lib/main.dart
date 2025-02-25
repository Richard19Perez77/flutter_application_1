// english words package which provides a lib of english word pairs
import 'package:english_words/english_words.dart';
// flutter material package, which provides ui components and theming
import 'package:flutter/material.dart';
// provider package for state management using ChangeNotifier
import 'package:provider/provider.dart';

void main() {
  // entry point of flutter app
  runApp(MyApp()); // launch with MyApp as root
}

// no mutable state is stateless
class MyApp extends StatelessWidget {
  // optional key for widget id
  const MyApp({super.key});

  // describe the ui tree for this widget
  @override
  Widget build(BuildContext context) {
    // manage state, auto disposes
    return ChangeNotifierProvider(
      // provide an instance of MyAppState to the widget tree for state management
      create: (context) => MyAppState(),
      child: MaterialApp(
        // appliation title
        title: 'Fun App',
        // define theme with Material 3
        theme: ThemeData(
          useMaterial3: true, // enable
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(), // set the homepage
      ),
    );
  }
}

// use of change notifiier means it can notify others about its own changes
class MyAppState extends ChangeNotifier {
  // allow widgets to listen for state changes
  var current = WordPair.random(); // store randomly generated word pair

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // accessing state using context.watch, stateless access
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    return Scaffold(
      body: Column(
        children: [
          Text('A random idea:'),
          BigCard(pair: pair),
          NextButton(appState: appState),
          const GreenFrog(), // First GreenFrog instance
          const SizedBox(height: 10),
          const GreenFrog(), // Second GreenFrog instance
          const SizedBox(height: 20), // Space between groups

          Frog(
            color: Colors.greenAccent,
            child: const Text(
              "Frog 1",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),

          const SizedBox(height: 10),

          Frog(
            color: Colors.teal,
            child: const Text(
              "Frog 2",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({super.key, required this.appState});
  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        appState.getNext();
      },
      child: Padding(padding: const EdgeInsets.all(8.0), child: Text('Next')),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(pair.asLowerCase, style: style),
        ),
      ),
    );
  }
}

// stateless depends on its own configuration
class GreenFrog extends StatelessWidget {
  const GreenFrog({super.key});

  // describe the part of the UI represented by this widet
  @override
  Widget build(BuildContext context) {
    // returns a container widget witha fixed green color
    return IntrinsicWidth(child: Container(color: const Color(0xFF2DBD3A)));
  }
}

// more flexible but still stateless widget
class Frog extends StatelessWidget {
  // we now call Frog with a color, and child widget
  const Frog({super.key, this.color = const Color(0xFF2DBD3A), this.child});

  final Color color;
  final Widget? child; // for embedding another widget

  @override
  Widget build(BuildContext context) {
    // return a ColoredBox widget on build
    return ColoredBox(color: color, child: child);
  }
}
