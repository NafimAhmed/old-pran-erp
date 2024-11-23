import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/sys_menu_parent_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/system_module_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_lable_wth_textfield.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_1_screen/bloc/system_menu_create_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_1_screen/bloc/system_menu_parent_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_1_screen/bloc/system_module_bloc.dart';

class SysAdminC1Screen extends StatelessWidget {
  const SysAdminC1Screen({super.key, required this.fromName});
  static const String routeName = "SYSTEM-ADMINISTRATOR-C-1-SCREEN";
  static const String routePath = "/SYSTEM-ADMINISTRATOR-C-1-SCREEN";
  final String fromName;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SystemModuleBloc(getService()),
        ),
        BlocProvider(
          create: (context) => SystemMenuPrntBloc(getService()),
        ),
        BlocProvider(
          create: (context) => SysMenuCreateBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<SysModuleData>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<SysMenuparentData>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<MenuType>(),
        ),
      ],
      child: SysAdminC1ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

enum MenuType {
  parent("P"),
  child("C");

  const MenuType(this.value);

  final String value;
  @override
  String toString() {
    return name;
  }
}

class SysAdminC1ScreenBody extends StatefulWidget {
  const SysAdminC1ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<SysAdminC1ScreenBody> createState() => _SysAdminC1ScreenBodyState();
}

class _SysAdminC1ScreenBodyState extends State<SysAdminC1ScreenBody> {
  TextEditingController menuNameTextController = TextEditingController();
  FocusNode menuNameFocusNode = FocusNode();
  late UserInfoModel loggedUser;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context.read<SystemModuleBloc>().add(
          GetSystemModule(
            userId: loggedUser.userId,
          ),
        );
    super.initState();
  }

  @override
  void dispose() {
    menuNameTextController.dispose();
    menuNameFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SysMenuCreateBloc, SysMenuCreateState>(
            listener: (context, state) {
              if (state is SysMenuCreateError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar.errorSnackber(
                    message: state.error.toString(),
                  ),
                );
              }
              if (state is SysMenuCreateSuccess) {
                context
                    .read<VariableStateHandlerCubit<SysModuleData>>()
                    .reset();
                context.read<VariableStateHandlerCubit<MenuType>>().reset();
                context
                    .read<VariableStateHandlerCubit<SysMenuparentData>>()
                    .reset();
                context.read<SystemMenuPrntBloc>().add(ResetSystemMenuPrnt());
                menuNameTextController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar.successSnackber(
                    message: "Successfully Created..!",
                  ),
                );
              }
            },
          ),
          BlocListener<SystemMenuPrntBloc, SystemMenuPrntState>(
            listener: (context, state) {
              if (state is SystemMenuPrntError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar.errorSnackber(
                    message: state.error.toString(),
                  ),
                );
              }
            },
          ),
          BlocListener<SystemModuleBloc, SystemModuleState>(
            listener: (context, state) {
              if (state is SystemModuleError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar.errorSnackber(
                    message: state.error.toString(),
                  ),
                );
              }
            },
          ),
        ],
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
                    BlocBuilder<SystemModuleBloc, SystemModuleState>(
                      builder: (context, state) {
                        return CommonDropdownButton<SysModuleData>(
                          hintText: "Select Module",
                          value: context
                              .watch<VariableStateHandlerCubit<SysModuleData>>()
                              .state,
                          items: state is SystemModuleSuccess
                              ? state.sysModuleDataList
                              : [],
                          onChanged: (value) {
                            context
                                .read<
                                    VariableStateHandlerCubit<SysModuleData>>()
                                .update(value!);

                            context
                                .read<
                                    VariableStateHandlerCubit<
                                        SysMenuparentData>>()
                                .reset();
                            context
                                .read<VariableStateHandlerCubit<MenuType>>()
                                .reset();
                            context.read<SystemMenuPrntBloc>().add(
                                  ResetSystemMenuPrnt(),
                                );
                            // var selectedMenuType = context
                            //     .read<VariableStateHandlerCubit<MenuType>>()
                            //     .state;
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Please Select Module";
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CommonDropdownButton<MenuType>(
                            hintText: "Select Menu Type",
                            value: context
                                .watch<VariableStateHandlerCubit<MenuType>>()
                                .state,
                            items: MenuType.values,
                            onChanged: (value) {
                              context
                                  .read<VariableStateHandlerCubit<MenuType>>()
                                  .update(value!);

                              if (value == MenuType.child) {
                                context
                                    .read<
                                        VariableStateHandlerCubit<
                                            SysMenuparentData>>()
                                    .reset();
                                var selectedMod = context
                                    .read<
                                        VariableStateHandlerCubit<
                                            SysModuleData>>()
                                    .state!;
                                context.read<SystemMenuPrntBloc>().add(
                                      GetSystemMenuPrnt(
                                        userId: loggedUser.userId,
                                        moduleName:
                                            selectedMod.moduleName ?? "",
                                      ),
                                    );
                              } else {
                                context
                                    .read<
                                        VariableStateHandlerCubit<
                                            SysMenuparentData>>()
                                    .reset();
                                context.read<SystemMenuPrntBloc>().add(
                                      ResetSystemMenuPrnt(),
                                    );
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Please Select Menu Type";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: BlocBuilder<SystemMenuPrntBloc,
                              SystemMenuPrntState>(
                            builder: (context, state) {
                              return CommonDropdownButton<SysMenuparentData>(
                                hintText: "Select Parent Menu",
                                value: context
                                    .watch<
                                        VariableStateHandlerCubit<
                                            SysMenuparentData>>()
                                    .state,
                                items: state is SystemMenuPrntSuccess
                                    ? state.sysMenuPrntDataList
                                    : [],
                                onChanged: (value) {
                                  context
                                      .read<
                                          VariableStateHandlerCubit<
                                              SysMenuparentData>>()
                                      .update(value!);
                                },
                                // validator: (value) {
                                //   if (value == null) {
                                //     return "Please Select Parent Module";
                                //   }
                                //   return null;
                                // },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CommonLableWthTextField(
                      lableName: "Menu Name",
                      focusNode: menuNameFocusNode,
                      textController: menuNameTextController,
                      onChanged: (value) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Menu Name";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<SysMenuCreateBloc, SysMenuCreateState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is SysMenuCreateLoading
                        ? () {}
                        : () {
                            if (formKey.currentState!.validate()) {
                              var selectedMenuType = context
                                  .read<VariableStateHandlerCubit<MenuType>>()
                                  .state!;
                              var selectedMod = context
                                  .read<
                                      VariableStateHandlerCubit<
                                          SysModuleData>>()
                                  .state!;
                              var selectedPmenu = context
                                  .read<
                                      VariableStateHandlerCubit<
                                          SysMenuparentData>>()
                                  .state;
                              context.read<SysMenuCreateBloc>().add(
                                    CreateSysMenu(
                                      userId: loggedUser.userId,
                                      pMenuName: menuNameTextController.text,
                                      pMenuType: selectedMenuType.value,
                                      pModule: selectedMod.moduleName ?? "",
                                      pParent:
                                          selectedPmenu?.parentId.toString(),
                                    ),
                                  );
                            }
                          },
                    child: Text(
                      state is SysMenuCreateLoading ? "Saving..." : "Save",
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
      bottomNavigationBar: const UserDetailsWidget(),
    );
  }
}
