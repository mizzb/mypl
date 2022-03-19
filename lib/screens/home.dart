import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mypl/screens/match.dart';
import 'package:mypl/widgets/headerText.dart';
import 'package:mypl/widgets/mainButton.dart';
import 'package:mypl/widgets/mainContainer.dart';
import 'package:mypl/widgets/teamCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../team_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _teamCard = [];
  final GlobalKey<AnimatedListState> _teamListKey =
      GlobalKey<AnimatedListState>();
  final Tween<Offset> _offset =
      Tween(begin: const Offset(1, 0), end: const Offset(0, 0));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _addTeam();
    });
  }

  /// iterating and adding team cards to _teamcard list for displaying team list
  /// slowing down the addition for animation purpose
  void _addTeam() {
    Future _futer = Future(() {});
    for (var element in teams) {
      _futer = _futer
          .then((value) => Future.delayed(const Duration(milliseconds: 50), () {
                _teamCard.add(TeamCard(
                    teamName: element['name']!,
                    imagePath: 'assets/teams/' + element['image']!));
                _teamListKey.currentState?.insertItem(_teamCard.length - 1);
              }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                showHistory();
              },
              child: const Icon(CupertinoIcons.arrow_counterclockwise),
            ),
          ),
        ],
        centerTitle: true,
        title: const HeaderText(headerText: "TEAMS"),
      ),
      body: MainContainer(
        childrens: SafeArea(
            child: Column(
          children: [
            Expanded(
              flex: 10,
              child: AnimatedList(
                key: _teamListKey,
                initialItemCount: _teamCard.length,
                itemBuilder: (BuildContext context, int index,
                    Animation<double> animation) {
                  return SlideTransition(
                    position: animation.drive(_offset),
                    child: _teamCard[index],
                  );
                },
              ),
            ),
            const Divider(
              color: Colors.orangeAccent,
            ),
            Expanded(
                flex: 1,
                child: SizedBox(
                    child: Center(
                        child: MainButton(
                            buttonWidth: 70.w,
                            buttonColor: Colors.orangeAccent,
                            buttonTextColor: Colors.white,
                            buttonText: "Start Match!",
                            callbackAction: startMatch)))),
          ],
        )),
      ),
    );
  }

  /// Navigate to match screen for simulation
  startMatch() {
    Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const MatchScreen(),
        ));
  }

  /// fetching previous match details from local shared preference
  showHistory() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('history')) {
      var resp = _prefs.getString('history');
      if (resp == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No history to display")));
      } else {
        var decode = jsonDecode(resp);
        showGeneralDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black.withOpacity(0.5),
            barrierLabel: '',
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return Transform.scale(
                scale: 1,
                child: AlertDialog(
                  backgroundColor: Colors.black,
                  title: const Center(
                    child: Text(
                      'LAST MATCH RESULT',
                      style: TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  content: SizedBox(
                    width: 100.w,
                    height: 30.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AutoSizeText(
                          " TOURNAMENT WINNER ",
                          minFontSize: 10,
                          maxFontSize: 13,
                          maxLines: 1,
                          style: TextStyle(color: Colors.white),
                        ),
                        const Divider(
                          color: Colors.orangeAccent,
                        ),
                        AutoSizeText(
                          teams[decode['winner']]['name'].toString(),
                          minFontSize: 20,
                          maxFontSize: 30,
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        const Divider(
                          color: Colors.orangeAccent,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        const AutoSizeText(
                          "First runners up :",
                          minFontSize: 10,
                          maxFontSize: 15,
                          maxLines: 1,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        AutoSizeText(
                          teams[decode['first']]['name'].toString(),
                          minFontSize: 10,
                          maxFontSize: 15,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2.5.h,
                        ),
                        const AutoSizeText(
                          "Second Runners up : ",
                          minFontSize: 10,
                          maxFontSize: 15,
                          maxLines: 1,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        AutoSizeText(
                          teams[decode['second']]['name'].toString(),
                          minFontSize: 10,
                          maxFontSize: 15,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                      ],
                    ),
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actionsPadding: EdgeInsets.zero,
                  actions: [
                    SizedBox(
                      height: 5.h,
                      child: MainButton(
                          buttonWidth: 50.w,
                          buttonColor: Colors.orangeAccent,
                          buttonTextColor: Colors.white,
                          buttonText: "Close",
                          callbackAction: () async {
                            Navigator.pop(context);
                          }),
                    )
                  ],
                ),
              );
            });
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No history to display")));
    }
  }
}
