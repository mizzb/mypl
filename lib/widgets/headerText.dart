import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key? key,
    required this.headerText,
  }) : super(key: key);

  final String headerText;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      headerText,
      maxFontSize: 30,
      minFontSize: 20,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}
