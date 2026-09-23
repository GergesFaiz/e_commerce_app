import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_scaffold.dart';

void showAuthMessage(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: error ? AppColors.error : AppColors.primary,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
    ),
  );
}

/// Step 1: enter the account mail to receive the reset code.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) showAuthMessage(context, state.message, error: true);
        if (state is AuthMessage) {
          context.go('${AppRouter.verify}?email=${Uri.encodeComponent(_emailCtrl.text.trim())}');
        }
      },
      builder: (context, state) {
        return AuthScaffold(
          title: 'Forgot Password',
          subtitle: 'Enter your mail to receive a reset code',
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthLabel('E-mail address'),
                  AuthField(
                    controller: _emailCtrl,
                    hint: 'enter your email address',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v!.isEmpty || !v.contains('@')
                        ? 'Enter a valid email'
                        : null,
                  ),
                  const SizedBox(height: 40),
                  AuthWhiteButton(
                    label: 'Send code',
                    loading: state is AuthLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<AuthCubit>()
                            .forgotPassword(_emailCtrl.text.trim());
                      }
                    },
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

/// Step 2: enter the reset code sent to the mail.
class VerifyCodeScreen extends StatefulWidget {
  final String email;
  const VerifyCodeScreen({super.key, required this.email});
  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) showAuthMessage(context, state.message, error: true);
        if (state is AuthMessage) {
          context.go(
              '${AppRouter.resetPassword}?email=${Uri.encodeComponent(widget.email)}');
        }
      },
      builder: (context, state) {
        return AuthScaffold(
          title: 'Verify Code',
          subtitle: 'Enter the code sent to ${widget.email}',
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthLabel('Reset code'),
                  AuthField(
                    controller: _codeCtrl,
                    hint: 'enter the 6-digit code',
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v!.trim().isEmpty ? 'Code is required' : null,
                  ),
                  const SizedBox(height: 40),
                  AuthWhiteButton(
                    label: 'Verify',
                    loading: state is AuthLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<AuthCubit>()
                            .verifyResetCode(_codeCtrl.text.trim());
                      }
                    },
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

/// Step 3: set a new password.
class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _visible = false;

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) showAuthMessage(context, state.message, error: true);
        if (state is AuthMessage) {
          showAuthMessage(context, state.message);
          context.go(AppRouter.login);
        }
      },
      builder: (context, state) {
        return AuthScaffold(
          title: 'New Password',
          subtitle: 'Set a new password for ${widget.email}',
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthLabel('New password'),
                  AuthField(
                    controller: _passCtrl,
                    hint: 'enter your new password',
                    obscure: !_visible,
                    suffix: IconButton(
                      icon: Icon(
                          _visible ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.hint),
                      onPressed: () =>
                          setState(() => _visible = !_visible),
                    ),
                    validator: (v) =>
                        v!.length < 6 ? 'Min 6 characters' : null,
                  ),
                  const SizedBox(height: 28),
                  const AuthLabel('Confirm password'),
                  AuthField(
                    controller: _confirmCtrl,
                    hint: 'confirm your new password',
                    obscure: !_visible,
                    validator: (v) => v != _passCtrl.text
                        ? 'Passwords do not match'
                        : null,
                  ),
                  const SizedBox(height: 40),
                  AuthWhiteButton(
                    label: 'Reset password',
                    loading: state is AuthLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthCubit>().resetPassword(
                              email: widget.email,
                              newPassword: _passCtrl.text.trim(),
                            );
                      }
                    },
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
