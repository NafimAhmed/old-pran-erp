import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/user_basic_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_drop_down_menu_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_lable_wth_textfield.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/bloc/user_qr_print_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/bloc/user_qr_save_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/bloc/user_basic_data_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/user_org_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/widgets/user_qr_print_widget.dart';
import 'package:pran_rfl_erp/presentations/print_qr_screen/print_qr_screen.dart';

class OpmC2Screen extends StatelessWidget {
  const OpmC2Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-2-SCREEN";

  static const String routePath = "/OPM-C-2-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBasicDataBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<UserOrg>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<UserMachine>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<UserBatch>(),
        ),
        BlocProvider(
          create: (context) => UserQrSaveBloc(getService()),
        ),
        BlocProvider(
          create: (context) => UserQrPrintBloc(getService()),
        )
      ],
      child: ProductionScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class ProductionScreenBody extends StatefulWidget {
  const ProductionScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<ProductionScreenBody> createState() => _ProductionScreenBodyState();
}

class _ProductionScreenBodyState extends State<ProductionScreenBody> {
  TextEditingController quantityTextController = TextEditingController();
  FocusNode quantityFocusNode = FocusNode();
  TextEditingController goodQtyTextController = TextEditingController();
  FocusNode goodQtyFocusNode = FocusNode();
  TextEditingController badQtyTextController = TextEditingController();
  FocusNode badQtyFocusNode = FocusNode();
  TextEditingController batchDropDownTextController = TextEditingController();
  TextEditingController orgDropDownTextController = TextEditingController();
  TextEditingController machineDropDownTextController = TextEditingController();
  List<UserMachine> machineList = [];
  GlobalKey<FormState> fromkey = GlobalKey();
  late UserInfoModel loggedUser;

  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
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
    batchDropDownTextController.dispose();
    machineDropDownTextController.dispose();
    orgDropDownTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserQrSaveBloc, UserQrSaveState>(
      listener: (context, state) {
        if (state is UserQrSaveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.successSnackber(
              message: "Successfully Added..",
            ),
          );
          quantityTextController.clear();
          goodQtyTextController.clear();
          badQtyTextController.clear();
          batchDropDownTextController.clear();
          machineDropDownTextController.clear();
          orgDropDownTextController.clear();
          var selectedOrg =
              context.read<VariableStateHandlerCubit<UserOrg>>().state;
          context.read<VariableStateHandlerCubit<UserMachine>>().reset();
          context.read<VariableStateHandlerCubit<UserBatch>>().reset();
          context.read<UserBasicDataBloc>().add(
                UserBasicDataGet(
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
            CustomSnackBar.errorSnackber(
              message: state.error.toString(),
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CommonAppBar(appBartitle: widget.fromName), //D-Prod screen
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                // const UserDetailsWidget(),
                Form(
                  key: fromkey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: BlocBuilder<UserOrgBloc, UserOrgState>(
                              builder: (context, state) {
                                return CommonDropDownMenuWidget<UserOrg>(
                                  hintText: "Select Org",
                                  enabled: state is UserOrgSuccess
                                      ? state.userOrg.isNotEmpty
                                      : false,
                                  controller: orgDropDownTextController,
                                  dropdownMenuEntries: state is UserOrgSuccess
                                      ? state.userOrg
                                      : [],
                                  onSelected: (value) {
                                    context.read<UserQrPrintBloc>().add(
                                          GetUserQrPrintData(
                                            userid: loggedUser.userId,
                                            orgid: value!.organizationId
                                                .toString(),
                                          ),
                                        );
                                    context
                                        .read<
                                            VariableStateHandlerCubit<
                                                UserMachine>>()
                                        .reset();
                                    context
                                        .read<
                                            VariableStateHandlerCubit<
                                                UserBatch>>()
                                        .reset();
                                    context.read<UserBasicDataBloc>().add(
                                          UserBasicDataGet(
                                            userId: loggedUser.userId,
                                            orgid: value.organizationId!
                                                .toString(),
                                          ),
                                        );
                                    context
                                        .read<
                                            VariableStateHandlerCubit<
                                                UserOrg>>()
                                        .update(value);
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: BlocBuilder<UserBasicDataBloc,
                                UserBasicDataState>(
                              builder: (context, state) {
                                return CommonDropDownMenuWidget<UserMachine>(
                                  enabled: state is UserBasicDataSuccess
                                      ? state.userBasicData.userMachineData
                                              ?.isNotEmpty ??
                                          false
                                      : false,
                                  hintText: "Select Machine",
                                  controller: machineDropDownTextController,
                                  dropdownMenuEntries: state
                                          is UserBasicDataSuccess
                                      ? state.userBasicData.userMachineData ??
                                          []
                                      : [],
                                  onSelected: (value) {
                                    context
                                        .read<
                                            VariableStateHandlerCubit<
                                                UserMachine>>()
                                        .update(value!);
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
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
                      BlocBuilder<UserBasicDataBloc, UserBasicDataState>(
                        builder: (context, state) {
                          return CommonDropDownMenuWidget<UserBatch>(
                            enabled: state is UserBasicDataSuccess
                                ? state.userBasicData.userBatchData
                                        ?.isNotEmpty ??
                                    false
                                : false,
                            controller: batchDropDownTextController,
                            hintText: "Select Batch",
                            onSelected: (value) {
                              context
                                  .read<VariableStateHandlerCubit<UserBatch>>()
                                  .update(value!);
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            dropdownMenuEntries: state is UserBasicDataSuccess
                                ? state.userBasicData.userBatchData ?? []
                                : [],
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<VariableStateHandlerCubit<UserBatch>,
                          UserBatch?>(
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                            style:
                                                textTheme.bodyMedium!.copyWith(
                                              color: appTheme.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                            style:
                                                textTheme.bodyMedium!.copyWith(
                                              color: appTheme.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                            style:
                                                textTheme.bodyMedium!.copyWith(
                                              color: appTheme.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonLableWthTextField(
                        lableName: "Good Qty",
                        focusNode: goodQtyFocusNode,
                        textController: goodQtyTextController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Good Quantity";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          var goodQty = value.isEmpty ? 0 : int.parse(value);
                          badQtyTextController.text = "0";
                          var badQty = badQtyTextController.text.isEmpty
                              ? 0
                              : int.parse(badQtyTextController.text);
                          quantityTextController.text =
                              (goodQty + badQty).toString();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonLableWthTextField(
                        lableName: "Bad Qty",
                        focusNode: badQtyFocusNode,
                        textController: badQtyTextController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Bad Quantity";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          var badQty = value.isEmpty ? 0 : int.parse(value);
                          var goodQty = goodQtyTextController.text.isEmpty
                              ? 0
                              : int.parse(goodQtyTextController.text);
                          quantityTextController.text =
                              (goodQty + badQty).toString();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonLableWthTextField(
                        lableName: "Quantity",
                        readOnly: true,
                        focusNode: quantityFocusNode,
                        textController: quantityTextController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Quantity";
                          }
                          return null;
                        },
                        onChanged: (value) {},
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                BlocBuilder<UserQrSaveBloc, UserQrSaveState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is UserQrSaveLoading
                          ? () {}
                          : () {
                              if (fromkey.currentState!.validate()) {
                                if (context
                                        .read<
                                            VariableStateHandlerCubit<
                                                UserOrg>>()
                                        .state ==
                                    null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackBar.errorSnackber(
                                      message: "Please Select Org",
                                    ),
                                  );
                                  return;
                                }
                                if (context
                                        .read<
                                            VariableStateHandlerCubit<
                                                UserBatch>>()
                                        .state ==
                                    null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackBar.errorSnackber(
                                      message: "Please Select Batch",
                                    ),
                                  );
                                  return;
                                }
                                if (context
                                        .read<
                                            VariableStateHandlerCubit<
                                                UserMachine>>()
                                        .state ==
                                    null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackBar.errorSnackber(
                                      message: "Please Select Machine",
                                    ),
                                  );
                                  return;
                                }
                                var selectedOrg = context
                                    .read<VariableStateHandlerCubit<UserOrg>>()
                                    .state;
                                var selectedMachine = context
                                    .read<
                                        VariableStateHandlerCubit<
                                            UserMachine>>()
                                    .state;
                                var selectedBatch = context
                                    .read<
                                        VariableStateHandlerCubit<UserBatch>>()
                                    .state;
                                context.read<UserQrSaveBloc>().add(
                                      UserQrSave(
                                          userid: loggedUser.userId,
                                          itemid: selectedBatch!.inventoryItemId
                                              .toString(),
                                          machine:
                                              selectedMachine!.machineName!,
                                          batchid:
                                              selectedBatch.batchId.toString(),
                                          orgid: selectedOrg!.organizationId
                                              .toString(),
                                          goodQty: goodQtyTextController.text,
                                          badQty: badQtyTextController.text,
                                          qty: quantityTextController.text),
                                    );
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
                SizedBox(
                  height: 300,
                  child: BlocBuilder<UserQrPrintBloc, UserQrPrintState>(
                    builder: (context, state) {
                      if (state is UserQrPrintSuccess) {
                        return ListView.separated(
                          itemCount: state.userBatchQrDataList.length,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
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
                                    "userOrg": userOrg
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
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const UserDetailsWidget(),
      ),
    );
  }
}
