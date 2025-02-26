import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'generator_page.dart';
import 'favorites_page.dart';
import 'image_picker_app.dart';

// Riverpod state for selected index
final selectedIndexProvider = StateProvider<int>((ref) => 0);

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = FavoritesPage();
      case 2:
        page = ImagePickerApp();
      default:
        throw UnimplementedError('No widget for index $selectedIndex');
    }

    final mainArea = ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: const [
                      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                      BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
                      BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Image Uploader'),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) => ref.read(selectedIndexProvider.notifier).state = value,
                  ),
                ),
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: const [
                      NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                      NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favorites')),
                      NavigationRailDestination(icon: Icon(Icons.upload), label: Text('Image Uploader')),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) => ref.read(selectedIndexProvider.notifier).state = value,
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}
