import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:movies/screens/login/login_screen.dart';
import 'package:movies/tabs/ProfileTab/profile_tabs/history_tab.dart';
import 'package:movies/tabs/ProfileTab/profile_tabs/watch_list_tab.dart';
import 'package:movies/utils/appRoutes.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/utils/screen_utils.dart';

import '../../utils/firebase_files/auth_function.dart';
import '../../widgets/custom_elevatedbutton.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasError) return const Center(child: Text('Something went wrong'));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) return LoginScreen();

        final user = snapshot.data!;

        return FutureBuilder<Map<String, dynamic>?>(
          future: FirebaseFunctions.getUserData(user.uid),
          builder: (context, userDataSnapshot) {
            final userData = userDataSnapshot.data;
            final userName = userData?['name'] ?? 'Loading...';
            final avatarPath = userData?['avatar'];


            final List? watchList = userData?['watchlist'] as List?;
            final List? historyList = userData?['history'] as List?;

            final String watchListCount = (watchList?.length ?? 0).toString();
            final String historyCount = (historyList?.length ?? 0).toString();

            return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.headerBackground,
                automaticallyImplyLeading: false,
                toolbarHeight: height * 0.32,
                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  child: Column(
                    spacing: height * 0.02,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: width * 0.04,
                        children: [
                          ClipOval(
                            child: _buildAvatar(
                              avatarPath,
                              width * 0.27,
                              AppAssets.avatar7,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                buildStat(watchListCount, 'Watch List', context),
                                buildStat(historyCount, 'History', context),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Text(userName, style: AppStyles.bold20White),

                      Row(
                        spacing: width * 0.03,
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomElevatedButton(
                              textStyle: AppStyles.regular20Black,
                              label: 'Edit Profile',
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.updateProfileScreen,
                                );
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: CustomElevatedButton(
                              icon: const Icon(
                                Icons.logout,
                                color: AppColors.white,
                                size: 20,
                              ),
                              label: 'Exit',
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) => LoginScreen(),
                                    ),
                                        (route) => false,
                                  );
                                }
                              },
                              backgroundColor: AppColors.red,
                              textStyle: AppStyles.regular20white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                bottom: TabBar(
                  dividerHeight: 3,
                  dividerColor: AppColors.transparent,
                  controller: _tabController,
                  indicatorColor: AppColors.amber,
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.white,
                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: AppStyles.regular20white,
                  unselectedLabelStyle: AppStyles.regular20white,
                  tabs: [
                    Tab(
                        icon: const Icon(
                            Icons.list, size: 30, color: AppColors.amber),
                        text: AppLocalizations.of(context)!.watchlist
                      //'Watch List',
                    ),
                    Tab(
                      icon: const Icon(
                        Icons.folder,
                        size: 30,
                        color: AppColors.amber,
                      ),
                      text: 'History',
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [WatchListTab(), HistoryTab()],
              ),
            );
          },
        );
      },
    );
  }
}

Widget _buildAvatar(String? path, double size, String fallbackAsset) {
  if (path != null && path.startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: path,
      width: size,
      height: size,
      fit: BoxFit.cover,
      placeholder: (_, __) => CircularProgressIndicator(),
      errorWidget: (_, __, ___) =>
          Image.asset(fallbackAsset, fit: BoxFit.cover),
    );
  }
  return Image.asset(
    path ?? fallbackAsset,
    width: size,
    height: size,
    fit: BoxFit.cover,
  );
}

Widget buildStat(String count, String label, BuildContext context) {
  return Column(
    spacing: context.height * 0.02,
    children: [
      Text(count, style: AppStyles.bold16White.copyWith(fontSize: 32)),
      Text(label, style: AppStyles.bold16White.copyWith(fontSize: 22)),
    ],
  );
}