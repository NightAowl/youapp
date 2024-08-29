import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool readOnly;

  const CustomFormField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: const TextStyle(color: Color.fromARGB(121, 255, 255, 255)),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              validator: validator,
              readOnly: readOnly,
              decoration: _buildInputDecoration(),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: 'Enter $label',
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: const Color.fromARGB(10, 255, 255, 255),
    );
  }
}
