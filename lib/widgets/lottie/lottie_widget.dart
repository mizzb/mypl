import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';


class LottieWidget extends StatelessWidget {
  final String? lottieType;
  final double? lottieWidth;
  final int? lottieDuration;

  const LottieWidget(
      {Key? key, this.lottieType, this.lottieWidth, this.lottieDuration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (lottieWidth != null)
          ? lottieWidth
          : 50.w,
      child: loadLottie(lottieType, context),
    );
  }

  loadLottie(lottieType, context) {
    switch (lottieType) {
      case 'loading':
        return fetchLottie(context, 'assets/lottie/cricket-load.json');
      default:
        return fetchLottie(context, 'assets/lottie/cricket-load.json');
    }
  }

  LottieBuilder fetchLottie(context, path) {
    return Lottie.asset(
      path,
      key: UniqueKey(),
      frameBuilder: (context, child, composition) {
        return AnimatedOpacity(
          child: child,
          opacity: 1,
          duration: Duration(
              seconds: (lottieDuration != null) ? lottieDuration! : 120),
        );
      },
    );
  }
}
