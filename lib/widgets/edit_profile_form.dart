// profile_form.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/zodiac_horoscope_calculator.dart';
import 'form_fields/custom_form_field.dart';
import 'form_fields/custom_dropdown_field.dart';
import 'form_fields/custom_date_field.dart';
import 'form_fields/custom_number_field.dart';
import 'image_picker.dart';

class EditProfileForm extends StatefulWidget {
  final Map<String, dynamic> profile;
  final Function(Map<String, dynamic>) onSave;

  const EditProfileForm({
    super.key,
    required this.profile,
    required this.onSave,
  });

  @override
  State<EditProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _genderController;
  late final TextEditingController _birthdayController;
  late final TextEditingController _horoscopeController;
  late final TextEditingController _zodiacController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _imageController;

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final profile = widget.profile;
    _nameController = TextEditingController(text: profile['name'] ?? '');
    _genderController = TextEditingController(text: profile['gender'] ?? '');
    _birthdayController = TextEditingController(
      text: _formatDate(profile['birthday']),
    );
    _horoscopeController = TextEditingController(
      text: ZodiacHoroscopeCalculator.getHoroscope(
        DateTime.parse(profile['birthday']),
      ),
    );
    _zodiacController = TextEditingController(
      text: ZodiacHoroscopeCalculator.getZodiac(
        DateTime.parse(profile['birthday']),
      ),
    );
    _heightController = TextEditingController(
      text: profile['height']?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: profile['weight']?.toString() ?? '',
    );
    _imageController = TextEditingController();
    _selectedDate = DateTime.parse(
      profile['birthday'] ?? DateTime.now().toString(),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    final inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final outputFormat = DateFormat('dd MM yyyy');
    final date = inputFormat.parse(dateString);
    return outputFormat.format(date);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _birthdayController.dispose();
    _horoscopeController.dispose();
    _zodiacController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              CustomImagePicker(imageController: _imageController),
              const Spacer(),
              TextButton(
                key: const Key('save_button'),
                onPressed: _submitForm,
                child: const Text('Save & Update'),
              ),
            ],
          ),
          CustomFormField(
            label: 'Display Name',
            controller: _nameController,
            validator: (value) => value?.isEmpty ?? true
                ? 'Please enter your display name'
                : null,
          ),
          CustomDropdownField(
            label: 'Gender',
            controller: _genderController,
            items: const ['Male', 'Female'],
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please select your gender' : null,
          ),
          CustomDateField(
            label: 'Birthday',
            controller: _birthdayController,
            onDateSelected: _onDateSelected,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please select your birthday' : null,
          ),
          CustomFormField(
            label: 'Horoscope',
            controller: _horoscopeController,
            readOnly: true,
          ),
          CustomFormField(
            label: 'Zodiac',
            controller: _zodiacController,
            readOnly: true,
          ),
          CustomNumberField(
            label: 'Height',
            controller: _heightController,
            suffixText: 'cm',
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter your height' : null,
          ),
          CustomNumberField(
            label: 'Weight',
            controller: _weightController,
            suffixText: 'kg',
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter your weight' : null,
          ),
        ],
      ),
    );
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _birthdayController.text = DateFormat('dd MM yyyy').format(date);
      _horoscopeController.text = ZodiacHoroscopeCalculator.getHoroscope(date);
      _zodiacController.text = ZodiacHoroscopeCalculator.getZodiac(date);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        {
          'name': _nameController.text,
          'birthday': _selectedDate.toString(),
          'height': int.parse(_heightController.text),
          'weight': int.parse(_weightController.text),
        },
      );
    }
  }
}
