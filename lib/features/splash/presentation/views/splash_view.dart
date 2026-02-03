import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      context.go(AppRouter.homeView);
      // if (Prefs.getData(key: kIsOnBoardingViewSeen) == true) {
      //   // print(
      //   //     "ابقي عدل النفجيشن للهوم لما تحط الشيرد بريفرنس بتاع تسجيل الدخول ");
      //   if (getit.get<FirebaseAuthServices>().isUserSignedIn()) {
      //     GoRouter.of(context).pushReplacement(AppRouter.homeView);
      //   } else {
      //     GoRouter.of(context).pushReplacement(AppRouter.signinView);
      //   }
      // } else {
      //   GoRouter.of(context).pushReplacement(AppRouter.onBoarding);
      // }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SplashBody();
  }
}

class SplashBody extends StatelessWidget {
  const SplashBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Image.asset(
          Assets.imagesBackground,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        const Positioned(
          right: 20,
          child: Image(
            image: AssetImage(Assets.imagesGlow),
            height: 270,
          ),
        ),
    
        const Positioned(
          top: 170,
          left: 0,
          child: Image(
            image: AssetImage(Assets.imagesShape07),
            height: 170,
          ),
        ),
        const Positioned(
          bottom: 110,
          right: 0,
          child: Image(
            image: AssetImage(Assets.imagesShape04),
            height: 170,
          ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(
                flex: 1,
              ),
              Image(
                image: AssetImage(Assets.imagesMosque01),
                height: 200,
              ),
              Spacer(
                flex: 10,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                      left: 0,
                      right: 0,
                      top: -170,
                      child: Image(
                        image: AssetImage(Assets.imagesOBJECTS),
                      )),
                  Positioned(
                      // top: 20,
                      // left: 0,
                      // right: 0,
                      child: Image(
                    image: AssetImage(Assets.imagesIslami1),
                  )),
                ],
              ),
              Spacer(
                flex: 10,
              ),
              Text(
                'Supervised by Marwan Saif ',
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        )
        // Positioned(
        //   child: FittedBox(child: Image.asset(Assets.imagesMosque01,width: 200,fit: BoxFit.fitWidth,)),
        //   top: 120,
        //   left: 0,
        //   right: 0,
        // ),
      ],
    ));
  }
}
