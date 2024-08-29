import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as image_picker;

class CustomImagePicker extends StatefulWidget {
  final TextEditingController imageController;

  const CustomImagePicker({
    super.key,
    required this.imageController,
  });

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  image_picker.XFile? _pickedImage;

  Future<void> pickImage() async {
    final picker = image_picker.ImagePicker();
    final image_picker.XFile? image = await picker.pickImage(
      source: image_picker.ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        _pickedImage = image;
        widget.imageController.text = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: pickImage,
            child: Container(
              width: 57,
              height: 57,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                color: const Color.fromARGB(30, 255, 255, 255),
                image: _pickedImage != null
                    ? DecorationImage(
                        image: FileImage(File(_pickedImage!.path)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _pickedImage == null
                  ? const Icon(
                      Icons.add_rounded,
                      size: 20,
                      color: Color(0xFFFFD700),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          const Text('Add image'),
        ],
      ),
    );
  }
}
