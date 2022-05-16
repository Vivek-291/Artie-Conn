import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_proj/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cp_proj/models/user.dart' as model;
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../utils/colors.dart';
import '../utils/global_variable.dart';
import 'package:line_icons/line_icons.dart';

class MobileScreenLayout extends StatefulWidget
{
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: GNav(
        backgroundColor: mobileBackgroundColor,
        tabBackgroundGradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.black87, Colors.black],
        ),
        gap: 6,
        tabBorderRadius: 10,
        color: Colors.grey[600],
        activeColor: Colors.white,
        iconSize: 14,
        textStyle: const TextStyle(fontSize: 12, color: Colors.white),
        tabBackgroundColor: Colors.grey[800]!,
        padding:
        const EdgeInsets.symmetric(horizontal: 15, vertical: 16.5),
        duration: const Duration(milliseconds: 200),
        tabs: const [
          GButton(
            icon: LineIcons.home,
            text: 'Home',
          ),
          GButton(
            icon: LineIcons.search,
            text: 'Search',
          ),
          GButton(
            icon: LineIcons.plusCircle,
            text: 'Add Post',
          ),
          GButton(
            icon: LineIcons.heart,
            text: 'Notifications',
          ),

          GButton(
            icon: LineIcons.user,
            text: 'Profile',
          ),
        ],
        onTabChange: navigationTapped,
      ),

    );
  }
}
