import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';

import 'package:pran_rfl_erp/core/utils/image_constant.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/login_screeen/login_screen.dart';
import 'package:pran_rfl_erp/presentations/modules_dashboard_screen/modules_dashboard_screen.dart';
import 'package:pran_rfl_erp/presentations/opm_c_1_screen/opm_c_1_screen.dart';

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
    context.read<LoggedUserInfoCubit>().checkLoggedUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoggedUserInfoCubit, UserInfoModel?>(
      listener: (context, state) {
        if (state != null) {
          context.pushReplacementNamed(ModulesDashboardScreen.routeName);
        } else {
          context.pushReplacementNamed(LoginScreen.routeName);
        }
      },
      child: Scaffold(
        body: Center(
          child: Image(
            image: AssetImage(
              ImageConstant.companylogoImg,
            ),
            height: 150,
            width: 150,
          ),
        ),
      ),
    );
  }
}
