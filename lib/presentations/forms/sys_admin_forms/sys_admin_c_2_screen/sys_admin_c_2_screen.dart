import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/entities/apps_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_lable_wth_textfield.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_2_screen/bloc/apps_user_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_2_screen/bloc/user_create_bloc.dart';

class SysAdminC2Screen extends StatelessWidget {
  const SysAdminC2Screen({super.key});
  static const String routeName = "SYSTEM-ADMINISTRATOR-C-2-SCREEN";
  static const String routePath = "/SYSTEM-ADMINISTRATOR-C-2-SCREEN";
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppsUserBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<AppsUserData>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<bool>(),
        ),
        BlocProvider(
          create: (context) => UserCreateBloc(getService()),
        ),
      ],
      child: const SysAdminC2ScreenBody(),
    );
  }
}

class SysAdminC2ScreenBody extends StatefulWidget {
  const SysAdminC2ScreenBody({super.key});

  @override
  State<SysAdminC2ScreenBody> createState() => _SysAdminC2ScreenBodyState();
}

class _SysAdminC2ScreenBodyState extends State<SysAdminC2ScreenBody> {
  TextEditingController userNameTextController = TextEditingController();
  FocusNode userNameFocusNode = FocusNode();

  TextEditingController userIdTextController = TextEditingController();
  FocusNode userIdFocusNode = FocusNode();

  TextEditingController appUserTextController = TextEditingController();
  FocusNode appUserFocusNode = FocusNode();

  TextEditingController mobileTextController = TextEditingController();
  FocusNode mobileFocusNode = FocusNode();
  TextEditingController passTextController = TextEditingController();
  FocusNode passFocusNode = FocusNode();
  late UserInfoModel loggedUser;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context.read<AppsUserBloc>().add(GetAppsUserEvent());
    context.read<VariableStateHandlerCubit<bool>>().update(true);
    super.initState();
  }

  @override
  void dispose() {
    userNameTextController.dispose();
    userNameFocusNode.dispose();
    userIdTextController.dispose();
    userIdFocusNode.dispose();
    appUserFocusNode.dispose();
    appUserTextController.dispose();
    mobileFocusNode.dispose();
    mobileTextController.dispose();
    passFocusNode.dispose();
    passTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "User Creation"),
      body: BlocListener<UserCreateBloc, UserCreateState>(
        listener: (context, state) {
          if (state is UserCreateSuccess) {
            userIdTextController.clear();
            userNameTextController.clear();
            mobileTextController.clear();
            passTextController.clear();
            context.read<VariableStateHandlerCubit<AppsUserData>>().reset();
            appUserTextController.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.successSnackber(
                message: "User Created Successfully",
              ),
            );
          }
          if (state is UserCreateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.errorSnackber(
                message: state.error.toString(),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CommonLableWthTextField(
                      lableName: "User Id",
                      focusNode: userIdFocusNode,
                      textController: userIdTextController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter User Id";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CommonLableWthTextField(
                      lableName: "User Name",
                      focusNode: userNameFocusNode,
                      textController: userNameTextController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter User Name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CommonLableWthTextField(
                      lableName: "Mobile No",
                      focusNode: mobileFocusNode,
                      textController: mobileTextController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Mobile";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CommonLableWthTextField(
                      lableName: "Password",
                      obscureText: context
                          .watch<VariableStateHandlerCubit<bool>>()
                          .state!,
                      focusNode: passFocusNode,
                      keyboardType: TextInputType.text,
                      textController: passTextController,
                      onChanged: (value) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Password";
                        }
                        return null;
                      },
                      suffixIcon: GestureDetector(
                        onTap: () {
                          var isObtext = context
                              .read<VariableStateHandlerCubit<bool>>()
                              .state!;
                          context
                              .read<VariableStateHandlerCubit<bool>>()
                              .update(!isObtext);
                        },
                        child: Icon(
                          color: appTheme.primary,
                          context
                                  .watch<VariableStateHandlerCubit<bool>>()
                                  .state!
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: BlocBuilder<AppsUserBloc, AppsUserState>(
                            builder: (context, state) {
                              return CommonDropdownButton<AppsUserData>(
                                hintText: "Select Apps User",
                                items: state is AppsUserSuccess
                                    ? state.appsDataList
                                    : [],
                                value: context
                                    .watch<
                                        VariableStateHandlerCubit<
                                            AppsUserData>>()
                                    .state,
                                onChanged: (value) {
                                  context
                                      .read<
                                          VariableStateHandlerCubit<
                                              AppsUserData>>()
                                      .update(value!);
                                  appUserTextController.text =
                                      value.description ?? "";
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return "Please Select Apps User";
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: CommonTextFieldWidget(
                            readOnly: true,
                            controller: appUserTextController,
                            focusNode: appUserFocusNode,
                            labelText: "Apps User Name",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<UserCreateBloc, UserCreateState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        var appUser = context
                            .read<VariableStateHandlerCubit<AppsUserData>>()
                            .state!;
                        context.read<UserCreateBloc>().add(
                              CreateUser(
                                userId: loggedUser.userId,
                                appUser: appUser.userId.toString(),
                                deptName: "",
                                desigName: "",
                                mobileNo: mobileTextController.text,
                                newUserId: userIdTextController.text,
                                newUserName: userNameTextController.text,
                                passw: passTextController.text,
                              ),
                            );
                      }
                    },
                    child: Text(
                      state is UserCreateLoading ? "Saving..." : "Save",
                      style: textTheme.bodyMedium!.copyWith(
                        color: appTheme.white,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
