import 'dart:io';

import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class MediaServices {
  final ImagePicker _picker = ImagePicker();

  Future<File?> getImageFromGallery() async {
    try {
      if (kIsWeb) {
        final result = await file_picker.FilePicker.platform.pickFiles(
          type: file_picker.FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png'],
        );
        if (result != null && result.files.single.bytes != null) {
          return File.fromRawPath(result.files.single.bytes!);
        }
      } else {
        final XFile? _file =
            await _picker.pickImage(source: ImageSource.gallery);
        if (_file != null) {
          return File(_file.path);
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
    return null;
  }
}
