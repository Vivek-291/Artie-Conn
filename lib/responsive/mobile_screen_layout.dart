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
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: GNav(
        backgroundColor: bottomnavBackgroundColor,
        tabBackgroundGradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.lightBlue, Colors.cyanAccent],
        ),
        gap: 4 ,
        tabActiveBorder: Border.all(color: Colors.black, width: 1),
        tabBorderRadius: 5,
        color: Colors.grey[600],
        activeColor: Colors.black,
        iconSize: 18,
        tabBackgroundColor: Colors.black54,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        duration: const Duration(milliseconds: 200),
        tabs: const [
          GButton(
            icon: LineIcons.home,
          ),
          GButton(
            icon: LineIcons.search,
          ),
          GButton(
            icon: LineIcons.plusCircle,
          ),
          GButton(
            icon: LineIcons.bell,
          ),

          GButton(
            icon: LineIcons.user,
          ),
        ],
        onTabChange: navigationTapped,
      ),

    );
  }
}
