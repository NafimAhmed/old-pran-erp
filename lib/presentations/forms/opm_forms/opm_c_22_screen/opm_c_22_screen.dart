import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/chat_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/prod_basic_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/shift_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/prod_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_drop_down_menu_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/shift_data_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/user_org_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_21_screen/bloc/chat_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_22_screen/bloc/batch_shift_change_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_22_screen/bloc/batch_shift_change_data_bloc.dart';

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
          create: (context) => BatchShiftChangeDataBloc(getService()),
        ),
        BlocProvider(
          create: (context) => ShiftDataBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<UserMachine>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<UserOrg>(),
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
  late TextEditingController hrTextController;
  late TextEditingController batchNoController;
  late TextEditingController machineDropDownTextController;
  late FocusNode lotNoFocusNode;

  GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;
    orgDropDownTextController = TextEditingController();
    batchNoController = TextEditingController();
    machineDropDownTextController = TextEditingController();
    shiftDropDownTextController = TextEditingController();
    hrTextController = TextEditingController();

    lotNoFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    machineDropDownTextController.dispose();
    orgDropDownTextController.dispose();
    batchNoController.dispose();
    shiftDropDownTextController.dispose();
    hrTextController.dispose();
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
            Form(
              key: fromKey,
              child: Row(
                children: [
                  Expanded(
                    child: CommonTextFieldWidget(
                      controller: batchNoController,
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
                  context.watch<VariableStateHandlerCubit<UserOrg>>().state !=
                          null
                      ? Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (fromKey.currentState!.validate()) {
                                  var selectedOrg = context
                                      .read<
                                          VariableStateHandlerCubit<UserOrg>>()
                                      .state!;
                                  context.read<BatchShiftChangeDataBloc>().add(
                                        GetBatch(
                                          userId: loggedUser.userId,
                                          orgId:
                                              selectedOrg.organizationId ?? 0,
                                          batchNo: batchNoController.text,
                                        ),
                                      );
                                  context
                                      .read<ShiftDataBloc>()
                                      .add(GetShiftData());
                                }
                              },
                              child: Text(
                                "Find Batch",
                                style: textTheme.bodyMedium!.copyWith(
                                  color: appTheme.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            BlocBuilder<BatchShiftChangeDataBloc, BatchShiftChangeDataState>(
              builder: (context, state) {
                if (state is BatchShiftChangeDataLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is BatchShiftChangeDataSuccess) {
                  return Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        var data =
                            state.batchShiftChangedata.shiftBatchData?[index];
                        var machineData =
                            state.batchShiftChangedata.shiftMachineData ?? [];
                        return BatchShiftDataWidget(
                          loggedUser: loggedUser,
                          data: data,
                          machineData: machineData,
                          searchedBatch: batchNoController.text,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount:
                          state.batchShiftChangedata.shiftBatchData?.length ??
                              0,
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BatchShiftDataWidget extends StatefulWidget {
  const BatchShiftDataWidget({
    super.key,
    required this.data,
    required this.machineData,
    required this.loggedUser,
    required this.searchedBatch,
  });

  final UserBatch? data;
  final UserInfoModel loggedUser;
  final List<UserMachine> machineData;
  final String searchedBatch;
  @override
  State<BatchShiftDataWidget> createState() => _BatchShiftDataWidgetState();
}

class _BatchShiftDataWidgetState extends State<BatchShiftDataWidget> {
  final TextEditingController textController = TextEditingController();
  final TextEditingController hrTextController = TextEditingController();
  final FocusNode hrFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BatchShiftChangeBloc(getService()),
        ),
        // BlocProvider(

        //   create: (context) => VariableStateHandlerCubit<UserMachine>(),
        // ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<ShiftData>(),
        ),
      ],
      child: BlocListener<BatchShiftChangeBloc, BatchShiftChangeState>(
        listener: (context, state) {
          if (state is BatchShiftChangeSuccess) {
            var selectedOrg =
                context.read<VariableStateHandlerCubit<UserOrg>>().state!;
            context.read<BatchShiftChangeDataBloc>().add(
                  GetBatch(
                    userId: widget.loggedUser.userId,
                    orgId: selectedOrg.organizationId ?? 0,
                    batchNo: widget.searchedBatch,
                  ),
                );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: appTheme.primary.withOpacity(0.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data?.itemName ?? "",
                style: textTheme.bodyMedium!.copyWith(),
              ),
              Text(
                widget.data?.batchNo ?? "",
                style: textTheme.bodyMedium!.copyWith(),
              ),
              Text(
                widget.data?.lotNo ?? "",
                style: textTheme.bodyMedium!.copyWith(),
              ),
              Text(
                widget.data?.machineName ?? "",
                style: textTheme.bodyMedium!.copyWith(),
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
                          widget.data?.shiftName ?? "",
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
                          "Man Power",
                          style: textTheme.bodyMedium!.copyWith(),
                        ),
                        Text(
                          widget.data?.shiftManPower.toString() ?? "",
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
              CommonDropDownMenuWidget<UserMachine>(
                hintText: "Select Machine",
                controller: textController,
                dropdownMenuEntries: widget.machineData,
                onSelected: (value) {
                  context
                      .read<VariableStateHandlerCubit<UserMachine>>()
                      .update(value!);
                  // FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<ShiftDataBloc, ShiftDataState>(
                      builder: (context, state) {
                        if (state is ShiftDataSuccess) {
                          return CommonDropdownButton<ShiftData>(
                            hintText: "Change Shift",
                            value: context
                                .watch<VariableStateHandlerCubit<ShiftData>>()
                                .state,
                            items: state.shiftList,
                            onChanged: (value) {
                              context
                                  .read<VariableStateHandlerCubit<ShiftData>>()
                                  .update(value!);
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: CommonTextFieldWidget(
                      controller: hrTextController,
                      focusNode: hrFocusNode,
                      labelText: "Change Hr",
                      keyboardType: TextInputType.text,
                      onChanged: (value) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Hour No";
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
              BlocBuilder<BatchShiftChangeBloc, BatchShiftChangeState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      var selectedMachine = context
                          .read<VariableStateHandlerCubit<UserMachine>>()
                          .state;
                      var selectedShift = context
                          .read<VariableStateHandlerCubit<ShiftData>>()
                          .state;
                      context.read<BatchShiftChangeBloc>().add(
                            ChangeBatchShift(
                              userId: widget.loggedUser.userId,
                              lotNo: widget.data?.lotNo ?? "",
                              shiftName: selectedShift != null
                                  ? selectedShift.shiftName ?? ""
                                  : widget.data?.shiftName ?? "",
                              machineName: selectedMachine != null
                                  ? selectedMachine.machineName ?? ""
                                  : widget.data?.machineName ?? "",
                              manPower: hrTextController.text.isNotEmpty
                                  ? hrTextController.text
                                  : widget.data?.shiftManPower.toString() ?? "",
                            ),
                          );
                    },
                    child: Text(
                      state is BatchShiftChangeLoading ? "Saving.." : "Save",
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
    );
  }
}
