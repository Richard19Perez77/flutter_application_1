import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'image_state.dart';

class ImagePickerApp extends ConsumerWidget {
  const ImagePickerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imagePickerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Cross-Platform Image Picker")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => ref.read(imagePickerProvider.notifier).pickImage(),
              child: const Text("Select Image"),
            ),
            Row(
              children: [
                if (imageState.selectedImage != null) ...[
                  const SizedBox(height: 10, width: 10),
                  Image.memory(imageState.selectedImage!, height: 200),
                ],
                const SizedBox(height: 10, width: 10),
                if (imageState.asciiImageUrl != null) ...[
                  const SizedBox(height: 10, width: 10),
                  Image.network(imageState.asciiImageUrl!, height: 200),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
