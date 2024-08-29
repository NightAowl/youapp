import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(DateTime) onDateSelected;
  final String? Function(String?)? validator;

  const CustomDateField({
    super.key,
    required this.label,
    required this.controller,
    required this.onDateSelected,
    this.validator,
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
              key: const Key('custom_date_field'),
              controller: controller,
              readOnly: true,
              onTap: () => _selectDate(context),
              validator: validator,
              decoration: _buildInputDecoration(),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: 'Select $label',
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: const Color.fromARGB(10, 255, 255, 255),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = DateFormat('dd MM yyyy').format(picked);
      onDateSelected(picked);
    }
  }
}
