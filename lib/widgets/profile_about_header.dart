import 'package:flutter/material.dart';

class ProfileAboutHeader extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onEditPressed;

  const ProfileAboutHeader({
    super.key,
    required this.isEditing,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'About',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        TextButton(
          key: isEditing ? const Key('save-button') : const Key('edit-button'),
          onPressed: onEditPressed,
          child: isEditing
              ? const Text(
                  'Save & Update',
                  style: TextStyle(color: Color(0xFFFFD700)),
                )
              : const Icon(Icons.edit, color: Colors.white),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
