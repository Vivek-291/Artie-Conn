import 'package:cp_proj/providers/user_provider.dart';
import 'package:cp_proj/responsive/mobile_screen_layout.dart';
import 'package:cp_proj/responsive/responsive_layout.dart';
import 'package:cp_proj/responsive/web_screen_layout.dart';
import 'package:cp_proj/screens/login_screen.dart';
import 'package:cp_proj/screens/signup_screen.dart';
import 'package:cp_proj/screens/test.dart';
import 'package:cp_proj/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBaU5x_HsWuWujguzg-vWm4ct9oIZYG4e4",
          appId: "1:567850228059:web:604cbd5bcc7d20756ea27e",
          messagingSenderId: "567850228059",
          projectId: "artie-conn",
        storageBucket: "artie-conn.appspot.com",
      ),
    );
  }
  else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
     providers : [
       ChangeNotifierProvider(create: (_) => UserProvider()
       )
     ],
      child: MaterialApp(
      title: 'Artie-Conn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor : mobileBackgroundColor
      ),
      // home: ResponsiveLayout( mobileScreenLayout: MobileScreenLayout() , webScreenLayout: WebScreenLayout() ,),
      // home: LoginScreen(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // Checking if the snapshot has any data or not
            if (snapshot.hasData) {
              // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
              return const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
          }

          // means connection to future hasnt been made yet
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const LoginScreen();
        },
      ),
      ),
    );
  }
}