import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadCover({
    File? file,
    Uint8List? bytes,
    required String uid,
    String? extension,
  }) async {
    // Determine the file extension
    String fileExtension =
        extension ?? (file != null ? p.extension(file.path) : '');

    // Create a reference to the location where the file will be stored
    Reference fileRef =
        _firebaseStorage.ref('pdf/cover').child('$uid$fileExtension');

    // Prepare the upload task
    UploadTask task;
    if (file != null) {
      task = fileRef.putFile(file);
    } else if (bytes != null) {
      task = fileRef.putData(bytes);
    } else {
      throw Exception("Neither file nor bytes were provided.");
    }

    // Wait for the upload to complete
    TaskSnapshot snapshot = await task.whenComplete(() {});

    // Check if the upload was successful
    if (snapshot.state == TaskState.success) {
      // Retrieve the download URL
      String downloadUrl = await fileRef.getDownloadURL();
      return downloadUrl;
    } else {
      // Handle unsuccessful upload
      print("Upload failed");
      return null;
    }
  }
}
