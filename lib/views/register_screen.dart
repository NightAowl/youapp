import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';
import '../blocs/auth_bloc/auth_state.dart';
import 'login_screen.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/form_fields/custom_input_field.dart';
import '../widgets/gradient_filled_button.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  bool get _isButtonEnabled {
    return _emailController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
  }

  void registerNewAccount() {
    context.read<AuthBloc>().add(
          RegisterEvent(
            email: _emailController.text.trim(),
            username: _usernameController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Handle registration success
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration successful!'),
              ),
            );
            Navigator.of(context).pushReplacementNamed(
              LoginScreen.routeName,
            );
          } else if (state is AuthFailure) {
            // Handle registration failure
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const GradientScaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(30, 150, 30, 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomInputField(
                    hintText: 'Enter Email',
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _usernameFocusNode.requestFocus(),
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    hintText: 'Create Username',
                    controller: _usernameController,
                    focusNode: _usernameFocusNode,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    hintText: 'Create Password',
                    obscureText: _obscurePassword,
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white54,
                      ),
                      onPressed: () => setState(() {
                        _obscurePassword = !_obscurePassword;
                      }),
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) =>
                        _confirmPasswordFocusNode.requestFocus(),
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    hintText: 'Confirm Password',
                    obscureText: _obscureConfirmPassword,
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocusNode,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white54,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) {
                      if (_isButtonEnabled) registerNewAccount;
                    },
                  ),
                  const SizedBox(height: 32),
                  GradientFilledButton(
                    text: 'Register',
                    onPressed: _isButtonEnabled ? registerNewAccount : null,
                    isEnabled: _isButtonEnabled,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Have an account?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                            LoginScreen.routeName,
                          );
                        },
                        child: const Text(
                          'Login here',
                          style: TextStyle(
                            color: Colors.amber,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
