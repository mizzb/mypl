import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    Key? key,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.buttonText,
    required this.buttonWidth,
    required this.callbackAction,
  }) : super(key: key);

  final Color buttonColor;
  final Color buttonTextColor;
  final String buttonText;
  final double buttonWidth;
  final VoidCallback callbackAction;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: callbackAction,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              buttonColor,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ))),
        child: SizedBox(
            width: buttonWidth,
            child: AutoSizeText(
              buttonText.toString().toUpperCase(),
              maxFontSize: 20,
              minFontSize: 10,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: buttonTextColor,
              ),
            )));
  }
}
