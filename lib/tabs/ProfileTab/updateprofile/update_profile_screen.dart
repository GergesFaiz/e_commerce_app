import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies/screens/login/login_screen.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/utils/screen_utils.dart';
import 'package:movies/widgets/back_app_bar.dart';
import 'package:movies/widgets/custom_text_field.dart';

import '../../../utils/appRoutes.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_elevatedbutton.dart';
import 'avatars_bottom_sheet.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  int selectedAvatar = 2;
  bool avatarChanged = false;

  final List<String> avatarImages = [
    AppAssets.avatar7,
    AppAssets.avatar8,
    AppAssets.avatar9,
    AppAssets.avatar4,
    AppAssets.avatar5,
    AppAssets.avatar6,
    AppAssets.avatar1,
    AppAssets.avatar2,
    AppAssets.avatar3,
  ];

  late TextEditingController namecontroller;
  late TextEditingController phonecontroller;

  @override
  void initState() {
    namecontroller = TextEditingController();
    phonecontroller = TextEditingController();
    _loadCurrentData();
    super.initState();
  }

  Future<void> _loadCurrentData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get();

    if (doc.exists) {
      final data = doc.data();
      final currentAvatar = data?['avatar'] as String?;
      final index = avatarImages.indexOf(currentAvatar ?? '');
      setState(() {
        if (index != -1) selectedAvatar = index;
        namecontroller.text = data?['name'] ?? '';
        phonecontroller.text = data?['phoneNum'] ?? '';
      });
    }
  }

  @override
  void dispose() {
    namecontroller.dispose();
    phonecontroller.dispose();
    super.dispose();
  }

  Widget _buildAvatarImage(String path) {
    if (path.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: BoxFit.cover,
        placeholder: (_, __) => const CircularProgressIndicator(),
        errorWidget: (_, __, ___) =>
            Image.asset(avatarImages[selectedAvatar], fit: BoxFit.cover),
      );
    }
    return Image.asset(path, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Something went wrong')));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData) {
          return LoginScreen();
        }

        final user = snapshot.data!;

        return Scaffold(
          appBar: BackAppBar(title: 'Edit Profile'),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: Column(
                  spacing: height * 0.02,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () => showAvatarsBottomSheet(),
                        child: Container(
                          width: width * 0.40,
                          height: width * 0.40,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: ClipOval(
                            child: avatarChanged
                                ? Image.asset(
                                    avatarImages[selectedAvatar],
                                    fit: BoxFit.cover,
                                  )
                                : StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(user.uid)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      }
                                      final data =
                                          snapshot.data?.data()
                                              as Map<String, dynamic>?;
                                      final avatarPath =
                                          data?['avatar'] as String?;
                                      return _buildAvatarImage(
                                        avatarPath ??
                                            avatarImages[selectedAvatar],
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ),
                    CustomTextField(
                      textInputType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      controller: namecontroller,
                      hintText: 'Enter your name',
                    ),
                    CustomTextField(
                      textInputType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      controller: phonecontroller,
                      hintText: 'Enter your phone',
                    ),

                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.forgotPasswordScreen,
                      ),
                      child: Text(
                        'Reset Password',
                        style: TextStyle(color: AppColors.kText, fontSize: 14),
                      ),
                    ),

                    SizedBox(height: height * 0.23),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 15,
                      children: [
                        CustomElevatedButton(
                          label: 'Delete Account',
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(user.uid)
                                .delete();
                            await user.delete();
                          },
                          backgroundColor: AppColors.red,
                          textStyle: AppStyles.regular16white,
                        ),

                        CustomElevatedButton(
                          label: 'Update Data',
                          textStyle: AppStyles.regular16black,
                          onPressed: () async {
                            try {
                              final newName = namecontroller.text.trim();
                              final newPhone = phonecontroller.text.trim();
                              final newAvatar = avatarImages[selectedAvatar];

                              final Map<String, dynamic> updates = {
                                'avatar': newAvatar,
                              };
                              if (newName.isNotEmpty) updates['name'] = newName;
                              if (newPhone.isNotEmpty) {
                                updates['phoneNum'] = newPhone;
                              }

                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(user.uid)
                                  .set(updates, SetOptions(merge: true));

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Profile updated successfully"),
                                ),
                              );

                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text("Error: $e")));
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showAvatarsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => AvatarsBottomSheet(
        initialAvatar: selectedAvatar,
        onAvatarSelected: (index) {
          setState(() {
            selectedAvatar = index;
            avatarChanged = true;
          });
        },
      ),
    );
  }
}
