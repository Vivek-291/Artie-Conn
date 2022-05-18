import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_proj/widgets/connect_button.dart';
import 'package:cp_proj/widgets/foll_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cp_proj/resources/auth_methods.dart';
import 'package:cp_proj/resources/firestore_methods.dart';
import 'package:cp_proj/screens/login_screen.dart';
import 'package:cp_proj/utils/colors.dart';
import 'package:cp_proj/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../resources/auth_methods.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int connections = 0;
  bool isConnected = false;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      connections = userSnap.data()!['connections'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
      isConnected = userSnap
          .data()!['connections']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userData['username'],
              ),
              centerTitle: false,
              actions: <Widget>[
                FirebaseAuth.instance.currentUser!.uid ==
                    widget.uid
                ? const Text('')
                    : isFollowing
                    ? FollowButton(
                      function: () async {
                        await FireStoreMethods()
                            .followUser(
                          FirebaseAuth.instance
                              .currentUser!.uid,
                          userData['uid'],
                        );
                        Fluttertoast.showToast(
                            msg: "Login User" +
                                FirebaseAuth
                                    .instance
                                    .currentUser!
                                    .uid +
                                " Unfollowed : " +
                                userData['uid'],
                            toastLength:
                            Toast.LENGTH_SHORT,
                            gravity:
                            ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor:
                            Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        setState(() {
                          isFollowing = false;
                          followers--;
                        });
                      },
                        icon: const Icon(MdiIcons.accountCheck),
                )
                :FollowButton(

                function: () async {
                    await FireStoreMethods()
                        .followUser(
                      FirebaseAuth.instance
                          .currentUser!.uid,
                      userData['uid'],
                    );
                    Fluttertoast.showToast(
                        msg: "Login User" +
                            FirebaseAuth
                                .instance
                                .currentUser!
                                .uid +
                            " Followed : " +
                            userData['uid'],
                        toastLength:
                        Toast.LENGTH_SHORT,
                        gravity:
                        ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor:
                        Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);

                    setState(() {
                      isFollowing = true;
                      followers++;
                    });
                  }, icon: const Icon(Icons.person_add_alt_1_rounded),
                )
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(connections, "connections"),
                                    buildStatColumn(followers, "followers"),
                                    buildStatColumn(following, "following"),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? ConnectButton(
                                            text: 'Sign Out',
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            textColor: primaryColor,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              await AuthMethods().signOut();
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginScreen(),
                                                ),
                                              );
                                            },
                                          )
                                        : isConnected
                                            ? ConnectButton(
                                                text: 'Remove Connection',
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  await FireStoreMethods()
                                                      .connectUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );
                                                  Fluttertoast.showToast(
                                                      msg: "Login User" +
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid +
                                                          " Removed : " +
                                                          userData['uid'],
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                  setState(() {
                                                    isConnected = false;
                                                    connections--;
                                                  });
                                                },
                                              )
                                            : ConnectButton(
                                                text: 'Connect',
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                borderColor: Colors.blue,
                                                function: () async {
                                                  await FireStoreMethods()
                                                      .connectUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );
                                                  Fluttertoast.showToast(
                                                      msg: "Login User" +
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid +
                                                          " Connected : " +
                                                          userData['uid'],
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);

                                                  setState(() {
                                                    isConnected = true;
                                                    connections++;
                                                  });
                                                },
                                              )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];

                        return Container(
                          child: Image(
                            image: NetworkImage(snap['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
