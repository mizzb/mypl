import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TeamCard extends StatelessWidget {
  const TeamCard({
    Key? key,
    required this.imagePath,
    required this.teamName,
  }) : super(key: key);

  final String imagePath;
  final String teamName;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.5),
      elevation: 10,
      child: ListTile(
        leading: Padding(
          padding: EdgeInsets.all(2.w),
          child: Image.asset(
            imagePath,
            width: 20.w,
            height: 10.h,
          ),
        ),
        title: AutoSizeText(
          teamName,
          maxLines: 1,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
