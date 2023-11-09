import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: text.text.make(),
      ),
    );
}


Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );
  return image;
}