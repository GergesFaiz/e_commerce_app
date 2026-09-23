import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) context.go(AppRouter.home);
        if (state is AuthFailure) _showErrorSnackBar(context, state.message);
      },
      builder: (context, state) {
        return AuthScaffold(
          title: 'Welcome Back To Route',
          subtitle: 'Please sign in with your mail',
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthLabel('User Name'),
                  AuthField(
                    controller: _emailCtrl,
                    hint: 'enter your mail',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Mail is required';
                      if (!v.contains('@')) return 'Enter a valid mail';
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),
                  const AuthLabel('Password'),
                  AuthField(
                    controller: _passCtrl,
                    hint: 'enter your password',
                    obscure: !_isPasswordVisible,
                    suffix: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.hint,
                      ),
                      onPressed: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Forgot password',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 28),
                  AuthWhiteButton(
                    label: 'Login',
                    loading: state is AuthLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthCubit>().login(
                              _emailCtrl.text.trim(),
                              _passCtrl.text.trim(),
                            );
                      }
                    },
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.go(AppRouter.register),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 16),
                          children: const [
                            TextSpan(text: "Don't have an account? "),
                            TextSpan(
                                text: 'Create Account',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
