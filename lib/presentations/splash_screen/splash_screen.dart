import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pran_rfl_erp/core/utils/image_constant.dart';
import 'package:pran_rfl_erp/presentations/login_screeen/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static const String routePath = "/splash-screen";
  static const String routeName = "splash-screen";
  @override
  Widget build(BuildContext context) {
    return const SplashScreenBody();
  }
}

class SplashScreenBody extends StatefulWidget {
  const SplashScreenBody({super.key});

  @override
  State<SplashScreenBody> createState() => _SplashScreenBodyState();
}

class _SplashScreenBodyState extends State<SplashScreenBody> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 4), () {
      context.pushReplacementNamed(LoginScreen.routeName);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
          image: AssetImage(
            ImageConstant.companylogoImg,
          ),
          height: 150,
          width: 150,
        ),
      ),
    );
  }
}
