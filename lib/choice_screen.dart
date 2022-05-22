import 'package:cp_proj/screens/signup_screen.dart';
import 'package:cp_proj/utils/colors.dart';
import 'package:cp_proj/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



class ChipDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChipDemoState();
}

class _ChipDemoState extends State<ChipDemo> {
  late GlobalKey<ScaffoldState> _key;
  // late bool _isSelected;
  late List<InterestsWidget> _interests;
  late List<String> _filters;
  late List<String> selectedProgrammingList;
  late String stringLen;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey<ScaffoldState>();
    // _isSelected = false;
    _filters = <String>[];
    stringLen = _filters.length.toString();
    _interests = <InterestsWidget>[
      InterestsWidget('Art'),
      InterestsWidget('Music'),
      InterestsWidget('Acting'),
      InterestsWidget('Dancing'),
      InterestsWidget('Writing'),
      InterestsWidget('Blogging'),
      InterestsWidget('Community Involvement'),
      InterestsWidget('Travel'),
      InterestsWidget('Social Activities'),
      InterestsWidget('Photography'),
      InterestsWidget('Sports'),
      InterestsWidget('Reading'),
      InterestsWidget('Other'),
    ];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
            const Text('Select Interestes',
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20)),
            const SizedBox(height: 20),
            Wrap(
              children: interestName.toList(),
            ),
            const SizedBox(height: 20),
            Container(
              child: ElevatedButton(

                style: ButtonStyle(
                  alignment: Alignment.center,
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(

                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return buttonColor;
                      return buttonColor; // Use the component's default.
                    },
                  ),
                ),
                child: const Text("Done",
                    style: TextStyle(
                    fontSize: 20)),

                onPressed: () {
                  print(_filters);
                  Fluttertoast.showToast(
                      msg : _filters.length.toString(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  Navigator.of(context).pop(MaterialPageRoute(builder: (context) => SignupScreen()
                      )
                  );
                },
              ),
            ),
          ],

        ),
      ),

    );
  }

  Iterable<Widget> get interestName sync* {
    for (InterestsWidget intrsts in _interests) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          backgroundColor: choiceUnselected,
          avatar: CircleAvatar(
            backgroundColor: Colors.cyan,
            child: Text(
              intrsts.name[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          label: Text(
            intrsts.name,
          ),
          selected: _filters.contains(intrsts.name),
          selectedColor: choiceSelected,
          onSelected: (selected) {
            setState(()
            {
              if (selected) {
                _filters.add(intrsts.name);
              } else {
                _filters.removeWhere((String name) {
                  return name == intrsts.name;

                });
              }
            }
            );
            stringLen = _filters.length.toString();
            },
        )
      );
    }

  }

}
class InterestsWidget {
  const InterestsWidget(this.name);
  final String name;
}
