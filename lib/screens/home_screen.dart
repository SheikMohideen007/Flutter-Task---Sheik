import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task/utils/helper.dart';
import 'package:flutter_task/services/storage_service.dart';
import 'package:flutter_task/screens/file_preview_screen.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> uploadedFiles = [];
  bool isLoading = false;
  double uploadProgress = 0.0;
  double downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final storageService = StorageService();
    uploadedFiles = await storageService.listFiles();
    setState(() {});
  }

  Future<void> uploadFile() async {
    setState(() {
      uploadProgress = 0.0;
      isLoading = true;
    });
    final storageService = StorageService();
    String? url;
    try {
      url = await storageService.uploadImage(onProgress: (percent) {
        setState(() {
          uploadProgress = percent;
        });
      });
      setState(() {
        isLoading = false;
        uploadProgress = 0.0;
      });
      if (url != null) {
        // Refresh file list
        uploadedFiles = await storageService.listFiles();
        setState(() {});
        Helper.showSnackBar(context, 'Upload successfully !', Colors.green);
      } else {
        Helper.showSnackBar(
            context, 'Upload failed. Please try again.', Colors.grey);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        uploadProgress = 0.0;
      });
      Helper.showSnackBar(context, e.toString(), Colors.grey);
    }
  }

  Future<void> downloadFile(String url) async {
    try {
      setState(() {
        isLoading = true;
        downloadProgress = 0.0;
      });

      final storageService = StorageService();
      // print('Downloading file from: $url');
      final fileName = url.split('/').last;
      // print('Downloading file from: $fileName');
      final directory = await getApplicationDocumentsDirectory();
      final savePath = '${directory.path}/$fileName';
      // Download with progress
      await storageService.downloadFileWithProgress(
        url,
        savePath,
        onProgress: (percent) {
          setState(() {
            downloadProgress = percent;
          });
        },
      );

      setState(() {
        isLoading = false;
        downloadProgress = 0.0;
      });

      if (savePath.contains('.jpg') ||
          savePath.contains('.jpeg') ||
          savePath.contains('.png')) {
        final saved = await GallerySaver.saveImage(savePath);
        if (saved == true) {
          Helper.showSnackBar(context, 'Image saved to gallery!', Colors.green);
        } else {
          Helper.showSnackBar(context, 'Failed to save image.', Colors.red);
        }
      } else if (savePath.contains('.pdf')) {
        // print('Downloading file from: here');
        Helper.showSnackBar(
            context, 'PDF downloaded successfully!', Colors.green);
        OpenFile.open(savePath);
      } else {
        Helper.showSnackBar(context, 'Downloaded file saved.', Colors.orange);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        downloadProgress = 0.0;
      });
      Helper.showSnackBar(context, 'Download failed: $e', Colors.red);
    }
  }

  Future<void> uploadPdfFile() async {
    setState(() {
      uploadProgress = 0.0;
      isLoading = true;
    });

    final storageService = StorageService();
    try {
      final url = await storageService.uploadPdf(onProgress: (percent) {
        setState(() {
          uploadProgress = percent;
        });
      });

      setState(() {
        isLoading = false;
        uploadProgress = 0.0;
      });

      if (url != null) {
        uploadedFiles = await storageService.listFiles();
        setState(() {});
        Helper.showSnackBar(context, 'PDF upload successful!', Colors.green);
      } else {
        Helper.showSnackBar(
            context, 'PDF upload failed. Try again.', Colors.grey);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        uploadProgress = 0.0;
      });
      Helper.showSnackBar(context, e.toString(), Colors.grey);
    }
  }

  void openPreviewScreen(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilePreviewScreen(url: url),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Helper.showSnackBar(context, 'Logged out successfully', Colors.green);
      Navigator.pushReplacementNamed(context, '/auth');
    } catch (e) {
      Helper.showSnackBar(
          context, 'Failed to log out. Please try again.', Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final devWidth = MediaQuery.of(context).size.width;
    final devHeight = MediaQuery.of(context).size.height;
    final buttonSize = devWidth * 0.16;
    final previewSize = devWidth * 0.6;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => _signOut(context),
              child: Row(
                children: [
                  const Text('Sign Out', style: TextStyle(color: Colors.white)),
                  SizedBox(width: devWidth * 0.02),
                  const Icon(Icons.logout, color: Colors.white)
                ],
              ),
            ),
          ),
        ],
      ),
      body: uploadedFiles.isEmpty
          ? const Center(child: Text('Loading...'))
          : Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: devWidth * 0.05),
                  child: Column(
                    children: [
                      SizedBox(height: devHeight * 0.03),
                      Expanded(
                        child: ListView.builder(
                          itemCount: uploadedFiles.length,
                          itemBuilder: (context, index) {
                            final file = uploadedFiles[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Card(
                                elevation: 8,
                                child: ListTile(
                                  leading: Icon(
                                    file['type'] == 'image'
                                        ? Icons.image
                                        : Icons.picture_as_pdf,
                                    size: 40,
                                  ),
                                  title: Text(file['name'] ?? ''),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.download),
                                        onPressed: () =>
                                            downloadFile(file['url']),
                                      ),
                                      file['type'] == 'image'
                                          ? IconButton(
                                              icon: const Icon(
                                                  Icons.remove_red_eye),
                                              onPressed: () =>
                                                  openPreviewScreen(
                                                      file['url']),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: devHeight * 0.03),
                    ],
                  ),
                ),
                Positioned(
                  bottom: devHeight * 0.04,
                  right: devWidth * 0.05,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: 'uploadImage',
                        onPressed: () => uploadFile(),
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.image),
                      ),
                      SizedBox(height: devHeight * 0.02),
                      FloatingActionButton(
                        heroTag: 'uploadpdf',
                        onPressed: () => uploadPdfFile(),
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.picture_as_pdf),
                      ),
                    ],
                  ),
                ),
                if (isLoading &&
                    (uploadProgress > 0.0 || downloadProgress > 0.0))
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: devHeight * 0.015),
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LinearProgressIndicator(
                            value: uploadProgress > 0.0
                                ? uploadProgress
                                : downloadProgress,
                          ),
                          SizedBox(height: devHeight * 0.01),
                          Text(
                            uploadProgress > 0.0
                                ? 'Uploading: ${(uploadProgress * 100).toStringAsFixed(0)}%'
                                : 'Downloading: ${(downloadProgress * 100).toStringAsFixed(0)}%',
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
