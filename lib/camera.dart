import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  @override
  State<CameraScreen> createState() => _CameraState();
}

class _CameraState extends State<CameraScreen> {
  File? _image;
  Future<void> _takeimage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
    });
  }

  Future<void> _saveImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final imagepath = "${directory.path}/image$timestamp.jpg";
    await _image!.copy(imagepath);
    await ImageGallerySaver.saveFile(imagepath);
    // ignore: prefer_const_declarations
    final snakbar = const SnackBar(content: Text("Image Saved!"));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snakbar);
  }

  Future<void> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
    } else {}
  }

  void initState() {
    _takeimage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _image == null
            ? const Text("no image is selected")
            : Image.file(_image!),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _takeimage();
            },
            tooltip: "Take Image",
            child: const Icon(Icons.camera),
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              _saveImage();
            },
            tooltip: "save image",
            child: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
