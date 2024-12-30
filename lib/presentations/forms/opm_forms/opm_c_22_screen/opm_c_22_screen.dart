import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/chat_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_basic_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_drop_down_menu_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/user_org_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_21_screen/bloc/chat_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/bloc/user_basic_data_bloc.dart';

class OpmC22Screen extends StatelessWidget {
  const OpmC22Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-22-SCREEN";
  static const String routePath = "/OPM-C-22-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatBloc(getService()),
        ),
        BlocProvider(
          create: (context) => UserBasicDataBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<UserOrg>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<UserMachine>(),
        ),
      ],
      child: OpmC22ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class OpmC22ScreenBody extends StatefulWidget {
  const OpmC22ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OpmC22ScreenBody> createState() => _OpmC22ScreenBodyState();
}

class _OpmC22ScreenBodyState extends State<OpmC22ScreenBody> {
  late UserInfoModel loggedUser;
  late TextEditingController orgDropDownTextController;
  late TextEditingController shiftDropDownTextController;
  late TextEditingController hourDropDownTextController;
  late TextEditingController lotNoController;
  late TextEditingController machineDropDownTextController;
  late FocusNode lotNoFocusNode;
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    orgDropDownTextController = TextEditingController();
    lotNoController = TextEditingController();
    machineDropDownTextController = TextEditingController();
    shiftDropDownTextController = TextEditingController();
    hourDropDownTextController = TextEditingController();

    lotNoFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    machineDropDownTextController.dispose();
    orgDropDownTextController.dispose();
    lotNoController.dispose();
    shiftDropDownTextController.dispose();
    hourDropDownTextController.dispose();
    lotNoFocusNode.dispose();
    super.dispose();
  }

  List<GptInfo> conversation = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<UserOrgBloc, UserOrgState>(
              builder: (context, state) {
                return CommonDropDownMenuWidget<UserOrg>(
                  hintText: "Select Org",
                  enabled: state is UserOrgSuccess
                      ? state.userOrg.isNotEmpty
                      : false,
                  controller: orgDropDownTextController,
                  dropdownMenuEntries:
                      state is UserOrgSuccess ? state.userOrg : [],
                  onSelected: (value) {
                    if (value != null) {
                      context
                          .read<VariableStateHandlerCubit<UserOrg>>()
                          .update(value);
                      context.read<UserBasicDataBloc>().add(
                            UserBasicDataGet(
                              userId: loggedUser.userId,
                              orgid: value.organizationId!.toString(),
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
            Form(
              key: fromKey,
              child: Row(
                children: [
                  Expanded(
                    child: CommonTextFieldWidget(
                      controller: lotNoController,
                      focusNode: lotNoFocusNode,
                      labelText: "Batch No",
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Lot No";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (fromKey.currentState!.validate()) {}
                    },
                    child: Text(
                      "Find Batch",
                      style: textTheme.bodyMedium!.copyWith(
                        color: appTheme.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              color: appTheme.primary.withOpacity(0.2),
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Item Name",
                    style: textTheme.bodyMedium!.copyWith(),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Lot No",
                        style: textTheme.bodyMedium!.copyWith(),
                      ),
                      Text(
                        "123456",
                        style: textTheme.bodyMedium!.copyWith(),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Shift",
                              style: textTheme.bodyMedium!.copyWith(),
                            ),
                            Text(
                              "A",
                              style: textTheme.bodyMedium!.copyWith(),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Hour",
                              style: textTheme.bodyMedium!.copyWith(),
                            ),
                            Text(
                              "10",
                              style: textTheme.bodyMedium!.copyWith(),
                            )
                          ],
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
                        child: CommonDropDownMenuWidget<String>(
                          hintText: "Change Org",
                          // enabled: state is UserOrgSuccess
                          //     ? state.userOrg.isNotEmpty
                          //     : false,
                          controller: shiftDropDownTextController,
                          dropdownMenuEntries: [],
                          onSelected: (value) {
                            if (value != null) {
                              // context
                              //     .read<VariableStateHandlerCubit<UserOrg>>()
                              //     .update(value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: CommonDropDownMenuWidget<String>(
                          hintText: "Change Hour",
                          // enabled: state is UserOrgSuccess
                          //     ? state.userOrg.isNotEmpty
                          //     : false,
                          controller: hourDropDownTextController,
                          dropdownMenuEntries: [],
                          onSelected: (value) {
                            if (value != null) {
                              // context
                              //     .read<VariableStateHandlerCubit<UserOrg>>()
                              //     .update(value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<UserBasicDataBloc, UserBasicDataState>(
                    builder: (context, state) {
                      return CommonDropDownMenuWidget<UserMachine>(
                        enabled: state is UserBasicDataSuccess
                            ? state.userBasicData.userMachineData?.isNotEmpty ??
                                false
                            : false,
                        hintText: "Select Machine",
                        controller: machineDropDownTextController,
                        dropdownMenuEntries: state is UserBasicDataSuccess
                            ? state.userBasicData.userMachineData ?? []
                            : [],
                        onSelected: (value) {
                          context
                              .read<VariableStateHandlerCubit<UserMachine>>()
                              .update(value!);
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
