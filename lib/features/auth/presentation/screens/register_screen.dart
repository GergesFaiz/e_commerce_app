import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_scaffold.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
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
          title: 'Create Account',
          subtitle: 'Please fill your data to join Route',
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthLabel('Full Name'),
                  AuthField(
                    controller: _nameCtrl,
                    hint: 'enter your full name',
                    validator: (v) =>
                        v!.isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 28),
                  const AuthLabel('Mobile Number'),
                  AuthField(
                    controller: _phoneCtrl,
                    hint: 'enter your mobile no.',
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        v!.isEmpty ? 'Phone is required' : null,
                  ),
                  const SizedBox(height: 28),
                  const AuthLabel('E-mail address'),
                  AuthField(
                    controller: _emailCtrl,
                    hint: 'enter your email address',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v!.isEmpty || !v.contains('@')
                        ? 'Enter a valid email'
                        : null,
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
                    validator: (v) =>
                        v!.length < 6 ? 'Min 6 characters' : null,
                  ),
                  const SizedBox(height: 40),
                  AuthWhiteButton(
                    label: 'Sign up',
                    loading: state is AuthLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthCubit>().register(
                              name: _nameCtrl.text.trim(),
                              email: _emailCtrl.text.trim(),
                              password: _passCtrl.text.trim(),
                              phone: _phoneCtrl.text.trim(),
                            );
                      }
                    },
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.go(AppRouter.login),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 16),
                          children: const [
                            TextSpan(text: 'Already have an account? '),
                            TextSpan(
                                text: 'Login',
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
