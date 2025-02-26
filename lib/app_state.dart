import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:english_words/english_words.dart';

class MyAppState extends Notifier<MyAppState> {
  var current = WordPair.random();
  final List<WordPair> history = [];
  final List<WordPair> favorites = [];

  void getNext() {
    history.insert(0, current);
    current = WordPair.random();
    state = MyAppState()..copyFrom(this); // Update state properly
  }

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    state = MyAppState()..copyFrom(this);
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    state = MyAppState()..copyFrom(this);
  }

  void copyFrom(MyAppState oldState) {
    history.addAll(oldState.history);
    favorites.addAll(oldState.favorites);
    current = oldState.current;
  }

  @override
  MyAppState build() => MyAppState();
}

final appStateProvider = NotifierProvider<MyAppState, MyAppState>(() => MyAppState());
