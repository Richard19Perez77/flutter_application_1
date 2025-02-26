import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImagePickerState extends Notifier<ImagePickerState> {
  Uint8List? selectedImage;
  String? asciiImageUrl;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      selectedImage = bytes;
      asciiImageUrl = null;
      state = this; // Notify consumers
      await startAsciiWork(bytes);
    }
  }

  Future<void> startAsciiWork(Uint8List bytes) async {
    if (bytes.isNotEmpty) {
      var url = Uri.parse("https://api.deepai.org/api/deepdream");
      var request = http.MultipartRequest("POST", url);
      request.headers["api-key"] = "7876ce66-9148-4659-9be5-a8e089262d40";
      request.files.add(http.MultipartFile.fromBytes("image", bytes, filename: "upload.jpg"));

      try {
        var response = await request.send();
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);

        if (jsonResponse["output_url"] != null) {
          asciiImageUrl = jsonResponse["output_url"];
          state = this; // Notify consumers
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  @override
  ImagePickerState build() => this;
}

// Riverpod provider
final imagePickerProvider = NotifierProvider<ImagePickerState, ImagePickerState>(() => ImagePickerState());
