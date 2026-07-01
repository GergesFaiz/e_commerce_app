import 'package:e_commerce/tabs/BrowseTab/browse_tab.dart';
import 'package:e_commerce/tabs/HomeTab/home_tab.dart';
import 'package:e_commerce/tabs/ProfileTab/profile_tab.dart';
import 'package:e_commerce/tabs/SearchTab/search_tab.dart';
import 'package:flutter/material.dart';
import 'package:movies/tabs/BrowseTab/browse_tab.dart';
import 'package:movies/tabs/HomeTab/home_tab.dart';
import 'package:movies/tabs/ProfileTab/profile_tab.dart';
import 'package:movies/tabs/SearchTab/search_tab.dart';
import 'package:movies/utils/app_colors.dart';

import 'core/theme/app_colors.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    HomeTab(),
    SearchTab(),
    BrowseTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        backgroundColor: AppColors.gray,
        selectedItemColor: AppColors.amber,
        unselectedItemColor: AppColors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: 'WatchList',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
