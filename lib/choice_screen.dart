import 'package:cp_proj/utils/colors.dart';
import 'package:cp_proj/utils/colors.dart';
import 'package:flutter/material.dart';


class ChipDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChipDemoState();
}

class _ChipDemoState extends State<ChipDemo> {
  late GlobalKey<ScaffoldState> _key;
  late bool _isSelected;
  late List<InterestsWidget> _interests;
  late List<String> _filters;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey<ScaffoldState>();
    _isSelected = false;
    _filters = <String>[];
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
      appBar: AppBar(
        title: Text("Select your Interests.."),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Wrap(
              children: interestName.toList(),
            ),
            // _buildChoiceChips(),
          ],
        ),
      )
      ,
    );
  }

  Iterable<Widget> get interestName sync* {
    for (InterestsWidget intrsts in _interests) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          backgroundColor: chioceUnselected,
          avatar: CircleAvatar(
            backgroundColor: Colors.cyan,
            child: Text(
              intrsts.name[0].toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          label: Text(
            intrsts.name,
          ),
          selected: _filters.contains(intrsts.name),
          selectedColor: chioceSelected,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _filters.add(intrsts.name);
              } else {
                _filters.removeWhere((String name) {
                  return name == intrsts.name;
                });
              }
            });
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
