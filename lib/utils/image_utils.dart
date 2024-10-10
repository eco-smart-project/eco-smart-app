import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

Future<Map<String, String?>> pickImage(BuildContext context) async {
  final ImagePicker picker = ImagePicker();

  ImageSource? source = await showModalBottomSheet<ImageSource>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    useSafeArea: false,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Foto da Galeria'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Câmera'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
          ],
        ),
      );
    },
  );

  if (source != null) {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      return {'image': base64Encode(bytes), 'path': pickedFile.path};
    }
  }

  return {'image': null, 'path': null};
}
