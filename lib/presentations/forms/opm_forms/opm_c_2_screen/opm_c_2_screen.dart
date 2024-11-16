import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/user_basic_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
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
  const OpmC2Screen({super.key});
  static const String routeName = "OPM-C-2-SCREEN";

  static const String routePath = "/OPM-C-2-SCREEN";
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
      child: const ProductionScreenBody(),
    );
  }
}

class ProductionScreenBody extends StatefulWidget {
  const ProductionScreenBody({super.key});

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
  TextEditingController dropDownTextController = TextEditingController();

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
        appBar: const CommonAppBar(appBartitle: "D-Production"),
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
                                return CommonDropdownButton<UserOrg>(
                                  hintText: "Select Org",
                                  items: state is UserOrgSuccess
                                      ? state.userOrg
                                      : [],
                                  onChanged: (value) {
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
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please Select Org";
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
                            child: BlocBuilder<UserBasicDataBloc,
                                UserBasicDataState>(
                              builder: (context, state) {
                                return CommonDropdownButton<UserMachine>(
                                  hintText: "Select Machine",
                                  items: state is UserBasicDataSuccess
                                      ? state.userBasicData.userMachineData
                                      : [],
                                  value: context
                                      .watch<
                                          VariableStateHandlerCubit<
                                              UserMachine>>()
                                      .state,
                                  onChanged: (value) {
                                    context
                                        .read<
                                            VariableStateHandlerCubit<
                                                UserMachine>>()
                                        .update(value!);
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please Select Mahine";
                                    }
                                    return null;
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
                      // BlocBuilder<UserBasicDataBloc, UserBasicDataState>(
                      //   builder: (context, state) {
                      //     return CommonDropdownButton<UserBatch>(
                      //       hintText: "Select Batch",
                      //       items: state is UserBasicDataSuccess
                      //           ? state.userBasicData.userBatchData
                      //           : [],
                      //       value: context
                      //           .watch<VariableStateHandlerCubit<UserBatch>>()
                      //           .state,
                      //       onChanged: (value) {
                      //         context
                      //             .read<VariableStateHandlerCubit<UserBatch>>()
                      //             .update(value!);
                      //       },
                      //       validator: (value) {
                      //         if (value == null) {
                      //           return "Please Select Batch";
                      //         }
                      //         return null;
                      //       },
                      //     );
                      //   },
                      // ),
                      BlocBuilder<UserBasicDataBloc, UserBasicDataState>(
                        builder: (context, state) {
                          return DropdownMenu<UserBatch>(
                            menuHeight: 250,
                            expandedInsets: EdgeInsets.zero,
                            enableSearch: true,
                            requestFocusOnTap: true,
                            enabled: state is UserBasicDataSuccess
                                ? state.userBasicData.userBatchData
                                        ?.isNotEmpty ??
                                    false
                                : false,
                            // enableFilter: true,
                            controller: dropDownTextController,
                            hintText: "Select Machine",
                            inputDecorationTheme: InputDecorationTheme(
                              hintStyle: textTheme.bodySmall!.copyWith(
                                color: appTheme.primary,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            textStyle: textTheme.bodySmall!.copyWith(
                              color: appTheme.primary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            onSelected: (value) {
                              context
                                  .read<VariableStateHandlerCubit<UserBatch>>()
                                  .update(value!);
                              FocusManager.instance.primaryFocus?.unfocus();
                            },

                            dropdownMenuEntries: state is UserBasicDataSuccess
                                ? state.userBasicData.userBatchData!.map(
                                    (e) {
                                      return DropdownMenuEntry(
                                        value: e,
                                        label: e.toString(),
                                        labelWidget: Text(
                                          e.toString(),
                                          style: textTheme.bodySmall!.copyWith(
                                            color: appTheme.primary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList()
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
                            return Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: appTheme.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Ttl Qty :",
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
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: appTheme.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Ori Qty: ",
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
