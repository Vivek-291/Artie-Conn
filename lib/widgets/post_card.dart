import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_proj/dialog/confirmation_dialog.dart';
import 'package:cp_proj/widgets/connect_button.dart';
import 'package:cp_proj/widgets/send_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cp_proj/models/user.dart' as model;
import 'package:cp_proj/providers/user_provider.dart';
import 'package:cp_proj/resources/firestore_methods.dart';
import 'package:cp_proj/screens/comments_screen.dart';
import 'package:cp_proj/utils/colors.dart';
import 'package:cp_proj/utils/global_variable.dart';
import 'package:cp_proj/utils/utils.dart';
import 'package:cp_proj/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

import '../screens/profile_screen.dart';

class PostCard extends StatefulWidget {

  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  var userData = {};
  int requests = 0;
  int connections = 0;
  bool isRequested = false;
  bool isLoading = false;
  var userSnap;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
    getData();

  }


  getData() async {

    setState(() {
      isLoading = true;
    });
    try {
      // QuerySnapshot snap = await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(widget.snap['uid'])
      //     .collection('')
      //     .get();

      userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.snap['uid'])
          .get();

      userData = userSnap.data()!;
      requests = userSnap.data()!['requests'].length;
      connections = userSnap.data()!['connections'].length;

      isRequested = userSnap
          .data()!['requests']
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


  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider
        .of<UserProvider>(context)
        .getUser;
    final width = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
      // boundary needed for web
      decoration: BoxDecoration(
        border: Border.all(
          color: width > webScreenSize ? secondaryColor : mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'].toString(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.snap['username'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.snap['uid'].toString() == user.uid
                    ? IconButton(
                  onPressed: () {
                    showDialog(
                      useRootNavigator: false,
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16),
                              shrinkWrap: true,
                              children: [
                                'Delete',
                              ]
                                  .map(
                                    (e) =>
                                    InkWell(
                                        child: Container(
                                          padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16),
                                          child: Text(e),
                                        ),
                                        onTap: () {
                                          deletePost(
                                            widget.snap['postId']
                                                .toString(),
                                          );
                                          // remove the dialog box
                                          Navigator.of(context).pop();
                                        }),
                              )
                                  .toList()),
                        );
                      },
                    );
                  },
                      icon: const Icon(Icons.more_vert),
                )
                    : Container(),
              ],
            ),
          ),
          // IMAGE SECTION OF THE POST
          GestureDetector(
            onDoubleTap: () {
              FireStoreMethods().likePost(
                widget.snap['postId'].toString(),
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'].toString(),
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // LIKE, COMMENT SECTION OF THE POST
          Row(
            children: <Widget>[
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                      : const Icon(
                    Icons.favorite_border,
                  ),
                  onPressed: () =>
                      FireStoreMethods().likePost(
                        widget.snap['postId'].toString(),
                        user.uid,
                        widget.snap['likes'],
                      ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.comment_outlined,
                ),
                onPressed: () =>
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            CommentsScreen(
                              postId: widget.snap['postId'].toString(),
                            ),
                      ),
                    ),
              ),
              IconButton(
                  icon: const Icon(MdiIcons.handshake),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) =>
                            NetworkGiffyDialog(
                                image: Image.network(
                                    "https://lmk.suppi.net/Funstuff/Animated%20Gifs/shake-hands.gif",
                                    fit: BoxFit.cover),
                                title: Text(
                                    'Do you want to ping @' +
                                        widget.snap['username'].toString() +
                                        ' for collab ?',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.w600)
                                ),
                                description: const Text(
                                  'This is will send a notification to the user, if he / she accepts it then good for both..',
                                  textAlign: TextAlign.center,
                                ),
                                onOkButtonPressed: () async {
                                  await FireStoreMethods()
                                      .requestUser(
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
                                          " Requested : " +
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
                                    isRequested = true;
                                    requests++;
                                  }
                                  );
                                }
                            )
                    );
                  }),
              IconButton(
                  icon: const Icon(
                    Icons.send,
                  ),
                onPressed: () {
                  _sendMessageBottomsheet(context);
                },
              ),
              Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        icon: const Icon(Icons.bookmark_border),
                        onPressed: () =>
                            Fluttertoast.showToast(
                                msg: "Working on it",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0)),
                  ))
            ],
          ),
          //DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DefaultTextStyle(
                    style: Theme
                        .of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${widget.snap['likes'].length} likes',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText2,
                    )),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap['username'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['description']}',
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    child: Text(
                      'View all $commentLen comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  onTap: () =>
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              CommentsScreen(
                                postId: widget.snap['postId'].toString(),
                              ),
                        ),
                      ),
                ),
                Container(
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  void _sendMessageBottomsheet(context) {
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (BuildContext bc){
      print(FirebaseFirestore.instance
          .collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('bio')
          .get().toString()
      );
      return FractionallySizedBox(
          heightFactor: 0.7,
          child: Container(
            decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
              margin: const EdgeInsets.only(top: 25),
              height: MediaQuery.of(context).size.height * .90,

              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,

                    itemBuilder: (context, index)
                    {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]['photoUrl'],
                          ),
                          radius: 16,
                        ),
                        title: Text(
                          (snapshot.data! as dynamic).docs[index]['username'],
                        ),
                        trailing: const SendButton(
                         textColor: Colors.white,
                          borderColor: Colors.black, backgroundColor: Colors.lightBlue, text: 'Send',
                        ),
                      );
                    },
                  );
                },
              ),

          )
      );
    }
    );
  }

}//Postcard State..