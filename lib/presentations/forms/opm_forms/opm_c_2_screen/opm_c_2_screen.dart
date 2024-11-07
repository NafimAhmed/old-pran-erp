import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/entities/user_basic_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/bloc/user_qr_print_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/bloc/user_qr_save_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/bloc/user_basic_data_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/user_org_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/cubit/selected_batch_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/cubit/selected_machine_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/cubit/selected_org_cubit.dart';
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
          create: (context) => SelectedOrgCubit(),
        ),
        BlocProvider(
          create: (context) => SelectedMachineCubit(),
        ),
        BlocProvider(
          create: (context) => SelectedBatchCubit(),
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
          var selectedOrg = context.read<SelectedOrgCubit>().state;
          context.read<SelectedMachineCubit>().resetMachine();
          context.read<SelectedBatchCubit>().resetBatch();
          context.read<UserBasicDataBloc>().add(
                UserBasicDataGet(
                  userId: loggedUser.userId!,
                  orgid: context
                      .read<SelectedOrgCubit>()
                      .state!
                      .organizationId
                      .toString(),
                ),
              );
          context.read<UserQrPrintBloc>().add(
                GetUserQrPrintData(
                  userid: loggedUser.userId!,
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
                const UserDetailsWidget(),
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
                                            userid: loggedUser.userId!,
                                            orgid: value!.organizationId
                                                .toString(),
                                          ),
                                        );
                                    context
                                        .read<SelectedMachineCubit>()
                                        .resetMachine();
                                    context
                                        .read<SelectedBatchCubit>()
                                        .resetBatch();
                                    context.read<UserBasicDataBloc>().add(
                                          UserBasicDataGet(
                                            userId: loggedUser.userId!,
                                            orgid: value.organizationId!
                                                .toString(),
                                          ),
                                        );
                                    context
                                        .read<SelectedOrgCubit>()
                                        .setOrg(userOrg: value);
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
                                      .watch<SelectedMachineCubit>()
                                      .state,
                                  onChanged: (value) {
                                    context
                                        .read<SelectedMachineCubit>()
                                        .setMachine(selectedMachine: value!);
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
                      BlocBuilder<UserBasicDataBloc, UserBasicDataState>(
                        builder: (context, state) {
                          return CommonDropdownButton<UserBatch>(
                            hintText: "Select Batch",
                            items: state is UserBasicDataSuccess
                                ? state.userBasicData.userBatchData
                                : [],
                            value: context.watch<SelectedBatchCubit>().state,
                            onChanged: (value) {
                              context
                                  .read<SelectedBatchCubit>()
                                  .setBatch(selectedBatch: value!);
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Please Select Batch";
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<SelectedBatchCubit, UserBatch?>(
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
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: appTheme.primary,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(
                                    20,
                                  ),
                                  bottomRight: Radius.circular(
                                    20,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Good Qty",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CommonTextFieldWidget(
                              focusNode: goodQtyFocusNode,
                              textAlign: TextAlign.center,
                              controller: goodQtyTextController,
                              keyboardType: TextInputType.phone,
                              style: textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: appTheme.primary,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              labelText: "",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Good Quantity";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                var goodQty =
                                    value.isEmpty ? 0 : int.parse(value);
                                badQtyTextController.text = "0";
                                var badQty = badQtyTextController.text.isEmpty
                                    ? 0
                                    : int.parse(badQtyTextController.text);
                                quantityTextController.text =
                                    (goodQty + badQty).toString();
                              },
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
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: appTheme.primary,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(
                                    20,
                                  ),
                                  bottomRight: Radius.circular(
                                    20,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Bad Qty",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CommonTextFieldWidget(
                              focusNode: badQtyFocusNode,
                              textAlign: TextAlign.center,
                              controller: badQtyTextController,
                              keyboardType: TextInputType.phone,
                              style: textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: appTheme.primary,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              labelText: "",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Bad Quantity";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                var badQty =
                                    value.isEmpty ? 0 : int.parse(value);
                                var goodQty = goodQtyTextController.text.isEmpty
                                    ? 0
                                    : int.parse(goodQtyTextController.text);
                                quantityTextController.text =
                                    (goodQty + badQty).toString();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: appTheme.primary,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(
                                    20,
                                  ),
                                  bottomRight: Radius.circular(
                                    20,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Quantity",
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: appTheme.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CommonTextFieldWidget(
                              readOnly: true,
                              focusNode: quantityFocusNode,
                              textAlign: TextAlign.center,
                              controller: quantityTextController,
                              keyboardType: TextInputType.phone,
                              style: textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: appTheme.primary,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              labelText: "",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Quantity";
                                }
                                return null;
                              },
                              onChanged: (value) {},
                            ),
                          ),
                        ],
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
                                var selectedOrg =
                                    context.read<SelectedOrgCubit>().state;
                                var selectedMachine =
                                    context.read<SelectedMachineCubit>().state;
                                var selectedBatch =
                                    context.read<SelectedBatchCubit>().state;
                                context.read<UserQrSaveBloc>().add(
                                      UserQrSave(
                                          userid: loggedUser.userId!,
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
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: appTheme.primary,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(userBatchQrData.lotno ?? ""),
                                      ElevatedButton(
                                        style:
                                            ElevatedButton.styleFrom().copyWith(
                                          padding: const WidgetStatePropertyAll<
                                              EdgeInsetsGeometry>(
                                            EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                          ),
                                          minimumSize:
                                              WidgetStateProperty.all<Size>(
                                            const Size(80, 30),
                                          ),
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                            appTheme.tertiary,
                                          ),
                                        ),
                                        onPressed: () {
                                          UserOrg userOrg = context
                                              .read<SelectedOrgCubit>()
                                              .state!;
                                          context.pushNamed(
                                            PrintQrScreen.routeName,
                                            extra: {
                                              "userBatchQrData":
                                                  userBatchQrData,
                                              "userQrPrintBlocCtx": context,
                                              "userOrg": userOrg
                                            },
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              "Print Qr",
                                              style: textTheme.bodyMedium!
                                                  .copyWith(
                                                fontSize: 14,
                                                color: appTheme.white,
                                              ),
                                            ),
                                            Icon(
                                              Icons.qr_code,
                                              color: appTheme.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Job Order: ",
                                        style: textTheme.bodyMedium!.copyWith(
                                          fontSize: 14,
                                          color: appTheme.white,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          userBatchQrData.jobno ?? "",
                                          style: textTheme.bodyMedium!.copyWith(
                                            fontSize: 14,
                                            color: appTheme.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Item: ",
                                        style: textTheme.bodyMedium!.copyWith(
                                          fontSize: 14,
                                          color: appTheme.white,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          userBatchQrData.itemname ?? "",
                                          style: textTheme.bodyMedium!.copyWith(
                                            fontSize: 14,
                                            color: appTheme.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Good Qty: ",
                                        style: textTheme.bodyMedium!.copyWith(
                                          fontSize: 14,
                                          color: appTheme.white,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          userBatchQrData.goodQty.toString(),
                                          style: textTheme.bodyMedium!.copyWith(
                                            fontSize: 14,
                                            color: appTheme.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Locator: ",
                                        style: textTheme.bodyMedium!.copyWith(
                                          fontSize: 14,
                                          color: appTheme.white,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          userBatchQrData.locLocator.toString(),
                                          style: textTheme.bodyMedium!.copyWith(
                                            fontSize: 14,
                                            color: appTheme.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}
