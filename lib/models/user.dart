import 'package:cloud_firestore/cloud_firestore.dart';


class UserField {
  static const String lastMessageTime = 'lastMessageTime';
}

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final String status;
  final List followers;
  final List connections;
  final List following;
  final List interests;
  final List requests;

  const User(
      {
        required this.username,
        required this.uid,
        required this.photoUrl,
        required this.email,
        required this.bio,
        required this.connections,
        required this.followers,
        required this.following,
        required this.interests,
        required this.status,
        required this.requests,


        }
      );

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      connections: snapshot["connections"],
      interests: snapshot["interests"],
      status: snapshot["status"],
      requests: snapshot["requests"]
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
        "connections" : connections,
        "interests" : interests,
        "status": status,
        "requests" : requests
      };
}
