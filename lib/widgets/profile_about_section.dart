import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youapp/widgets/edit_profile_form.dart';
import 'package:youapp/widgets/profile_about_header.dart';
import '../blocs/profile_bloc/profile_bloc.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_state.dart';
import '../blocs/profile_bloc/profile_event.dart';
import 'about_info.dart';

class ProfileAboutSection extends StatefulWidget {
  final Map<String, dynamic> profile;

  const ProfileAboutSection({super.key, required this.profile});

  @override
  State<ProfileAboutSection> createState() => _ProfileAboutSectionState();
}

class _ProfileAboutSectionState extends State<ProfileAboutSection> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 5, 0, 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 22, 35, 41),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileAboutHeader(
            isEditing: _isEditing,
            onEditPressed: _toggleEditing,
          ),
          const SizedBox(height: 8),
          _isEditing
              ? EditProfileForm(
                  profile: widget.profile,
                  onSave: handleSave,
                )
              : const AboutInfo(),
        ],
      ),
    );
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void handleSave(Map<String, dynamic> updatedProfile) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      final token = authState.token;
      context.read<ProfileBloc>().add(
            UpdateProfileEvent(
              token: token,
              name: updatedProfile['name'],
              birthday: updatedProfile['birthday'],
              height: updatedProfile['height'],
              weight: updatedProfile['weight'],
            ),
          );

      context.read<ProfileBloc>().add(GetProfileEvent(token: token));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile update failed')),
      );
    }

    setState(() {
      _isEditing = false;
    });
  }
}
