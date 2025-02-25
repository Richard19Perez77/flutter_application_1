import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImagePickerApp extends StatefulWidget {
  const ImagePickerApp({super.key});

  @override
  State<ImagePickerApp> createState() => _ImagePickerAppState();
}

class _ImagePickerAppState extends State<ImagePickerApp> {
  Uint8List? _selectedImage;
  String? _asciiImageUrl;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    if (kIsWeb) {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImage = bytes;
          _asciiImageUrl = null;
        });
        startAsciiWork(bytes);
      }
    } else {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImage = bytes;
          _asciiImageUrl = null;
        });
        startAsciiWork(bytes);
      }
    }
  }

  Future<void> startAsciiWork(Uint8List bytes) async {
    if (bytes.isNotEmpty) {
      var url = Uri.parse("https://api.deepai.org/api/deepdream");
      var request = http.MultipartRequest("POST", url);
      request.headers["api-key"] = "7876ce66-9148-4659-9be5-a8e089262d40";
      request.files.add(
        http.MultipartFile.fromBytes(
          "image",
          _selectedImage!,
          filename: "upload.jpg",
        ),
      );

      try {
        var response = await request.send();
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        if (jsonResponse["output_url"] != null) {
          setState(() {
            _asciiImageUrl = jsonResponse["output_url"];
          });
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cross-Platform Image Picker")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Select Image"),
            ),
            Row(
              children: [
                if (_selectedImage != null) ...[
                  const SizedBox(height: 10, width: 10),
                  Image.memory(_selectedImage!, height: 200),
                ],
                const SizedBox(height: 10, width: 10),
                if (_asciiImageUrl != null) ...[
                  const SizedBox(height: 10, width: 10),
                  Image.network(_asciiImageUrl!, height: 200),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
