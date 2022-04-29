import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cp_proj/utils/colors.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Text('This is web screen'),),
    );
  }
}
