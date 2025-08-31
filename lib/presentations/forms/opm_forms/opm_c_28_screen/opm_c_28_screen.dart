import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/locator_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/prod_basic_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/shift_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/prod_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/sub_inv_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_lable_wth_textfield.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_dropdown_search.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/text_input_formatters.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/shift_data_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/bloc/locator_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/bloc/prod_batch_data_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/bloc/sub_inv_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/bloc/user_qr_print_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/bloc/user_qr_save_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/bloc/user_basic_data_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/user_org_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/widgets/user_qr_print_widget.dart';
import 'package:pran_rfl_erp/presentations/print_qr_screen/print_qr_screen.dart';

class OpmC28Screen extends StatelessWidget {
  const OpmC28Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-28-SCREEN";

  static const String routePath = "/OPM-C-28-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBasicDataBloc(getService())),
        BlocProvider(create: (context) => ProdBatchDataBloc(getService())),
        BlocProvider(create: (context) => UserQrSaveBloc(getService())),
        BlocProvider(create: (context) => UserQrPrintBloc(getService())),
        BlocProvider(create: (context) => SubInvListBloc(getService())),
        BlocProvider(create: (context) => LocatorListBloc(getService())),
        BlocProvider(create: (context) => ShiftDataBloc(getService())),
        BlocProvider(create: (context) => VariableStateHandlerCubit<UserOrg>()),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<PendingJo>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<UserMachine>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<UserBatch>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<ShiftData>(),
        ),
      ],
      child: OpmC28ScreenBody(fromName: fromName),
    );
  }
}

class OpmC28ScreenBody extends StatefulWidget {
  const OpmC28ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OpmC28ScreenBody> createState() => _OpmC28ScreenBodyState();
}

class _OpmC28ScreenBodyState extends State<OpmC28ScreenBody> {
  TextEditingController quantityTextController = TextEditingController();
  FocusNode quantityFocusNode = FocusNode();
  TextEditingController goodQtyTextController = TextEditingController();
  FocusNode goodQtyFocusNode = FocusNode();
  TextEditingController badQtyTextController = TextEditingController();
  FocusNode badQtyFocusNode = FocusNode();
  TextEditingController timeTextController = TextEditingController();
  TextEditingController hrTextController = TextEditingController();
  FocusNode hrFocusNode = FocusNode();
  List<UserMachine> machineList = [];
  GlobalKey<FormState> fromkey = GlobalKey();
  late UserInfoModel loggedUser;

  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;
    super.initState();
  }

  @override
  void dispose() {
    quantityTextController.dispose();
    goodQtyTextController.dispose();
    badQtyTextController.dispose();
    quantityFocusNode.dispose();
    goodQtyFocusNode.dispose();
    badQtyFocusNode.dispose();
    timeTextController.dispose();
    hrTextController.dispose();

    super.dispose();
  }

  bool _customValidator() {
    if (context.read<VariableStateHandlerCubit<UserOrg>>().state == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.errorSnackber(message: "Please Select Org"),
      );
      return false; // Validation failed
    }
    if (context.read<VariableStateHandlerCubit<PendingJo>>().state == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar.errorSnackber(message: "Please Select JO"));
      return false; // Validation failed
    }
    if (context.read<VariableStateHandlerCubit<UserBatch>>().state == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.errorSnackber(message: "Please Select Batch"),
      );
      return false; // Validation failed
    }
    if (context.read<VariableStateHandlerCubit<UserMachine>>().state == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.errorSnackber(message: "Please Select Machine"),
      );
      return false; // Validation failed
    }
    return true; // Validation passed
  }

  void _userQrSave() {
    var selectedOrg = context.read<VariableStateHandlerCubit<UserOrg>>().state;
    var selectedMachine = context
        .read<VariableStateHandlerCubit<UserMachine>>()
        .state;
    var selectedBatch = context
        .read<VariableStateHandlerCubit<UserBatch>>()
        .state;
    var seletedShift = context
        .read<VariableStateHandlerCubit<ShiftData>>()
        .state;
    var subInvCode = context
        .read<LocatorListBloc>()
        .state
        .selectedValue!
        .subinventoryCode!;
    var locId = context
        .read<LocatorListBloc>()
        .state
        .selectedValue!
        .secondaryLocator!;
    var locator = context
        .read<LocatorListBloc>()
        .state
        .selectedValue!
        .fullLocator!;
    context.read<UserQrSaveBloc>().add(
      UserQrSaveWithTrn(
        userid: loggedUser.userId,
        itemid: selectedBatch!.inventoryItemId.toString(),
        machine: selectedMachine!.machineName!,
        batchid: selectedBatch.batchId.toString(),
        orgid: selectedOrg!.organizationId.toString(),
        goodQty: goodQtyTextController.text,
        badQty: badQtyTextController.text,
        qty: quantityTextController.text,
        shiftnm: seletedShift?.shiftName ?? "",
        shiftFromTime: timeTextController.text,
        subInvCode: subInvCode,
        locId: locId,
        locator: locator,
        hr: hrTextController.text.isEmpty
            ? 0
            : num.parse(hrTextController.text),
      ),
    );
  }

  dynamic _onSelectOrg(UserOrg? value) {
    // FocusScope.of(context).unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<UserQrPrintBloc>().add(
      GetUserQrPrintData(
        userid: loggedUser.userId,
        orgid: value!.organizationId.toString(),
      ),
    );
    context.read<VariableStateHandlerCubit<UserMachine>>().reset();
    context.read<VariableStateHandlerCubit<UserBatch>>().reset();
    context.read<VariableStateHandlerCubit<PendingJo>>().reset();
    context.read<ProdBatchDataBloc>().add(ProdBatchDataReset());

    context.read<UserBasicDataBloc>().add(
      UserBasicDataGet2(
        userId: loggedUser.userId,
        orgid: value.organizationId!.toString(),
      ),
    );
    context.read<VariableStateHandlerCubit<UserOrg>>().update(value);
  }

  dynamic _onSelectMachine(UserMachine? value) {
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<VariableStateHandlerCubit<UserMachine>>().update(value!);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  dynamic _onSelectJO(PendingJo? value) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (value != null) {
      context.read<VariableStateHandlerCubit<PendingJo>>().update(value);
      context.read<VariableStateHandlerCubit<ShiftData>>().reset();
      context.read<VariableStateHandlerCubit<UserBatch>>().reset();

      context.read<ShiftDataBloc>().add(GetShiftData());
      var selectedOrg = context
          .read<VariableStateHandlerCubit<UserOrg>>()
          .state!;
      context.read<ProdBatchDataBloc>().add(
        ProdBatchWipDataGet(
          userId: loggedUser.userId,
          orgid: selectedOrg.organizationId?.toString() ?? "",
          jobOrderNo: value.jobOrderNo ?? "",
        ),
      );
    }
  }

  dynamic _onSelectBatch(UserBatch? value) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (value != null) {
      context.read<VariableStateHandlerCubit<UserBatch>>().update(value);
      goodQtyTextController.text = value.totalPQty?.toString() ?? "0";
      badQtyTextController.text = '0';
      quantityTextController.text = value.totalPQty?.toString() ?? "0";
      context.read<SubInvListBloc>().add(SubInvListDeselect());
      context.read<SubInvListBloc>().add(
        SubInvListGet(
          orgId: context
              .read<VariableStateHandlerCubit<UserOrg>>()
              .state!
              .organizationId!,
          itemId: value.inventoryItemId!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserQrSaveBloc, UserQrSaveState>(
      listener: (context, state) {
        if (state is UserQrSaveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.successSnackber(message: "Successfully Added.."),
          );
          quantityTextController.clear();
          goodQtyTextController.clear();
          badQtyTextController.clear();
          var selectedOrg = context
              .read<VariableStateHandlerCubit<UserOrg>>()
              .state;
          context.read<VariableStateHandlerCubit<UserMachine>>().reset();
          context.read<VariableStateHandlerCubit<UserBatch>>().reset();
          context.read<VariableStateHandlerCubit<ShiftData>>().reset();
          context.read<SubInvListBloc>().add(SubInvListDeselect());
          context.read<LocatorListBloc>().add(LocatorListDeselect());
          context.read<ShiftDataBloc>().add(ResetShiftData());
          context.read<UserBasicDataBloc>().add(
            UserBasicDataGet2(
              userId: loggedUser.userId,
              orgid: context
                  .read<VariableStateHandlerCubit<UserOrg>>()
                  .state!
                  .organizationId
                  .toString(),
            ),
          );
          context.read<UserQrPrintBloc>().add(
            GetUserQrPrintData(
              userid: loggedUser.userId,
              orgid: selectedOrg!.organizationId.toString(),
            ),
          );
        }
        if (state is UserQrSaveError) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.errorSnackber(message: state.error.toString()),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CommonAppBar(appBartitle: widget.fromName), //D-Prod screen
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(height: 5),
                Form(
                  key: fromkey,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: BlocBuilder<UserOrgBloc, UserOrgState>(
                              builder: (context, state) {
                                return CustomDropdownSearch<UserOrg>(
                                  hintText: "Select Org",
                                  value: context
                                      .watch<
                                        VariableStateHandlerCubit<UserOrg>
                                      >()
                                      .state,
                                  enabled: state is UserOrgSuccess
                                      ? state.userOrg.isNotEmpty
                                      : false,
                                  items: state is UserOrgSuccess
                                      ? state.userOrg
                                      : [],
                                  onChanged: _onSelectOrg,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child:
                                BlocBuilder<
                                  UserBasicDataBloc,
                                  UserBasicDataState
                                >(
                                  builder: (context, state) {
                                    return CustomDropdownSearch<UserMachine>(
                                      enabled: state is UserBasicDataSuccess
                                          ? state
                                                    .prodBasicData
                                                    .userMachineData
                                                    ?.isNotEmpty ??
                                                false
                                          : false,
                                      value: context
                                          .watch<
                                            VariableStateHandlerCubit<
                                              UserMachine
                                            >
                                          >()
                                          .state,
                                      hintText: "Select Machine",
                                      items: state is UserBasicDataSuccess
                                          ? state
                                                    .prodBasicData
                                                    .userMachineData ??
                                                []
                                          : [],
                                      onChanged: _onSelectMachine,
                                    );
                                  },
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child:
                                BlocBuilder<
                                  UserBasicDataBloc,
                                  UserBasicDataState
                                >(
                                  builder: (context, state) {
                                    return CustomDropdownSearch<PendingJo>(
                                      enabled: state is UserBasicDataSuccess
                                          ? state
                                                    .prodBasicData
                                                    .pendingJoList
                                                    ?.isNotEmpty ??
                                                false
                                          : false,
                                      value: context
                                          .watch<
                                            VariableStateHandlerCubit<PendingJo>
                                          >()
                                          .state,
                                      hintText: "Select JO",
                                      onChanged: _onSelectJO,
                                      items: state is UserBasicDataSuccess
                                          ? state.prodBasicData.pendingJoList ??
                                                []
                                          : [],
                                    );
                                  },
                                ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child:
                                BlocBuilder<
                                  ProdBatchDataBloc,
                                  ProdBatchDataState
                                >(
                                  builder: (context, state) {
                                    return CustomDropdownSearch<UserBatch>(
                                      enabled: state is ProdBatchDataSuccess
                                          ? state.prodBatchList.isNotEmpty
                                          : false,
                                      value: context
                                          .watch<
                                            VariableStateHandlerCubit<UserBatch>
                                          >()
                                          .state,
                                      hintText: "Select Batch",
                                      onChanged: _onSelectBatch,
                                      items: state is ProdBatchDataSuccess
                                          ? state.prodBatchList
                                          : [],
                                    );
                                  },
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          BlocBuilder<SubInvListBloc, SubInvListState>(
                            builder: (context, state) {
                              return Expanded(
                                child: CustomDropdownSearch<SubInventory>(
                                  enabled: state.isSuccess
                                      ? state.subInvList.isNotEmpty
                                      : false,
                                  value: state.selectedValue,
                                  hintText: "Sub Inventory",

                                  onChanged: (value) {
                                    if (value != null) {
                                      context.read<LocatorListBloc>().add(
                                        LocatorListDeselect(),
                                      );
                                      context.read<SubInvListBloc>().add(
                                        SubInvListSelect(selectedValue: value),
                                      );
                                      context.read<LocatorListBloc>().add(
                                        LocatorListGet(
                                          orgId:
                                              context
                                                  .read<
                                                    VariableStateHandlerCubit<
                                                      UserOrg
                                                    >
                                                  >()
                                                  .state!
                                                  .organizationId ??
                                              0,
                                          itemId:
                                              context
                                                  .read<
                                                    VariableStateHandlerCubit<
                                                      UserBatch
                                                    >
                                                  >()
                                                  .state!
                                                  .inventoryItemId ??
                                              0,

                                          subInvCode:
                                              value.secondaryInventory ?? "",
                                        ),
                                      );
                                    }
                                  },
                                  items: state.subInvList,
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please Select Sub Inventory";
                                    }
                                    return null;
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          BlocBuilder<LocatorListBloc, LocatorListState>(
                            builder: (context, state) {
                              return Expanded(
                                child: CustomDropdownSearch<Locator>(
                                  enabled: state.isSuccess
                                      ? state.locatorList.isNotEmpty
                                      : false,
                                  value: state.selectedValue,
                                  hintText: "Locator",
                                  onChanged: (value) {
                                    if (value != null) {
                                      context.read<LocatorListBloc>().add(
                                        LocatorListSelect(selectedValue: value),
                                      );
                                    }
                                  },
                                  items: state.locatorList,
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please Select Locator";
                                    }
                                    return null;
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CommonLableWthTextField(
                        lableName: "Good Qty",
                        focusNode: goodQtyFocusNode,
                        textController: goodQtyTextController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                          NumericalRangeFormatter(
                            min: 1.0,
                            max:
                                context
                                    .watch<
                                      VariableStateHandlerCubit<UserBatch>
                                    >()
                                    .state
                                    ?.totalPQty ??
                                0,
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Good Quantity";
                          }
                          if (num.parse(value) <= 0) {
                            return "Can't Be Zero";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          var goodQty = value.isEmpty
                              ? 0
                              : num.tryParse(value) ?? 0;
                          badQtyTextController.text = "0";
                          var badQty = badQtyTextController.text.isEmpty
                              ? 0
                              : num.tryParse(badQtyTextController.text) ?? 0;
                          quantityTextController.text = (goodQty + badQty)
                              .toString();
                        },
                      ),
                      const SizedBox(height: 10),
                      CommonLableWthTextField(
                        lableName: "Bad Qty",
                        focusNode: badQtyFocusNode,
                        textController: badQtyTextController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                          NumericalRangeFormatter(
                            min: 1.0,
                            max:
                                context
                                    .watch<
                                      VariableStateHandlerCubit<UserBatch>
                                    >()
                                    .state
                                    ?.totalPQty ??
                                0,
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Bad Quantity";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          var badQty = value.isEmpty ? 0 : num.parse(value);
                          var goodQty = goodQtyTextController.text.isEmpty
                              ? 0
                              : num.parse(goodQtyTextController.text);
                          quantityTextController.text = (goodQty + badQty)
                              .toString();
                        },
                      ),
                      const SizedBox(height: 10),
                      CommonLableWthTextField(
                        lableName: "Quantity",
                        readOnly: true,
                        focusNode: quantityFocusNode,
                        textController: quantityTextController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Quantity";
                          }
                          return null;
                        },
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                BlocBuilder<ShiftDataBloc, ShiftDataState>(
                  builder: (context, state) {
                    if (state is ShiftDataSuccess) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CommonDropdownButton<ShiftData>(
                              hintText: "Change Shift",
                              value: context
                                  .watch<VariableStateHandlerCubit<ShiftData>>()
                                  .state,
                              items: state.shiftList,
                              onChanged: (value) {
                                if (value != null) {
                                  context
                                      .read<
                                        VariableStateHandlerCubit<ShiftData>
                                      >()
                                      .update(value);
                                  timeTextController.text =
                                      value.fromShift ?? "00:00";
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CommonTextFieldWidget(
                              hintText: "Change Time",
                              controller: timeTextController,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              onTap: () async {
                                try {
                                  var shiftL = timeTextController.text
                                      .split(":")
                                      .map((e) => int.parse(e))
                                      .toList();
                                  var pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                      hour: shiftL.first,
                                      minute: shiftL.last,
                                    ),
                                  );
                                  if (pickedTime != null && context.mounted) {
                                    timeTextController.text =
                                        "${pickedTime.hour.toString().padLeft(2, "0")}:${pickedTime.minute.toString().padLeft(2, "0")}";
                                  }
                                } catch (e) {
                                  log(e.toString());
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CommonTextFieldWidget(
                              hintText: "Enter Hr",
                              controller: hrTextController,
                              focusNode: hrFocusNode,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onTap: () {},
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 5),
                BlocBuilder<VariableStateHandlerCubit<UserBatch>, UserBatch?>(
                  builder: (context, state) {
                    if (state != null) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: appTheme.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Shift:",
                                        style: textTheme.bodyMedium!.copyWith(
                                          color: appTheme.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          state.shiftName ?? "",
                                          textAlign: TextAlign.right,
                                          style: textTheme.bodyMedium!.copyWith(
                                            color: appTheme.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Man Power:",
                                        style: textTheme.bodyMedium!.copyWith(
                                          color: appTheme.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          state.shiftManPower.toString(),
                                          textAlign: TextAlign.right,
                                          style: textTheme.bodyMedium!.copyWith(
                                            color: appTheme.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "B Qty: ",
                                        style: textTheme.bodyMedium!.copyWith(
                                          color: appTheme.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          state.originalQty.toString(),
                                          textAlign: TextAlign.right,
                                          style: textTheme.bodyMedium!.copyWith(
                                            color: appTheme.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "M Qty :",
                                        style: textTheme.bodyMedium!.copyWith(
                                          color: appTheme.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          state.totalQty.toString(),
                                          textAlign: TextAlign.right,
                                          style: textTheme.bodyMedium!.copyWith(
                                            color: appTheme.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "P Qty :",
                                        style: textTheme.bodyMedium!.copyWith(
                                          color: appTheme.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${(state.originalQty ?? 0) - (state.totalQty ?? 0)}",
                                          textAlign: TextAlign.right,
                                          style: textTheme.bodyMedium!.copyWith(
                                            color: appTheme.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                ),
                const SizedBox(height: 5),
                BlocBuilder<UserQrSaveBloc, UserQrSaveState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is UserQrSaveLoading
                          ? () {}
                          : () {
                              if (fromkey.currentState!.validate()) {
                                if (_customValidator()) {
                                  _userQrSave();
                                }
                              }
                            },
                      child: Text(
                        state is UserQrSaveLoading ? "Saving.." : "Save",
                        style: textTheme.bodyMedium!.copyWith(
                          color: appTheme.white,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 300,
                  child: BlocBuilder<UserQrPrintBloc, UserQrPrintState>(
                    builder: (context, state) {
                      if (state is UserQrPrintSuccess) {
                        return ListView.separated(
                          itemCount: state.userBatchQrDataList.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            var userBatchQrData =
                                state.userBatchQrDataList[index];
                            return UserQrPrintWidget(
                              userBatchQrData: userBatchQrData,
                              onPressed: () {
                                UserOrg userOrg = context
                                    .read<VariableStateHandlerCubit<UserOrg>>()
                                    .state!;
                                context.pushNamed(
                                  PrintQrScreen.routeName,
                                  extra: {
                                    "userBatchQrData": userBatchQrData,
                                    "userQrPrintBlocCtx": context,
                                    "userOrg": userOrg,
                                  },
                                );
                              },
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const UserDetailsWidget(),
      ),
    );
  }
}
