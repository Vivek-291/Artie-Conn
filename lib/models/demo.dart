import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Interests{
  final int id;
  final String title;
  final IconData icn;

  Interests(this.id , this.title, this.icn);
}

//Sample Data
List<Interests> interestList = [
  Interests(1, "Music", CupertinoIcons.music_mic),
  Interests(2, "Painting", CupertinoIcons.paintbrush),
  Interests(3, "Dancing", CupertinoIcons.umbrella),
  Interests(4, "Rocket", CupertinoIcons.radiowaves_left),
  Interests(5, "Car", CupertinoIcons.car),
  Interests(6, "Studying", CupertinoIcons.book)

];