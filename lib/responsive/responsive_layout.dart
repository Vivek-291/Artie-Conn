import 'package:cp_proj/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:cp_proj/utils/dimensions.dart';
import 'package:provider/provider.dart';


class ResponsiveLayout extends StatefulWidget {

  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout ({Key? key ,
    required this.mobileScreenLayout,
    required this.webScreenLayout}) :
        super(key: key);
  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    super.initState();
    addData();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        if( constraints.maxWidth > webScreenSize){
          return widget.webScreenLayout;
        }
        return widget.mobileScreenLayout;
      },
    );
  }

  void addData() async{
    UserProvider _userProvider = Provider.of(context , listen: false);
    await _userProvider.refreshUser();
  }
}

