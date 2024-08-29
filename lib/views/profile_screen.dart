import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_state.dart';
import '../blocs/profile_bloc/profile_bloc.dart';
import '../blocs/profile_bloc/profile_event.dart';
import '../blocs/profile_bloc/profile_state.dart';
import '../widgets/profile_about_section.dart';
import '../widgets/profile_interests_section.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthSuccess) {
        context.read<ProfileBloc>().add(
              GetProfileEvent(token: authState.token),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthSuccess) {
          return BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return _buildLoadingScreen();
              } else if (state is ProfileFailure) {
                return _buildErrorScreen(state.error);
              } else if (state is ProfileSuccess) {
                final String username = state.data['data']['username'];
                final Map<String, dynamic> profile = state.data['data'];
                final interests = List<String>.from(profile['interests'] ?? []);

                return _buildProfileContent(
                  username: username,
                  profile: profile,
                  interests: interests,
                );
              } else {
                return _buildErrorScreen('Unexpected state');
              }
            },
          );
        } else {
          return _buildErrorScreen('Not authenticated');
        }
      },
    );
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 9, 20, 26),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorScreen(String message) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 20, 26),
      body: Center(
        child: Text(
          'Error: $message',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildProfileContent({
    required String username,
    required Map<String, dynamic> profile,
    required List<String> interests,
  }) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 20, 26),
      appBar: _buildAppBar(username),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              _buildProfileHeader(username),
              const SizedBox(height: 30),
              ProfileAboutSection(profile: profile),
              const SizedBox(height: 30),
              ProfileInterestsSection(interests: interests),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(String username) {
    return AppBar(
      title: Text(username),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      leadingWidth: 120,
      leading: TextButton.icon(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        ),
        label: const Text(
          'Back',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String username) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: 190,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 22, 35, 41),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        Positioned(
          left: 13,
          bottom: 10,
          child: Text(
            '@$username,',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
