import 'dart:typed_data';

import 'package:cp_proj/resources/auth_methods.dart';
import 'package:cp_proj/screens/login_screen.dart';
import 'package:cp_proj/screens/signup_screen.dart';
import 'package:cp_proj/widgets/text_field_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../choice_screen.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';
import '../utils/utils.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key, required List<String> interestsList}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}


class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final List _list = interestsList;
  bool _isLoading = false;
  Uint8List? _image;

  static List get interestsList => interestsList;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    // set loading to true

    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        interests : _list,
        file: _image!);
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }
  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: MediaQuery
              .of(context)
              .size
              .width > webScreenSize
              ? EdgeInsets.symmetric(
              horizontal: MediaQuery
                  .of(context)
                  .size
                  .width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(),
                  flex: 2,
                ),
                //Circular input for image or profile.
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                      radius: 44,
                      backgroundImage: MemoryImage(_image!),
                      backgroundColor: Colors.red,
                    )
                        : const CircleAvatar(
                      radius: 44,
                      backgroundImage: NetworkImage(
                          'https://i.stack.imgur.com/l60Hf.png'),
                      backgroundColor: Colors.red,
                    ),
                    Positioned(
                      bottom: -15,
                        left: 53,
                        child: IconButton(
                        onPressed: selectImage,
                          icon: const Icon(
                              Icons.add_a_photo),
                        ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  hintText: 'Enter your username',
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(

                  hintText: 'Enter your bio',
                  textInputType: TextInputType.text,
                  textEditingController: _bioController,
                ),
                const SizedBox(
                  height: 24,
                ),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return buttonColor;
                          return buttonColor; // Use the component's default.
                        },
                      ),
                    ),
                    child: Text("Select Interests"),
                    onPressed: () {
                      _selectInterestsBottomSheet(context);
                    },
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  child: Container(
                    child: !_isLoading
                        ? const Text(
                      'Sign up',
                    )
                        : const CircularProgressIndicator(
                      color: primaryColor,
                    ),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: buttonColor,
                    ),
                  ),
                  onTap: signUpUser,
                ),
                const SizedBox(
                  height: 14,
                ),
                Flexible(
                  child: Container(),
                  flex: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text(
                        'Already have an account?',
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 30),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                      child: Container(
                        child: const Text(
                          ' LogIn.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 30),
                      ),
                    ),
                  ],
                ),
              ]
          ),
        ),
      ),
    );
  }

  void _selectInterestsBottomSheet(context) {
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (BuildContext bc){

      return FractionallySizedBox(
          heightFactor: 0.7,

        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50))
          ),
          height: MediaQuery.of(context).size.height * .90,
          child : ChipDemo()
          )
        );
      }
    );
  }

}