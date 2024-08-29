import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:youapp/utils/zodiac_horoscope_calculator.dart';

import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_state.dart';
import '../blocs/profile_bloc/profile_bloc.dart';
import '../blocs/profile_bloc/profile_state.dart';

class AboutInfo extends StatefulWidget {
  const AboutInfo({super.key});

  @override
  State<AboutInfo> createState() => _AboutInfoState();
}

class _AboutInfoState extends State<AboutInfo> {
  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthSuccess) {
      String formatBirthdayAndAge(String birthdayString) {
        try {
          final inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
          final birthDate = inputFormat.parse(birthdayString);

          final outputFormat = DateFormat('dd / MM / yyyy');
          final formattedBirthday = outputFormat.format(birthDate);

          final age = DateTime.now().difference(birthDate).inDays ~/ 365;

          return '$formattedBirthday (Age $age)';
        } catch (_) {
          return birthdayString;
        }
      }

      return BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileSuccess) {
            final profile = state.data['data'];
            final birthday = profile['birthday'] ?? '';
            final horoscope = ZodiacHoroscopeCalculator.getHoroscope(
              DateTime.parse(profile['birthday'] ?? ''),
            );
            final zodiac = ZodiacHoroscopeCalculator.getZodiac(
              DateTime.parse(profile['birthday'] ?? ''),
            );
            final height = profile['height']?.toString() ?? '';
            final weight = profile['weight']?.toString() ?? '';

            if (birthday.isEmpty &&
                horoscope.isEmpty &&
                zodiac.isEmpty &&
                height.isEmpty &&
                weight.isEmpty) {
              return const Text(
                'Add in your info to help others know you better',
                style: TextStyle(color: Colors.grey),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Birthday: ',
                        style: TextStyle(
                          color: Color.fromARGB(70, 255, 255, 255),
                        ),
                      ),
                      TextSpan(
                        text: formatBirthdayAndAge(birthday.toString()),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Horoscope: ',
                        style: TextStyle(
                          color: Color.fromARGB(70, 255, 255, 255),
                        ),
                      ),
                      TextSpan(
                        text: horoscope,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Zodiac: ',
                        style: TextStyle(
                          color: Color.fromARGB(70, 255, 255, 255),
                        ),
                      ),
                      TextSpan(
                        text: zodiac,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Height: ',
                        style: TextStyle(
                          color: Color.fromARGB(70, 255, 255, 255),
                        ),
                      ),
                      TextSpan(
                        text: '$height cm',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Weight: ',
                        style: TextStyle(
                          color: Color.fromARGB(70, 255, 255, 255),
                        ),
                      ),
                      TextSpan(
                        text: '$weight kg',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],
            );
          } else if (state is ProfileFailure) {
            return const Text(
              'Failed to load profile info',
              style: TextStyle(color: Colors.red),
            );
          }

          return const Text(
            'Add in your info to help others know you better',
            style: TextStyle(color: Colors.grey),
          );
        },
      );
    } else {
      return const Text(
        'Failed to load profile info',
        style: TextStyle(color: Colors.red),
      );
    }
  }
}
