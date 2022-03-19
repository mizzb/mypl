import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mypl/screens/home.dart';
import 'package:mypl/widgets/lottie/lottie_widget.dart';
import 'package:mypl/widgets/mainContainer.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyPLApp());
}

class MyPLApp extends StatelessWidget {
  const MyPLApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Sizer used for making responsive screens easily
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return const MaterialApp(
          title: 'MyPL',
          home: SplashScreen(),
        );
      },
    );
  }
}
/// dummy flash screen for displaying loading animation in the beginning
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    /// 3 seconds hard coded for showing the loading animation.
    /// can be replaced with async calls instead of 2 seconds
    /// navigated to home screen after 3 seconds
    _timer = Timer(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const HomeScreen(),
          ),
          (route) => false);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainContainer(
        childrens: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              LottieWidget(),
              AutoSizeText(
                'Please wait, Players are Warming up..',
                minFontSize: 10,
                maxFontSize: 15,
                maxLines: 1,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
