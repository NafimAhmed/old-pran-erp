import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/sub_inv_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_drop_down_menu_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_7_screen/bloc/locator_create_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_7_screen/bloc/org_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_7_screen/bloc/sub_inv_bloc.dart';

class InvC3Screen extends StatelessWidget {
  const InvC3Screen({super.key, required this.fromName});
  static const String routeName = "INV-C-3-SCREEN";
  static const String routePath = "/INV-C-3-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OrgBloc(getService()),
        ),
        BlocProvider(
          create: (context) => SubInvBloc(getService()),
        ),
        BlocProvider(
          create: (context) => LocatorBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<UserOrg>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<SubInvData>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<List<String>>()
            ..update(List<String>.filled(4, "")),
        ),
      ],
      child: InvC3ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class InvC3ScreenBody extends StatefulWidget {
  const InvC3ScreenBody({super.key, required this.fromName}); //Locator Create
  final String fromName;
  @override
  State<InvC3ScreenBody> createState() => _InvC3ScreenBodyState();
}

class _InvC3ScreenBodyState extends State<InvC3ScreenBody> {
  late UserInfoModel loggedUser;
  final TextEditingController orgController = TextEditingController();
  final TextEditingController subInvController = TextEditingController();
  final TextEditingController rowController = TextEditingController();
  final TextEditingController rackController = TextEditingController();
  final TextEditingController beenController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final FocusNode rowFocusNode = FocusNode();
  final FocusNode rackFocusNode = FocusNode();
  final FocusNode beenFocusNode = FocusNode();
  final FocusNode descFocusNode = FocusNode();
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;
    context.read<OrgBloc>().add(OrgGet());
    super.initState();
  }

  @override
  void dispose() {
    orgController.dispose();
    subInvController.dispose();
    rowController.dispose();
    rackController.dispose();
    beenController.dispose();
    descController.dispose();
    rowFocusNode.dispose();
    rackFocusNode.dispose();
    beenFocusNode.dispose();
    descFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName), //Locator Create
      body: BlocListener<LocatorBloc, LocatorState>(
        listener: (context, state) {
          if (state is LocatorSuccess) {
            context.read<VariableStateHandlerCubit<UserOrg>>().reset();
            context.read<VariableStateHandlerCubit<SubInvData>>().reset();
            context
                .read<VariableStateHandlerCubit<List<String>>>()
                .update(List<String>.filled(4, ""));
            orgController.clear();
            subInvController.clear();
            rowController.clear();
            rackController.clear();
            beenController.clear();
            descController.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.successSnackber(
                message: "Created Successfully",
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: fromKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<OrgBloc, OrgState>(
                  builder: (context, state) {
                    return CommonDropDownMenuWidget<UserOrg>(
                      hintText: "Select Org",
                      controller: orgController,
                      enabled: state is OrgSuccess
                          ? state.userOrgList.isNotEmpty
                          : false,
                      dropdownMenuEntries:
                          state is OrgSuccess ? state.userOrgList : [],
                      onSelected: (value) {
                        if (value != null) {
                          // FocusScope.of(context).unfocus();
                          FocusManager.instance.primaryFocus?.unfocus();
                          context
                              .read<VariableStateHandlerCubit<UserOrg>>()
                              .update(value);
                          context
                              .read<VariableStateHandlerCubit<SubInvData>>()
                              .reset();
                          subInvController.clear();
                          context.read<SubInvBloc>().add(
                                SubInvGet(
                                  orgId: value.organizationId.toString(),
                                ),
                              );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<SubInvBloc, SubInvState>(
                  builder: (context, state) {
                    return CommonDropDownMenuWidget<SubInvData>(
                      hintText: "Select Sub Inv",
                      controller: subInvController,
                      enabled: state is SubInvSuccess
                          ? state.subInvList.isNotEmpty
                          : false,
                      dropdownMenuEntries:
                          state is SubInvSuccess ? state.subInvList : [],
                      onSelected: (value) {
                        if (value != null) {
                          context
                              .read<VariableStateHandlerCubit<SubInvData>>()
                              .update(value);
                          var list = context
                              .read<VariableStateHandlerCubit<List<String>>>()
                              .state!;
                          list[0] = "${value.secondaryInventoryName}.";
                          context
                              .read<VariableStateHandlerCubit<List<String>>>()
                              .update(list);
                          var list2 = context
                              .read<VariableStateHandlerCubit<List<String>>>()
                              .state!;
                          descController.clear();
                          descController.text = list2.join();
                        }
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
                      child: CommonTextFieldWidget(
                        labelText: "Row",
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        focusNode: rowFocusNode,
                        controller: rowController,
                        onChanged: (value) {
                          var list = context
                              .read<VariableStateHandlerCubit<List<String>>>()
                              .state!;
                          list[1] = "$value.";
                          context
                              .read<VariableStateHandlerCubit<List<String>>>()
                              .update(list);
                          var list2 = context
                              .read<VariableStateHandlerCubit<List<String>>>()
                              .state!;
                          descController.clear();
                          descController.text = list2.join();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Row";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CommonTextFieldWidget(
                        labelText: "Rack",
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        focusNode: rackFocusNode,
                        controller: rackController,
                        onChanged: (value) {
                          var list = context
                              .read<VariableStateHandlerCubit<List<String>>>()
                              .state!;
                          list[2] = "$value.";
                          context
                              .read<VariableStateHandlerCubit<List<String>>>()
                              .update(list);
                          var list2 = context
                              .read<VariableStateHandlerCubit<List<String>>>()
                              .state!;
                          descController.clear();
                          descController.text = list2.join();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Rack";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                CommonTextFieldWidget(
                  labelText: "Been",
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  focusNode: beenFocusNode,
                  controller: beenController,
                  onChanged: (value) {
                    var list = context
                        .read<VariableStateHandlerCubit<List<String>>>()
                        .state!;
                    list[3] = value;
                    context
                        .read<VariableStateHandlerCubit<List<String>>>()
                        .update(list);
                    var list2 = context
                        .read<VariableStateHandlerCubit<List<String>>>()
                        .state!;
                    descController.clear();
                    descController.text = list2.join();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Been";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CommonTextFieldWidget(
                  readOnly: true,
                  labelText: "Description",
                  keyboardType: TextInputType.text,
                  focusNode: descFocusNode,
                  controller: descController,
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<LocatorBloc, LocatorState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        if (fromKey.currentState!.validate()) {
                          var selectedSubInv = context
                              .read<VariableStateHandlerCubit<SubInvData>>()
                              .state;
                          var selectedOrg = context
                              .read<VariableStateHandlerCubit<UserOrg>>()
                              .state;
                          if (selectedOrg == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBar.errorSnackber(
                                message: "Please Select Org",
                              ),
                            );
                            return;
                          }
                          if (selectedSubInv == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBar.errorSnackber(
                                message: "Please Select SubInv",
                              ),
                            );
                            return;
                          }
                          context.read<LocatorBloc>().add(
                                CreateLocator(
                                  userId: loggedUser.userId,
                                  orgId: selectedOrg.organizationId.toString(),
                                  pSubInv:
                                      selectedSubInv.secondaryInventoryName ??
                                          "",
                                  pRow: rowController.text,
                                  pRack: rackController.text,
                                  pBeen: beenController.text,
                                  pDesc: descController.text,
                                ),
                              );
                        }
                      },
                      child: Text(
                        state is LocatorLoading ? "Creating..." : "Create",
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
      bottomNavigationBar: const UserDetailsWidget(),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
