import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TeamMatchCard extends StatelessWidget {
  const TeamMatchCard({
    Key? key,
    required this.imagePathOne,
    required this.imagePathTwo,
    required this.teamOne,
    required this.teamTwo,
  }) : super(key: key);

  final String imagePathOne;
  final String imagePathTwo;
  final String teamOne;
  final String teamTwo;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.5),
      elevation: 10,
      child: ListTile(
        leading: Padding(
          padding: EdgeInsets.all(2.w),
          child: Image.asset(
            imagePathOne,
            width: 20.w,
            height: 10.h,
          ),
        ),
        title: SizedBox(
          width: 50.w,
          child: AutoSizeText(
            teamOne + ' VS ' + teamTwo,
            maxLines: 2,
            minFontSize: 8,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        trailing: Padding(
          padding: EdgeInsets.all(2.w),
          child: Image.asset(
            imagePathTwo,
            width: 20.w,
            height: 10.h,
          ),
        ),
      ),
    );
  }
}
