import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/apps_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_drop_down_menu_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_lable_wth_textfield.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';

import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_2_screen/bloc/apps_user_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_2_screen/bloc/user_create_bloc.dart';

class SysAdminC2Screen extends StatelessWidget {
  const SysAdminC2Screen({super.key, required this.fromName});
  static const String routeName = "SYSTEM-ADMINISTRATOR-C-2-SCREEN";
  static const String routePath = "/SYSTEM-ADMINISTRATOR-C-2-SCREEN";
  final String fromName;
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
      child: SysAdminC2ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class SysAdminC2ScreenBody extends StatefulWidget {
  const SysAdminC2ScreenBody(
      {super.key, required this.fromName}); //user creation
  final String fromName;
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
  TextEditingController dropDownTextController = TextEditingController();
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
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: BlocListener<UserCreateBloc, UserCreateState>(
        listener: (context, state) {
          if (state is UserCreateSuccess) {
            userIdTextController.clear();
            userNameTextController.clear();
            mobileTextController.clear();
            passTextController.clear();
            context.read<VariableStateHandlerCubit<AppsUserData>>().reset();
            appUserTextController.clear();
            dropDownTextController.clear();
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
                              return CommonDropDownMenuWidget<AppsUserData>(
                                enabled: state is AppsUserSuccess
                                    ? state.appsDataList.isNotEmpty
                                        ? true
                                        : false
                                    : false,
                                // enableFilter: true,
                                controller: dropDownTextController,
                                hintText: "Select User",

                                onSelected: (value) {
                                  // FocusScope.of(context).unfocus();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  context
                                      .read<
                                          VariableStateHandlerCubit<
                                              AppsUserData>>()
                                      .update(value!);
                                  appUserTextController.text =
                                      value.description ?? "";
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },

                                dropdownMenuEntries: state is AppsUserSuccess
                                    ? state.appsDataList
                                    : [],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          // flex: 2,
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
                      var selectedAppsUser = context
                          .read<VariableStateHandlerCubit<AppsUserData>>()
                          .state;
                      if (formKey.currentState!.validate() &&
                          selectedAppsUser != null) {
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
              Expanded(
                child: BlocBuilder<UserCreateBloc, UserCreateState>(
                  builder: (context, state) {
                    if (state is UserCreateSuccess) {
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              border: Border(
                                bottom: BorderSide(
                                  color: appTheme.primary,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "User ID",
                                      style: textTheme.bodyMedium!,
                                    ),
                                    Text(
                                      state.createdUserList[index].userId ?? "",
                                      style: textTheme.bodySmall!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "User Name",
                                      style: textTheme.bodyMedium!,
                                    ),
                                    Text(
                                      state.createdUserList[index].userName ??
                                          "",
                                      style: textTheme.bodySmall!,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Apps User ID",
                                      style: textTheme.bodyMedium!,
                                    ),
                                    Text(
                                      state.createdUserList[index].appUserId ??
                                          "",
                                      style: textTheme.bodySmall!,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Mobile No",
                                      style: textTheme.bodyMedium!,
                                    ),
                                    Text(
                                      state.createdUserList[index].mobileNo ??
                                          "",
                                      style: textTheme.bodySmall!,
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemCount: state.createdUserList.length,
                      );
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const UserDetailsWidget(),
    );
  }
}
