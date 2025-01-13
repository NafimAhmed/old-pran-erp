import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/machine_create_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_drop_down_menu_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_lable_wth_textfield.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';

import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_6_screen/bloc/machine_assign_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_6_screen/bloc/machine_create_bloc.dart';

class SysAdminC6Screen extends StatelessWidget {
  const SysAdminC6Screen({super.key, required this.fromName});
  static const String routeName = "SYSTEM-ADMINISTRATOR-C-6-SCREEN";
  static const String routePath = "/SYSTEM-ADMINISTRATOR-C-6-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MachineAssignBloc(getService()),
        ),
        BlocProvider(
          create: (context) => MachineCreateBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<MachineInfo>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<UserOrg>(),
        ),
      ],
      child: SysAdminC6ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class SysAdminC6ScreenBody extends StatefulWidget {
  const SysAdminC6ScreenBody(
      {super.key, required this.fromName}); //Machine Create
  final String fromName;
  @override
  State<SysAdminC6ScreenBody> createState() => _SysAdminC6ScreenBodyState();
}

class _SysAdminC6ScreenBodyState extends State<SysAdminC6ScreenBody> {
  late UserInfoModel loggedUser;
  final TextEditingController machineTextControler = TextEditingController();
  final FocusNode machinefocusNode = FocusNode();

  final TextEditingController dropDownControler = TextEditingController();
  final TextEditingController dropDown2Controler = TextEditingController();
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  GlobalKey<FormState> fromKey2 = GlobalKey<FormState>();
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context.read<MachineCreateBloc>().add(
          CreateMachine(
            machinename: "XXXXXX",
            userId: loggedUser.userId,
          ),
        );
    super.initState();
  }

  @override
  void dispose() {
    machineTextControler.dispose();
    machinefocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName), //Machine Create
      body: MultiBlocListener(
        listeners: [
          BlocListener<MachineCreateBloc, MachineCreateState>(
            listener: (context, state) {
              if (state is MachineCreateSuccess) {
                if (state.type != "XXXXXX") {
                  machineTextControler.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackBar.successSnackber(
                      message: "Created Successfully",
                    ),
                  );
                }
              }
            },
          ),
          BlocListener<MachineAssignBloc, MachineAssignState>(
            listener: (context, state) {
              if (state is MachineAssignSuccess) {
                dropDownControler.clear();
                dropDown2Controler.clear();
                context.read<VariableStateHandlerCubit<UserOrg>>().reset();
                context.read<VariableStateHandlerCubit<MachineInfo>>().reset();
                ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar.successSnackber(
                    message: "Assigned Successfully",
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
              Form(
                key: fromKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CommonLableWthTextField(
                      focusNode: machinefocusNode,
                      textController: machineTextControler,
                      lableName: "Machine Name",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocSelector<MachineCreateBloc, MachineCreateState, String>(
                      selector: (state) {
                        if (state is MachineCreateLoading) {
                          if (state.type != "XXXXXX") {
                            return "Creating...";
                          } else {
                            return "Create";
                          }
                        }
                        return "Create";
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            if (fromKey.currentState!.validate()) {
                              context.read<MachineCreateBloc>().add(
                                    CreateMachine(
                                      machinename: machineTextControler.text,
                                      userId: loggedUser.userId,
                                    ),
                                  );
                            }
                          },
                          child: Text(
                            state,
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
              const SizedBox(
                height: 10,
              ),
              Divider(
                color: appTheme.primary,
                indent: 0,
                endIndent: 0,
              ),
              Text(
                "Assign Machine To Org",
                style: textTheme.bodyMedium!.copyWith(
                  color: appTheme.primary,
                ),
              ),
              Form(
                key: fromKey2,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<MachineCreateBloc, MachineCreateState>(
                      builder: (context, state) {
                        return CommonDropDownMenuWidget<MachineInfo>(
                          hintText: "Select Machine",
                          controller: dropDownControler,
                          enabled: state is MachineCreateSuccess
                              ? state.machineInfoList.isNotEmpty
                              : false,
                          dropdownMenuEntries: state is MachineCreateSuccess
                              ? state.machineInfoList
                              : [],
                          onSelected: (value) {
                            if (value != null) {
                              // FocusScope.of(context).unfocus();
                              FocusManager.instance.primaryFocus?.unfocus();
                              context
                                  .read<
                                      VariableStateHandlerCubit<MachineInfo>>()
                                  .update(value);
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<MachineCreateBloc, MachineCreateState>(
                      builder: (context, state) {
                        return CommonDropDownMenuWidget<UserOrg>(
                          hintText: "Select Org",
                          controller: dropDown2Controler,
                          enabled: state is MachineCreateSuccess
                              ? state.orgInfoList.isNotEmpty
                              : false,
                          dropdownMenuEntries: state is MachineCreateSuccess
                              ? state.orgInfoList
                              : [],
                          onSelected: (value) {
                            if (value != null) {
                              // FocusScope.of(context).unfocus();
                              FocusManager.instance.primaryFocus?.unfocus();
                              context
                                  .read<VariableStateHandlerCubit<UserOrg>>()
                                  .update(value);
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<MachineAssignBloc, MachineAssignState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            var selectedMachine = context
                                .read<VariableStateHandlerCubit<MachineInfo>>()
                                .state;
                            var selectedOrg = context
                                .read<VariableStateHandlerCubit<UserOrg>>()
                                .state;
                            if (selectedOrg != null &&
                                selectedMachine != null) {
                              context.read<MachineAssignBloc>().add(
                                    AsignMachine(
                                      machinename: selectedMachine.machineName!,
                                      userId: loggedUser.userId,
                                      orgId:
                                          selectedOrg.organizationId.toString(),
                                    ),
                                  );
                            }
                          },
                          child: Text(
                            state is MachineAssignLoading
                                ? "Assigning..."
                                : "Assign",
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
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: BlocBuilder<MachineAssignBloc, MachineAssignState>(
                  builder: (context, state) {
                    if (state is MachineAssignSuccess) {
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
                                      "Org Code",
                                      style: textTheme.bodyMedium!,
                                    ),
                                    Text(
                                      state.orgMachineInfoList[index].orgCode ??
                                          "",
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
                                      "Machine Name",
                                      style: textTheme.bodyMedium!,
                                    ),
                                    Text(
                                      state.orgMachineInfoList[index]
                                              .machineName ??
                                          "",
                                      style: textTheme.bodySmall!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemCount: state.orgMachineInfoList.length,
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
