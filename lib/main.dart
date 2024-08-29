import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'views/add_interest_screen.dart';
import 'blocs/profile_bloc/profile_bloc.dart';
import 'services/you_app_api/profile_api.dart';
import 'services/you_app_api/auth_api.dart';
import 'blocs/auth_bloc/auth_bloc.dart';
import 'views/profile_screen.dart';
import 'views/login_screen.dart';
import 'views/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(AuthApi())),
        BlocProvider(create: (_) => ProfileBloc(ProfileApi())),
      ],
      child: MaterialApp(
        title: 'YouApp',
        theme: ThemeData(
          brightness: Brightness.dark,
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            bodyLarge: TextStyle(
              color: Colors.white70,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: BorderSide.none,
            ),
            hintStyle: const TextStyle(
              color: Colors.white54,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
          RegisterScreen.routeName: (_) => const RegisterScreen(),
          ProfileScreen.routeName: (_) => const ProfileScreen(),
          AddInterestScreen.routeName: (_) => const AddInterestScreen(),
        },
      ),
    );
  }
}
