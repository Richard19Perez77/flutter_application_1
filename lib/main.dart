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

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

// ...

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//
class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; // store for page

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = FavoritesPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              // ensure child is not obscured by a hardware notch or status bar
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() => selectedIndex = value);
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
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
          child: Text(
            "${pair.first} ${pair.second}",
            style: style,
            semanticsLabel: "${pair.first} ${pair.second}",
          ),
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

// can maintain mutable state throughout its lifecycle
class YellowBird extends StatefulWidget {
  const YellowBird({
    super.key,
  }); // constructor helps widget id in lists and anim
  @override
  State<YellowBird> createState() => _YellowBirdState(); // creates associated state class
}

// responsible for the UI and state management of YellowBird
class _YellowBirdState extends State<YellowBird> {
  @override
  Widget build(BuildContext context) {
    // return Container
    return Container(
      color: const Color(0xFFFFE306),
    ); // represents a yellow color
  }
}

// Bird can have mutable state, defined in _BirdData
class Bird extends StatefulWidget {
  const Bird({
    super.key,
    this.color = const Color(0xFFFFE306),
    this.child,
  }); // color params

  final Color color;
  final Widget? child; // wrapper ready

  @override
  State<Bird> createState() => _BirdState(); // return instance of _BirdState
}

// managing the mutable state
class _BirdState extends State<Bird> {
  double _size = 1.0; // controls scaling transformation

  void grow() {
    setState(() {
      // trigger rebuild
      _size += 0.1; // increase size
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color, // set background
      transform: Matrix4.diagonal3Values(_size, _size, 1.0), // scale the widget
      child:
          widget
              .child, // child passed to Bird will be rendered inside container
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyAppState>(
      builder: (context, appState, child) {
        var favorites = appState.favorites;
        print("Favorites count: ${favorites.length}");

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Favorites",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Show message if no favorites
                if (favorites.isEmpty)
                  const Text(
                    "No favorites added yet.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            title: Text(
                              "${favorites[index].first} ${favorites[index].second}",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
