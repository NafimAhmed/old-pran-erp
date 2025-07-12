import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/item_stock_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_lable_wth_textfield.dart';
import 'package:pran_rfl_erp/common_widgets/custom_dropdown_search.dart';

import 'package:pran_rfl_erp/core/theme/app_theme.dart';

import 'package:pran_rfl_erp/global_blocs/bloc/user_org_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_10_screen/bloc/grn_qr_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_10_screen/bloc/grn_qr_save_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_10_screen/bloc/item_stock_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/print_grn_qr_screen/print_grn_qr_screen.dart';

class InvC10Screen extends StatelessWidget {
  const InvC10Screen({super.key, required this.fromName});
  static const String routeName = "INV-C-10-SCREEN";
  static const String routePath = "/INV-C-10-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ItemStockListBloc(getService())),
        BlocProvider(create: (context) => GrnQrSaveBloc(getService())),
        BlocProvider(create: (context) => GrnQrListBloc(getService())),

        BlocProvider(create: (context) => VariableStateHandlerCubit<UserOrg>()),
      ],
      child: InvC10ScreenBody(fromName: fromName),
    );
  }
}

class InvC10ScreenBody extends StatefulWidget {
  const InvC10ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<InvC10ScreenBody> createState() => _InvC10ScreenBodyState();
}

class _InvC10ScreenBodyState extends State<InvC10ScreenBody> {
  final GlobalKey<FormState> _fromKey = GlobalKey();
  late UserInfoModel loggedUser;
  TextEditingController locator = TextEditingController();
  FocusNode quantityFocusNode = FocusNode();
  TextEditingController qty = TextEditingController();
  FocusNode goodQtyFocusNode = FocusNode();
  TextEditingController subInv = TextEditingController();
  FocusNode badQtyFocusNode = FocusNode();
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;
    context.read<GrnQrListBloc>().add(
      GrnQrListGet(userId: loggedUser.userId.toString(), qrType: "STOCK_QR"),
    );
    super.initState();
  }

  @override
  void dispose() {
    locator.dispose();
    qty.dispose();
    subInv.dispose();
    quantityFocusNode.dispose();
    goodQtyFocusNode.dispose();
    badQtyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Form(
              key: _fromKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<UserOrgBloc, UserOrgState>(
                          builder: (context, state) {
                            return CustomDropdownSearch<UserOrg>(
                              hintText: "Select Org",
                              enabled: state is UserOrgSuccess
                                  ? state.userOrg.isNotEmpty
                                  : false,

                              items: state is UserOrgSuccess
                                  ? state.userOrg
                                  : [],
                              onChanged: (value) {
                                if (value != null) {
                                  context
                                      .read<
                                        VariableStateHandlerCubit<UserOrg>
                                      >()
                                      .update(value);
                                  context.read<ItemStockListBloc>().add(
                                    ItemStockListGet(
                                      orgId: value.organizationId ?? 0,
                                    ),
                                  );
                                }
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Please Select Organization";
                                }
                                return null;
                              },
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
                            BlocBuilder<ItemStockListBloc, ItemStockListState>(
                              builder: (context, state) {
                                return CustomDropdownSearch<ItemStock>(
                                  hintText: "Select Item",
                                  enabled:
                                      state.isSuccess &&
                                      state.itemStockList!.isNotEmpty,

                                  items: state.itemStockList ?? [],
                                  onChanged: (value) {
                                    if (value != null) {
                                      context.read<ItemStockListBloc>().add(
                                        ItemStockListSelect(value: value),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                  BlocConsumer<ItemStockListBloc, ItemStockListState>(
                    buildWhen: (previous, current) {
                      return current.selectedValue != null &&
                          previous.selectedValue != current.selectedValue;
                    },
                    listenWhen: (previous, current) {
                      return current.selectedValue != null &&
                          previous.selectedValue != current.selectedValue;
                    },
                    listener: (context, state) {
                      qty.text = state.selectedValue!.qty.toString();
                      subInv.text =
                          (state.selectedValue!.subinventoryCode ?? '');
                      locator.text =
                          state.selectedValue!.secondaryLocator?.toString() ??
                          '';
                    },
                    builder: (context, state) {
                      if (state.selectedValue != null) {
                        return Column(
                          children: [
                            const SizedBox(height: 10),
                            CommonLableWthTextField(
                              readOnly: true,
                              lableName: "Qty",
                              focusNode: goodQtyFocusNode,
                              textController: qty,
                            ),
                            const SizedBox(height: 10),
                            CommonLableWthTextField(
                              readOnly: true,
                              lableName: "Sub Inventory",
                              focusNode: badQtyFocusNode,
                              textController: subInv,
                            ),
                            const SizedBox(height: 10),
                            CommonLableWthTextField(
                              lableName: "Locator",
                              readOnly: true,
                              focusNode: quantityFocusNode,
                              textController: locator,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Quantity";
                                }
                                return null;
                              },
                              onChanged: (value) {},
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            BlocBuilder<GrnQrSaveBloc, GrnQrSaveState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    if (_fromKey.currentState!.validate()) {
                      UserOrg userOrg = context
                          .read<VariableStateHandlerCubit<UserOrg>>()
                          .state!;
                      var itemStockState = context
                          .read<ItemStockListBloc>()
                          .state;
                      context.read<GrnQrSaveBloc>().add(
                        GrnQrSave(
                          userId: loggedUser.userId.toString(),
                          orgId: userOrg.organizationId ?? 0,
                          itemId:
                              itemStockState.selectedValue!.inventoryItemId ??
                              0,
                          qty: double.parse(qty.text),
                          locId: locator.text,
                          subInv: subInv.text,
                        ),
                      );
                    }
                  },
                  child: Text(
                    state.isLoading ? "Saving.." : "Save",
                    style: textTheme.bodyMedium!.copyWith(
                      color: appTheme.white,
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<GrnQrListBloc, GrnQrListState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.isSuccess) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        var data = state.grnQrList![index];
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 209, 222, 245),
                            // color: index % 2 == 0
                            //     ? const Color.fromARGB(255, 115, 134, 240)
                            //     : const Color.fromARGB(255, 136, 152, 247),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Item Name",
                                        style: textTheme.bodyMedium!.copyWith(
                                          fontSize: 15,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                      Text(
                                        data.itemName.toString(),
                                        style: textTheme.bodySmall!.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Item Code",
                                        style: textTheme.bodyMedium!.copyWith(
                                          fontSize: 15,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                      Text(
                                        data.itemCode ?? "",
                                        style: textTheme.bodySmall!.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Sub Inventory",
                                        style: textTheme.bodyMedium!.copyWith(
                                          fontSize: 15,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                      Text(
                                        data.subInv ?? "-",
                                        style: textTheme.bodySmall!.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Locator",
                                        style: textTheme.bodyMedium!.copyWith(
                                          fontSize: 15,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                      Text(
                                        data.locatorId?.toString() ?? "-",
                                        style: textTheme.bodySmall!.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Trn Id",
                                        style: textTheme.bodyMedium!.copyWith(
                                          fontSize: 15,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                      Text(
                                        data.trnid ?? "",
                                        style: textTheme.bodySmall!.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom().copyWith(
                                      padding:
                                          const WidgetStatePropertyAll<
                                            EdgeInsetsGeometry
                                          >(
                                            EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                          ),
                                      minimumSize:
                                          WidgetStateProperty.all<Size>(
                                            const Size(80, 30),
                                          ),
                                      backgroundColor: WidgetStatePropertyAll(
                                        appTheme.tertiary,
                                      ),
                                    ),
                                    onPressed: () {
                                      context.pushNamed(
                                        PrintGrnQrScreen.routeName,
                                        extra: {
                                          "grnQrData": data,
                                          "grnQrPrintBlocCtx": context,
                                        },
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "Print ",
                                          style: textTheme.bodyMedium!.copyWith(
                                            fontSize: 14,
                                            color: appTheme.white,
                                          ),
                                        ),
                                        Icon(
                                          Icons.qr_code,
                                          color: appTheme.white,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemCount: state.grnQrList?.length ?? 0,
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
