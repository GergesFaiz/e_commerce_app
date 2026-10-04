import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/cache_helper.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/route_widgets.dart';
import '../../../../core/widgets/store_actions.dart';
import '../../../addresses/data/models/address_model.dart';
import '../../../addresses/presentation/cubit/addresses_cubit.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';

/// Profile tab from the design: greeting, then outlined fields with an
/// edit pencil (name, e-mail, password, mobile, address).
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _name = TextEditingController(text: CacheHelper.userName);
  final _email = TextEditingController(text: CacheHelper.userEmail);
  final _phone = TextEditingController(text: CacheHelper.userPhone);
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _password = TextEditingController(text: '••••••••••••');
  final _address = TextEditingController();
  late final AddressesCubit _addresses = sl<AddressesCubit>()..load();
  bool _editing = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _password.dispose();
    _address.dispose();
    _addresses.close();
    super.dispose();
  }

  void _edit(FocusNode focus) {
    setState(() => _editing = true);
    WidgetsBinding.instance.addPostFrameCallback((_) => focus.requestFocus());
  }

  void _cancelEdit() {
    FocusScope.of(context).unfocus();
    setState(() {
      _editing = false;
      _name.text = CacheHelper.userName;
      _email.text = CacheHelper.userEmail;
      _phone.text = CacheHelper.userPhone;
    });
  }

  Future<void> _logout() async {
    await CacheHelper.clearSession();
    if (!mounted) return;
    context.read<CartCubit>().reset();
    context.read<WishlistCubit>().reset();
    context.go(AppRouter.login);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) showToast(state.message, error: true);
        if (state is AuthMessage) {
          showToast(state.message == 'success' ? 'Saved' : state.message);
          FocusScope.of(context).unfocus();
          setState(() => _editing = false);
        }
      },
      builder: (context, state) {
        final busy = state is AuthLoading;
        final firstName = CacheHelper.userName.split(' ').first;
        return SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              const Align(
                  alignment: Alignment.centerLeft, child: RouteLogo(fontSize: 26)),
              const SizedBox(height: 24),
              Text(firstName.isEmpty ? 'Welcome' : 'Welcome, $firstName',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.ink)),
              if (CacheHelper.userEmail.isNotEmpty)
                Text(CacheHelper.userEmail,
                    style: const TextStyle(fontSize: 14, color: AppColors.inkMuted)),
              const SizedBox(height: 32),
              _ProfileField(
                label: 'Your full name',
                controller: _name,
                focusNode: _nameFocus,
                readOnly: !_editing,
                hint: 'Enter your full name',
                onEdit: () => _edit(_nameFocus),
              ),
              _ProfileField(
                label: 'Your E-mail',
                controller: _email,
                focusNode: _emailFocus,
                readOnly: !_editing,
                hint: 'Enter your e-mail',
                keyboard: TextInputType.emailAddress,
                onEdit: () => _edit(_emailFocus),
              ),
              _ProfileField(
                label: 'Your password',
                controller: _password,
                readOnly: true,
                onEdit: () => _changePassword(context),
              ),
              _ProfileField(
                label: 'Your mobile number',
                controller: _phone,
                focusNode: _phoneFocus,
                readOnly: !_editing,
                hint: 'Enter your mobile number',
                keyboard: TextInputType.phone,
                onEdit: () => _edit(_phoneFocus),
              ),
              BlocConsumer<AddressesCubit, AddressesState>(
                bloc: _addresses,
                listener: (context, s) {
                  _address.text = s is AddressesLoaded && s.addresses.isNotEmpty
                      ? '${s.addresses.first.details}, ${s.addresses.first.city}'
                      : '';
                },
                builder: (context, s) {
                  return _ProfileField(
                    label: 'Your Address',
                    controller: _address,
                    readOnly: true,
                    hint: s is AddressesLoading ? 'Loading…' : 'Add an address',
                    onEdit: () => _manageAddresses(context),
                  );
                },
              ),
              if (_editing) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: busy ? null : _cancelEdit,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          minimumSize: const Size(0, 52),
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: busy
                            ? null
                            : () => context.read<AuthCubit>().updateProfile(
                                  name: _name.text.trim(),
                                  email: _email.text.trim(),
                                  phone: _phone.text.trim(),
                                ),
                        style: ElevatedButton.styleFrom(minimumSize: const Size(0, 52)),
                        child: busy
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Text('Save'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              _ActionTile(
                icon: Icons.receipt_long_outlined,
                label: 'My Orders',
                onTap: () => context.push(AppRouter.orders),
              ),
              const SizedBox(height: 12),
              _ActionTile(
                icon: Icons.logout,
                label: 'Logout',
                color: AppColors.danger,
                onTap: _logout,
              ),
            ],
          ),
        );
      },
    );
  }

  void _changePassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<AuthCubit>(),
        child: const _ChangePasswordDialog(),
      ),
    );
  }

  void _manageAddresses(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => BlocProvider.value(value: _addresses, child: const _AddressesSheet()),
    );
  }
}

/// Label + outlined field with a pencil, as in the profile design.
class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final String? hint;
  final TextInputType? keyboard;
  final VoidCallback onEdit;
  const _ProfileField({
    required this.label,
    required this.controller,
    required this.readOnly,
    required this.onEdit,
    this.focusNode,
    this.hint,
    this.keyboard,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: AppColors.outline),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.ink)),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            focusNode: focusNode,
            readOnly: readOnly,
            keyboardType: keyboard,
            onTap: readOnly ? onEdit : null,
            style: const TextStyle(fontSize: 14, color: AppColors.ink),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 14, color: AppColors.inkMuted),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              border: border,
              enabledBorder: border,
              focusedBorder: border.copyWith(
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
              suffixIcon: IconButton(
                tooltip: 'Edit $label',
                icon: const Icon(Icons.edit_outlined, color: AppColors.ink),
                onPressed: onEdit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        leading: Icon(icon, color: color),
        title: Text(label,
            style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.chevron_right, color: color),
        onTap: onTap,
      ),
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _current = TextEditingController();
  final _next = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthMessage) Navigator.pop(context);
      },
      builder: (context, state) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Change password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _current,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Current password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _next,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'New password'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: state is AuthLoading
                ? null
                : () => context.read<AuthCubit>().changePassword(
                    current: _current.text.trim(), password: _next.text.trim()),
            style: ElevatedButton.styleFrom(minimumSize: const Size(110, 44)),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}

/// Saved addresses (`/addresses`): list, delete and add.
class _AddressesSheet extends StatefulWidget {
  const _AddressesSheet();

  @override
  State<_AddressesSheet> createState() => _AddressesSheetState();
}

class _AddressesSheetState extends State<_AddressesSheet> {
  final _name = TextEditingController();
  final _details = TextEditingController();
  final _phone = TextEditingController();
  final _city = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _details.dispose();
    _phone.dispose();
    _city.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    if (_details.text.trim().isEmpty || _phone.text.trim().isEmpty || _city.text.trim().isEmpty) {
      showToast('Please fill the address', error: true);
      return;
    }
    setState(() => _saving = true);
    final ok = await context.read<AddressesCubit>().add(Address(
          id: '',
          name: _name.text.trim().isEmpty ? 'Home' : _name.text.trim(),
          details: _details.text.trim(),
          phone: _phone.text.trim(),
          city: _city.text.trim(),
        ));
    if (!mounted) return;
    setState(() => _saving = false);
    if (!ok) {
      showToast('Could not save the address', error: true);
      return;
    }
    for (final c in [_name, _details, _phone, _city]) {
      c.clear();
    }
    showToast('Address saved');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your addresses',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.ink)),
              const SizedBox(height: 8),
              BlocBuilder<AddressesCubit, AddressesState>(
                builder: (context, s) {
                  if (s is AddressesLoading || s is AddressesInitial) {
                    return const Padding(padding: EdgeInsets.all(16), child: CustomLoading());
                  }
                  if (s is AddressesFailure) {
                    return Text(s.message, style: const TextStyle(color: AppColors.danger));
                  }
                  final list = (s as AddressesLoaded).addresses;
                  if (list.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('No saved addresses yet.',
                          style: TextStyle(color: AppColors.inkMuted)),
                    );
                  }
                  return Column(
                    children: list
                        .map((a) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.location_on_outlined,
                                  color: AppColors.primary),
                              title: Text('${a.name} - ${a.city}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500, color: AppColors.ink)),
                              subtitle: Text('${a.details}\n${a.phone}'),
                              isThreeLine: true,
                              trailing: IconButton(
                                tooltip: 'Delete address',
                                icon: const Icon(Icons.delete_outline, color: AppColors.ink),
                                onPressed: () =>
                                    context.read<AddressesCubit>().remove(a.id),
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
              const Divider(height: 24),
              const Text('Add a new address',
                  style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.ink)),
              const SizedBox(height: 12),
              TextField(
                  controller: _name,
                  decoration: const InputDecoration(hintText: 'Label (Home, Work...)')),
              const SizedBox(height: 12),
              TextField(
                  controller: _details,
                  decoration: const InputDecoration(hintText: 'Address details')),
              const SizedBox(height: 12),
              TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(hintText: 'Phone')),
              const SizedBox(height: 12),
              TextField(
                  controller: _city, decoration: const InputDecoration(hintText: 'City')),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saving ? null : _add,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(0, 52)),
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Save address'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
