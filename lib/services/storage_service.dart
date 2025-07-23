import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage({Function(double)? onProgress}) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) throw 'No image selected.';
      final file = File(pickedFile.path);
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage.ref().child('Image Folder/$fileName.jpg');
      final uploadTask = ref.putFile(file);
      uploadTask.snapshotEvents.listen((event) {
        if (onProgress != null && event.totalBytes > 0) {
          double percent = event.bytesTransferred / event.totalBytes;
          onProgress(percent);
        }
      });
      await uploadTask;
      return await ref.getDownloadURL();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Map<String, dynamic>>> listFiles() async {
    try {
      final imageResult = await _storage.ref('Image Folder').listAll();
      List<Map<String, dynamic>> files = [];
      for (var item in imageResult.items) {
        final url = await item.getDownloadURL();
        files.add({'name': item.name, 'url': url, 'type': 'image'});
      }
      final pdfResult = await _storage.ref('Pdf Folder').listAll();
      for (var item in pdfResult.items) {
        final url = await item.getDownloadURL();
        files.add({'name': item.name, 'url': url, 'type': 'pdf'});
      }
      return files;
    } catch (e) {
      return [];
    }
  }

  Future<void> downloadFileWithProgress(String url, String savePath,
      {Function(double)? onProgress}) async {
    try {
      final ref = _storage.refFromURL(url);
      final file = File(savePath);
      final downloadTask = ref.writeToFile(file);

      downloadTask.snapshotEvents.listen((event) {
        if (onProgress != null && event.totalBytes > 0) {
          final percent = event.bytesTransferred / event.totalBytes;
          onProgress(percent);
        }
      });

      await downloadTask;
    } catch (e) {
      print('Download failed: $e');
      rethrow;
    }
  }

  Future<String?> uploadPdf({Function(double)? onProgress}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.single.path == null) {
        throw 'No PDF selected.';
      }

      final file = File(result.files.single.path!);
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage.ref().child('Pdf Folder/$fileName.pdf');
      final uploadTask = ref.putFile(file);

      uploadTask.snapshotEvents.listen((event) {
        if (onProgress != null && event.totalBytes > 0) {
          double percent = event.bytesTransferred / event.totalBytes;
          onProgress(percent);
        }
      });

      await uploadTask;
      return await ref.getDownloadURL();
    } catch (e) {
      throw e.toString();
    }
  }
}
