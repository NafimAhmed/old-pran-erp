import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/image_constant.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/modules_dashboard_screen/modules_dashboard_screen.dart';
import 'package:pran_rfl_erp/presentations/login_screeen/bloc/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const String routePath = "/login-screen";
  static const String routeName = "login-screen";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(getService()),
      child: const LoginScreenBody(),
    );
  }
}

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({super.key});

  @override
  State<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  TextEditingController staffIDTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  FocusNode staffIDFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  void dispose() {
    staffIDTextController.dispose();
    passwordTextController.dispose();

    passwordFocusNode.unfocus();
    staffIDFocusNode.unfocus();
    staffIDFocusNode.dispose();
    passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.5, 0.5],
            colors: [
              appTheme.primary,
              appTheme.white,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Material(
                elevation: 25,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                      color: appTheme.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage(ImageConstant.companylogoImg),
                        height: 60,
                        width: 120,
                      ),
                      Text(
                        "Login",
                        style: textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(
                        indent: 10,
                        endIndent: 10,
                        color: appTheme.secondary,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CommonTextFieldWidget(
                              focusNode: staffIDFocusNode,
                              controller: staffIDTextController,
                              keyboardType: TextInputType.phone,
                              labelText: "Staff Id",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Your Staff ID";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            CommonTextFieldWidget(
                              focusNode: passwordFocusNode,
                              controller: passwordTextController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              labelText: "Password",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Your Password";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      BlocConsumer<LoginBloc, LoginState>(
                        listener: (context, state) {
                          if (state is LoginSuccess) {
                            context.pushReplacementNamed(
                                ModulesDashboardScreen.routeName,
                                extra: {
                                  // "menuItems": state.menuItems,
                                });
                            context.read<LoggedUserInfoCubit>().setLoggedUser(
                                userInfoModel: state.userInfoModel);
                          }
                          if (state is LoginError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBar.errorSnackber(
                                message: state.error.toString(),
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<LoginBloc>().add(
                                      Login(
                                        staffId: int.parse(
                                            staffIDTextController.text),
                                        password: passwordTextController.text,
                                      ),
                                    );
                              }
                            },
                            child: Text(
                              state is LoginLoading ? "Logging..." : "Login",
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
