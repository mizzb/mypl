import 'dart:convert';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mypl/team_list.dart';
import 'package:mypl/widgets/headerText.dart';
import 'package:mypl/widgets/lottie/lottie_widget.dart';
import 'package:mypl/widgets/mainButton.dart';
import 'package:mypl/widgets/mainContainer.dart';
import 'package:mypl/widgets/teamMatchCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key}) : super(key: key);

  @override
  _MatchScreenState createState() {
    return _MatchScreenState();
  }
}

class _MatchScreenState extends State<MatchScreen> {
  late Future<dynamic> _loadViewData;
  final int _noOfRounds = 3;
  int _currentRound = 1;

  final List<int> _fixtureNumbers = [];
  late List<int> _roundWinners = [];
  final List<Widget> _teamList = [];
  late List<int> _losersList = [];
  late List<int> _finalist = [];

  @override
  void initState() {
    super.initState();
    _loadViewData = _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey,
        centerTitle: true,
        title: (_currentRound != _noOfRounds)
            ? HeaderText(headerText: "ROUND " + _currentRound.toString())
            : const HeaderText(headerText: "FINALE !"),
      ),
      body: MainContainer(
        childrens: SafeArea(
          child: FutureBuilder(
            future: _loadViewData,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Expanded(
                      flex: 10,
                      child: ListView.builder(
                          itemCount: _teamList.length,
                          itemBuilder: (contex, index) {
                            return _teamList[index];
                          }),
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
                                    buttonText: "Simulate Match!",
                                    callbackAction: () {
                                      simulate(context);
                                    })))),
                  ],
                );
              } else {
                return const LottieWidget();
              }
            },
          ),
        ),
      ),
    );
  }

  /// Simulates the next round, display match summary in a dialogue popup
  simulate(BuildContext context) {
    if (_currentRound < _noOfRounds) {
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
              child: Dialog(
                backgroundColor: Colors.black,
                child: SizedBox(
                  width: 100.w,
                  height: 50.h,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            'ROUND ' + _currentRound.toString() + ' WINNERS !',
                            style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.orange,
                      ),
                      Expanded(
                        flex: 10,
                        child: ListView.builder(
                            itemCount: _roundWinners.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 80.w,
                                child: Card(
                                  color: Colors.yellowAccent.withOpacity(0.5),
                                  elevation: 10,
                                  child: ListTile(
                                    leading: Padding(
                                      padding: EdgeInsets.all(1.w),
                                      child: Image.asset(
                                        'assets/teams/' +
                                            teams[_roundWinners[index]]
                                                ['image']!,
                                        width: 20.w,
                                        height: 10.h,
                                      ),
                                    ),
                                    title: AutoSizeText(
                                      teams[_roundWinners[index]]['name']!,
                                      maxLines: 2,
                                      maxFontSize: 15,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      const Divider(
                        color: Colors.orange,
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: MainButton(
                              buttonWidth: 50.w,
                              buttonColor: Colors.orangeAccent,
                              buttonTextColor: Colors.white,
                              buttonText: "Proceed",
                              callbackAction: () {
                                _currentRound++;
                                if (_roundWinners.length == 4) {
                                  _losersList = _roundWinners;
                                }

                                _roundWinners = simulateMatch(_roundWinners);

                                if (_losersList.isNotEmpty &&
                                    _finalist.isEmpty) {
                                  _finalist = _roundWinners;
                                  _roundWinners.every(
                                      (element) => _losersList.remove(element));
                                } else if (_losersList.isNotEmpty &&
                                    _finalist.isNotEmpty) {
                                  _finalist.remove(_roundWinners[0]);
                                }
                                setState(() {
                                  Navigator.pop(context);
                                });
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    } else if (_currentRound == _noOfRounds) {
      List _thirdWinner = simulateMatch(_losersList);
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
                    'FINAL RESULT !',
                    style: TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                content: SizedBox(
                  width: 100.w,
                  height: 35.h,
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
                        teams[_roundWinners[0]]['name'].toString(),
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
                        "First Runners up",
                        minFontSize: 10,
                        maxFontSize: 15,
                        maxLines: 1,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      AutoSizeText(
                        teams[_finalist[0]]['name'].toString(),
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
                        "Second Runners up",
                        minFontSize: 10,
                        maxFontSize: 15,
                        maxLines: 1,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      AutoSizeText(
                        teams[_thirdWinner[0]]['name'].toString(),
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
                      AutoSizeText(
                        '( ' +
                            teams[_losersList[0]]['name'].toString() +
                            ' vs ' +
                            teams[_losersList[1]]['name'].toString() +
                            ' )',
                        minFontSize: 6,
                        maxFontSize: 13,
                        maxLines: 1,
                        style: const TextStyle(color: Colors.white),
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
                          SharedPreferences _prefs =
                              await SharedPreferences.getInstance();
                          _prefs.remove('history');
                          var storageData = {
                            'winner': _roundWinners[0],
                            'first': _finalist[0],
                            'second': _thirdWinner[0],
                          };
                          _prefs.setString('history', json.encode(storageData));
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }),
                  )
                ],
              ),
            );
          });
    }
  }

  /// initialise data
  /// generates random number from 0-8 for grouping the team for the match
  /// call simulateMatch with generated random number
  _initData() async {
    Random random = Random();
    var data = Future<dynamic>(() {
      do {
        int randomNumber = random.nextInt(teams.length);
        if (!_fixtureNumbers.contains(randomNumber)) {
          _fixtureNumbers.add(randomNumber);
        }
      } while (_fixtureNumbers.length < teams.length);
      _roundWinners = simulateMatch(_fixtureNumbers);
      return _roundWinners;
    });
    return await data;
  }

  /// Accept tthe genrated list, iterates it and select two teams for the match
  /// select one among two randomly as the winner
  /// returns new generated list with winners
  simulateMatch(List<int> matchParticipants) {
    List<int> winners = [];
    _teamList.clear();
    for (int i = 0; i < matchParticipants.length; i = i + 2) {
      var group = [];
      _teamList.add(TeamMatchCard(
        imagePathOne: 'assets/teams/' + teams[matchParticipants[i]]['image']!,
        teamOne: teams[matchParticipants[i]]['name']!,
        teamTwo: teams[matchParticipants[i + 1]]['name']!,
        imagePathTwo:
            'assets/teams/' + teams[matchParticipants[i + 1]]['image']!,
      ));
      group.add(matchParticipants[i]);
      group.add(matchParticipants[i + 1]);
      var count = Random().nextInt(2);
      var winner = group[count];
      winners.add(winner);
    }
    return winners;
  }
}
