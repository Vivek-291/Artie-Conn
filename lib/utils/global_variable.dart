import 'package:cp_proj/screens/login_screen.dart';
import 'package:cp_proj/screens/profile_screen.dart';
import 'package:cp_proj/screens/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  // const SearchScreen(),
  // Text('Feed'),
  const SearchScreen(),
  const AddPostScreen(),
  Text('Notifications'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
