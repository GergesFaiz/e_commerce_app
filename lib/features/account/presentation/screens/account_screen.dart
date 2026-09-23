import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/cache_helper.dart';
import '../../../../core/widgets/route_widgets.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

/// Profile screen from the design, wired to updateMe + change-password.
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _current = TextEditingController();
  final _neu = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _current.dispose();
    _neu.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    await CacheHelper.removeToken();
    await CacheHelper.removeUserId();
    if (mounted) context.go(AppRouter.login);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          Fluttertoast.showToast(msg: state.message);
        }
        if (state is AuthMessage) {
          Fluttertoast.showToast(msg: state.message);
          _current.clear();
          _neu.clear();
        }
      },
      builder: (context, state) {
        final busy = state is AuthLoading;
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink)),
                  const SizedBox(height: 24),
                  _field('Your full name', _name, 'Mohamed Mohamed Nabil'),
                  _field('Your E-mail', _email, 'mohamed.N@gmail.com',
                      keyboard: TextInputType.emailAddress),
                  _field('Your mobile number', _phone, '01122118855',
                      keyboard: TextInputType.phone),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: busy
                          ? null
                          : () => context.read<AuthCubit>().updateProfile(
                                name: _name.text.trim(),
                                email: _email.text.trim(),
                                phone: _phone.text.trim(),
                              ),
                      child: busy
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text('Save changes'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Change password',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink)),
                  const SizedBox(height: 12),
                  _field('Current password', _current, '••••••',
                      obscure: true),
                  _field('New password', _neu, '••••••', obscure: true),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: busy
                          ? null
                          : () => context
                                  .read<AuthCubit>()
                                  .changePassword(
                                    current: _current.text.trim(),
                                    password: _neu.text.trim(),
                                  ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(
                            color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text('Update password'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: _logout,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side:
                            const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text('Logout',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: RouteBottomNav(
            currentIndex: 3,
            onTap: (i) {
              if (i == 0) context.go(AppRouter.home);
              if (i == 1) context.go(AppRouter.categories);
              if (i == 2) context.go(AppRouter.wishlist);
            },
          ),
        );
      },
    );
  }

  Widget _field(String label, TextEditingController ctrl, String hint,
      {bool obscure = false, TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink)),
          const SizedBox(height: 8),
          TextField(
            controller: ctrl,
            obscureText: obscure,
            keyboardType: keyboard,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon:
                  const Icon(Icons.edit_outlined, color: AppColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}
