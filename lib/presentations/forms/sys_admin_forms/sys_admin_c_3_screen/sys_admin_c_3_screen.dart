import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/entities/qr_user_menu_response.dart';
import 'package:pran_rfl_erp/app_data/entities/qr_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_3_screen/bloc/qr_user_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_3_screen/bloc/qr_user_child_menu_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_3_screen/bloc/qr_user_menu_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_3_screen/bloc/qr_user_permission_bloc.dart';

class SysAdminC3Screen extends StatelessWidget {
  const SysAdminC3Screen({super.key});
  static const String routeName = "SYSTEM-ADMINISTRATOR-C-3-SCREEN";
  static const String routePath = "/SYSTEM-ADMINISTRATOR-C-3-SCREEN";
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
          create: (context) => VariableStateHandlerCubit<QrUserMenu>(),
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
      child: const SysAdminC3ScreenBody(),
    );
  }
}

class SysAdminC3ScreenBody extends StatefulWidget {
  const SysAdminC3ScreenBody({super.key});

  @override
  State<SysAdminC3ScreenBody> createState() => _SysAdminC3ScreenBodyState();
}

class _SysAdminC3ScreenBodyState extends State<SysAdminC3ScreenBody> {
  TextEditingController userNameTextController = TextEditingController();
  TextEditingController userMobTextController = TextEditingController();
  TextEditingController userDeptTextController = TextEditingController();
  TextEditingController userDesgTextController = TextEditingController();

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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "User Permission"),
      body: BlocListener<QrUserMenuPermissionBloc, QrUserMenuPermissionState>(
        listener: (context, state) {
          if (state is QrUserMenuPermissionSuccess) {
            context.read<VariableStateHandlerCubit<QrUserData>>().reset();
            context.read<VariableStateHandlerCubit<QrUserMenu>>().reset();
            context.read<VariableStateHandlerCubit<QrUserChildMenu>>().reset();
            userNameTextController.clear();
            userMobTextController.clear();
            userDeptTextController.clear();
            userDesgTextController.clear();

            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.successSnackber(
                message: "Permission Given..!",
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
                    return CommonDropdownButton<QrUserData>(
                      hintText: "Select User",
                      items: state is QrUserSuccess ? state.qrUsers : [],
                      value: context
                          .watch<VariableStateHandlerCubit<QrUserData>>()
                          .state,
                      onChanged: (value) {
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
                      validator: (value) {
                        if (value == null) {
                          return "Please Select Apps User";
                        }
                        return null;
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
                          return CommonDropdownButton<QrUserMenu>(
                            hintText: "Select Menu",
                            items: state is QrUserMenuSuccess
                                ? state.qrUserMenu
                                : [],
                            onChanged: (value) {
                              var selectedUser = context
                                  .read<VariableStateHandlerCubit<QrUserData>>()
                                  .state!;
                              context
                                  .read<VariableStateHandlerCubit<QrUserMenu>>()
                                  .update(value!);
                              context.read<QrUserChildMenuBloc>().add(
                                    GetQrUserChildMenu(
                                      newUserId: selectedUser.userId!,
                                      creatorId: loggedUser.userId,
                                      routeName: value.menuRoute ?? "",
                                    ),
                                  );
                            },
                            value: context
                                .watch<VariableStateHandlerCubit<QrUserMenu>>()
                                .state,
                            validator: (value) {
                              if (value == null) {
                                return "Please Select Menu";
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
                      child: BlocBuilder<QrUserChildMenuBloc,
                          QrUserChildMenuState>(
                        builder: (context, state) {
                          return CommonDropdownButton<QrUserChildMenu>(
                            hintText: "Select Menu",
                            items: state is QrUserChildMenuSuccess
                                ? state.qrUserChildMenu
                                : [],
                            onChanged: (value) {
                              context
                                  .read<
                                      VariableStateHandlerCubit<
                                          QrUserChildMenu>>()
                                  .update(value!);
                            },
                            value: context
                                .watch<
                                    VariableStateHandlerCubit<
                                        QrUserChildMenu>>()
                                .state,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<QrUserMenuPermissionBloc,
                    QrUserMenuPermissionState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        if (fromKey.currentState!.validate()) {
                          var selectedUser = context
                              .read<VariableStateHandlerCubit<QrUserData>>()
                              .state!;
                          var selectedMenu = context
                              .read<VariableStateHandlerCubit<QrUserMenu>>()
                              .state!;
                          var selectedChildMenu = context
                              .read<
                                  VariableStateHandlerCubit<QrUserChildMenu>>()
                              .state;
                          context.read<QrUserMenuPermissionBloc>().add(
                                GetQrUserMenuPermission(
                                  userId: loggedUser.userId,
                                  newUserId: selectedUser.userId!,
                                  menuId: selectedChildMenu == null
                                      ? selectedMenu.menuId.toString()
                                      : selectedChildMenu.menuId.toString(),
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
          ),
        ),
      ),
    );
  }
}
