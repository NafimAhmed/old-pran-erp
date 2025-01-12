import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_menu_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_drop_down_menu_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/user_menu_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_3_screen/bloc/qr_user_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_3_screen/bloc/qr_user_child_menu_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_3_screen/bloc/qr_user_menu_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_3_screen/bloc/qr_user_permission_bloc.dart';

class SysAdminC3Screen extends StatelessWidget {
  const SysAdminC3Screen({super.key, required this.fromName});
  static const String routeName = "SYSTEM-ADMINISTRATOR-C-3-SCREEN";
  static const String routePath = "/SYSTEM-ADMINISTRATOR-C-3-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => QrUserBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<QrUserData>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<QrUserChildMenu>(),
        ),
        BlocProvider(
          create: (context) => QrUserMenuBloc(getService()),
        ),
        BlocProvider(
          create: (context) => QrUserChildMenuBloc(getService()),
        ),
        BlocProvider(
          create: (context) => QrUserMenuPermissionBloc(getService()),
        ),
      ],
      child: SysAdminC3ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class SysAdminC3ScreenBody extends StatefulWidget {
  const SysAdminC3ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<SysAdminC3ScreenBody> createState() => _SysAdminC3ScreenBodyState();
}

class _SysAdminC3ScreenBodyState extends State<SysAdminC3ScreenBody> {
  TextEditingController userNameTextController = TextEditingController();
  TextEditingController userMobTextController = TextEditingController();
  TextEditingController userDeptTextController = TextEditingController();
  TextEditingController apexTextController = TextEditingController();
  TextEditingController userDesgTextController = TextEditingController();
  TextEditingController userDropDownTextController = TextEditingController();
  TextEditingController modDropDownTextController = TextEditingController();
  TextEditingController menuDropDownTextController = TextEditingController();
  late UserInfoModel loggedUser;

  GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  @override
  void initState() {
    context.read<QrUserBloc>().add(GetQrUsers());
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    super.initState();
  }

  @override
  void dispose() {
    userNameTextController.dispose();
    userMobTextController.dispose();
    userDeptTextController.dispose();
    userDesgTextController.dispose();
    apexTextController.dispose();
    userDropDownTextController.dispose();
    modDropDownTextController.dispose();
    menuDropDownTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName), //User Permission
      body: BlocListener<QrUserMenuPermissionBloc, QrUserMenuPermissionState>(
        listener: (context, state) {
          if (state is QrUserMenuPermissionSuccess) {
            context.read<VariableStateHandlerCubit<QrUserData>>().reset();

            context.read<VariableStateHandlerCubit<QrUserChildMenu>>().reset();
            userNameTextController.clear();
            userMobTextController.clear();
            userDeptTextController.clear();
            userDesgTextController.clear();
            userDropDownTextController.clear();
            modDropDownTextController.clear();
            menuDropDownTextController.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.successSnackber(
                message: "Permission Given..!",
              ),
            );

            context.read<UserMenuBloc>().add(
                  UserMenuGet(
                    userId: loggedUser.userId,
                  ),
                );
          }
          if (state is QrUserMenuPermissionError) {
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
          child: Form(
            key: fromKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<QrUserBloc, QrUserState>(
                  builder: (context, state) {
                    return CommonDropDownMenuWidget<QrUserData>(
                      hintText: "Select User",
                      dropdownMenuEntries:
                          state is QrUserSuccess ? state.qrUsers : [],
                      enabled: state is QrUserSuccess
                          ? state.qrUsers.isNotEmpty
                          : false,
                      controller: userDropDownTextController,
                      onSelected: (value) {
                        // FocusScope.of(context).unfocus();
                        FocusManager.instance.primaryFocus?.unfocus();
                        context
                            .read<VariableStateHandlerCubit<QrUserData>>()
                            .update(value!);

                        userNameTextController.text = value.userName ?? "";
                        userMobTextController.text = "";
                        userDeptTextController.text = "";
                        userDesgTextController.text = "";
                        context.read<QrUserMenuBloc>().add(
                              GetQrUserMenu(
                                newUserId: value.userId!,
                                creatorId: loggedUser.userId,
                              ),
                            );
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<VariableStateHandlerCubit<QrUserData>, QrUserData?>(
                  builder: (context, state) {
                    if (state != null) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CommonTextFieldWidget(
                                  enabled: false,
                                  controller: userNameTextController,
                                  keyboardType: TextInputType.text,
                                  readOnly: true,
                                  labelText: "User Name",
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: CommonTextFieldWidget(
                                  enabled: false,
                                  controller: userMobTextController,
                                  keyboardType: TextInputType.text,
                                  readOnly: true,
                                  labelText: "User Mobile",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CommonTextFieldWidget(
                                  enabled: false,
                                  controller: userDeptTextController,
                                  keyboardType: TextInputType.text,
                                  readOnly: true,
                                  labelText: "User Dept",
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: CommonTextFieldWidget(
                                  enabled: false,
                                  controller: userDesgTextController,
                                  keyboardType: TextInputType.text,
                                  readOnly: true,
                                  labelText: "User Desg",
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<QrUserMenuBloc, QrUserMenuState>(
                        builder: (context, state) {
                          return CommonDropDownMenuWidget<QrModuleData>(
                            hintText: "Select Module",
                            dropdownMenuEntries: state is QrUserMenuSuccess
                                ? state.qrUserMenu
                                : [],
                            controller: modDropDownTextController,
                            enabled: state is QrUserMenuSuccess
                                ? state.qrUserMenu.isNotEmpty
                                : false,
                            onSelected: (value) {
                              // FocusScope.of(context).unfocus();
                              FocusManager.instance.primaryFocus?.unfocus();
                              var selectedUser = context
                                  .read<VariableStateHandlerCubit<QrUserData>>()
                                  .state!;

                              context.read<QrUserChildMenuBloc>().add(
                                    GetQrUserChildMenu(
                                      newUserId: selectedUser.userId!,
                                      creatorId: loggedUser.userId,
                                      routeName: value?.moduleName ?? "",
                                    ),
                                  );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: BlocBuilder<QrUserChildMenuBloc,
                          QrUserChildMenuState>(
                        builder: (context, state) {
                          return CommonDropDownMenuWidget<QrUserChildMenu>(
                            hintText: "Select Menu",
                            dropdownMenuEntries: state is QrUserChildMenuSuccess
                                ? state.qrUserChildMenu
                                : [],
                            controller: menuDropDownTextController,
                            enabled: state is QrUserChildMenuSuccess
                                ? state.qrUserChildMenu.isNotEmpty
                                : false,
                            onSelected: (value) {
                              if (value != null) {
                                // FocusScope.of(context).unfocus();
                                FocusManager.instance.primaryFocus?.unfocus();
                                context
                                    .read<
                                        VariableStateHandlerCubit<
                                            QrUserChildMenu>>()
                                    .update(value);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BlocBuilder<QrUserMenuPermissionBloc,
                        QrUserMenuPermissionState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            if (fromKey.currentState!.validate()) {
                              var selectedUser = context
                                  .read<VariableStateHandlerCubit<QrUserData>>()
                                  .state;

                              var selectedChildMenu = context
                                  .read<
                                      VariableStateHandlerCubit<
                                          QrUserChildMenu>>()
                                  .state;

                              if (selectedUser == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackBar.errorSnackber(
                                    message: "Please Select User",
                                  ),
                                );
                                return;
                              }
                              if (selectedChildMenu == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackBar.errorSnackber(
                                    message: "Please Select Menu",
                                  ),
                                );
                                return;
                              }
                              context.read<QrUserMenuPermissionBloc>().add(
                                    GetQrUserMenuPermission(
                                      userId: loggedUser.userId,
                                      newUserId: selectedUser.userId!,
                                      menuId:
                                          selectedChildMenu.menuId.toString(),
                                    ),
                                  );
                            }
                          },
                          child: Text(
                            state is QrUserMenuPermissionLoading
                                ? "Saving..."
                                : "Save",
                            style: textTheme.bodyMedium!.copyWith(
                              color: appTheme.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const UserDetailsWidget(),
    );
  }
}
