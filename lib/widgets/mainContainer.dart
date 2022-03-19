import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MainContainer extends StatelessWidget {
  const MainContainer({Key? key, required this.childrens}) : super(key: key);

  final Widget childrens;
  @override
  Widget build(BuildContext context) {

    return Container(
      height: 100.h,
      width: 100.w,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.grey,
            Colors.black
          ],
        ),
      ),
      child: childrens,
    );
  }
}
