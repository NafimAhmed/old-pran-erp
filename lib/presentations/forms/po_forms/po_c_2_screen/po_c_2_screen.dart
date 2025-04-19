import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/grn_jo_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/grn_po_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/grn_purchase_req_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/operation_unit_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_lable_wth_textfield.dart';
import 'package:pran_rfl_erp/common_widgets/custom_dropdown_search.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/operation_unit_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/po_forms/po_c_2_screen/bloc/grn_job_order_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/po_forms/po_c_2_screen/bloc/grn_org_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/po_forms/po_c_2_screen/bloc/grn_po_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/po_forms/po_c_2_screen/bloc/grn_purchase_req_list_bloc.dart';

class PoC2Screen extends StatelessWidget {
  const PoC2Screen({super.key, required this.fromName});
  static const String routeName = "PO-C-2-SCREEN";
  static const String routePath = "/PO-C-2-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OperationUnitBloc(getService()),
        ),
        BlocProvider(
          create: (context) => GrnOrgListBloc(getService()),
        ),
        BlocProvider(
          create: (context) => GrnPurchaseReqListBloc(getService()),
        ),
        BlocProvider(
          create: (context) => GrnJobOrderListBloc(getService()),
        ),
        BlocProvider(
          create: (context) => GrnPOListBloc(getService()),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<OperationUnit>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<UserOrg>(),
        ),
        BlocProvider(
          create: (context) =>
              VariableStateHandlerCubit<GrnPurchaseReqNumber>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<GrnJO>(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<GrnPO>(),
        ),
      ],
      child: POC2ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class POC2ScreenBody extends StatefulWidget {
  const POC2ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<POC2ScreenBody> createState() => _POC2ScreenBodyState();
}

class _POC2ScreenBodyState extends State<POC2ScreenBody> {
  TextEditingController quantityTextController = TextEditingController();
  FocusNode quantityFocusNode = FocusNode();
  TextEditingController goodQtyTextController = TextEditingController();
  FocusNode goodQtyFocusNode = FocusNode();
  TextEditingController badQtyTextController = TextEditingController();
  FocusNode badQtyFocusNode = FocusNode();
  @override
  void initState() {
    context.read<OperationUnitBloc>().add(OperationUnitGet());
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
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<OperationUnitBloc, OperationUnitState>(
                    builder: (context, state) {
                      return CustomDropdownSearch<OperationUnit>(
                        hintText: "Select OU",
                        enabled: state is OperationUnitSuccess ? true : false,
                        value: context
                            .watch<VariableStateHandlerCubit<OperationUnit>>()
                            .state,
                        items: state is OperationUnitSuccess
                            ? state.operationUnit
                            : [],
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<
                                    VariableStateHandlerCubit<OperationUnit>>()
                                .update(value);
                            context.read<GrnPurchaseReqListBloc>().add(
                                GrnPurchaseReqListGet(
                                    orgId: value.organizationId ?? 0));
                            context.read<GrnOrgListBloc>().add(
                                GrnOrgListGet(ouId: value.organizationId ?? 0));
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: BlocBuilder<GrnOrgListBloc, GrnOrgListState>(
                    builder: (context, state) {
                      return CustomDropdownSearch<UserOrg>(
                        hintText: "Select Org",
                        enabled: state is GrnOrgListSuccess ? true : false,
                        value: context
                            .watch<VariableStateHandlerCubit<UserOrg>>()
                            .state,
                        items: state is GrnOrgListSuccess ? state.grnOrg : [],
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<VariableStateHandlerCubit<UserOrg>>()
                                .update(value);
                          }
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
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<GrnPurchaseReqListBloc,
                      GrnPurchaseReqListState>(
                    builder: (context, state) {
                      return CustomDropdownSearch<GrnPurchaseReqNumber>(
                        hintText: "Select PR",
                        enabled:
                            state is GrnPurchaseReqListSuccess ? true : false,
                        value: context
                            .watch<
                                VariableStateHandlerCubit<
                                    GrnPurchaseReqNumber>>()
                            .state,
                        items: state is GrnPurchaseReqListSuccess
                            ? state.purchaseReqNumber
                            : [],
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<
                                    VariableStateHandlerCubit<
                                        GrnPurchaseReqNumber>>()
                                .update(value);
                            context.read<GrnJobOrderListBloc>().add(
                                GrnJobOrderListGet(
                                    reqNo: value.purchaseReqNumber ?? ""));
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: BlocBuilder<GrnJobOrderListBloc, GrnJobOrderListState>(
                    builder: (context, state) {
                      return CustomDropdownSearch<GrnJO>(
                        hintText: "Select JO",
                        enabled: state is GrnJobOrderListSuccess ? true : false,
                        items: state is GrnJobOrderListSuccess
                            ? state.grnJOList
                            : [],
                        value: context
                            .watch<VariableStateHandlerCubit<GrnJO>>()
                            .state,
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<VariableStateHandlerCubit<GrnJO>>()
                                .update(value);
                            context.read<GrnPOListBloc>().add(GrnPOListGet(
                                jobOrderNo: value.jobOrderNo ?? ""));
                          }
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
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<GrnPOListBloc, GrnPOListState>(
                    builder: (context, state) {
                      return CustomDropdownSearch<GrnPO>(
                        hintText: "Select PO",
                        enabled: state is GrnPOListSuccess ? true : false,
                        items: state is GrnPOListSuccess ? state.grnPOList : [],
                        value: context
                            .watch<VariableStateHandlerCubit<GrnPO>>()
                            .state,
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<VariableStateHandlerCubit<GrnPO>>()
                                .update(value);
                            goodQtyTextController.text =
                                value.quantity?.toString() ?? "0";
                            badQtyTextController.text = '0';
                            quantityTextController.text =
                                value.quantity?.toString() ?? "0";
                          }
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
            const SizedBox(
              height: 10,
            ),
            CommonLableWthTextField(
              lableName: "Good Qty",
              focusNode: goodQtyFocusNode,
              textController: goodQtyTextController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Good Quantity";
                }
                if (int.parse(value) <= 0) {
                  return "Can't Be Zero";
                }
                return null;
              },
              onChanged: (value) {
                var goodQty = value.isEmpty ? 0 : int.parse(value);
                badQtyTextController.text = "0";
                var badQty = badQtyTextController.text.isEmpty
                    ? 0
                    : int.parse(badQtyTextController.text);
                quantityTextController.text = (goodQty + badQty).toString();
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
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                quantityTextController.text = (goodQty + badQty).toString();
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
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "Save",
                style: textTheme.bodyMedium!.copyWith(
                  color: appTheme.white,
                ),
              ),
            ),
            // Expanded(
            //   child: BlocBuilder<GrnPOListBloc, GrnPOListState>(
            //     builder: (context, state) {
            //       if (state is GrnPOListLoading) {
            //         return const Center(
            //           child: CircularProgressIndicator(),
            //         );
            //       }
            //       if (state is GrnPOListSuccess) {
            //         return ListView.separated(
            //           itemBuilder: (context, index) {
            //             var data = state.grnPOList[index];
            //             return Container(
            //               padding: const EdgeInsets.all(8),
            //               decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 // color: index % 2 == 0
            //                 //     ? const Color.fromARGB(255, 115, 134, 240)
            //                 //     : const Color.fromARGB(255, 136, 152, 247),
            //                 borderRadius: BorderRadius.circular(8),
            //               ),
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       Flexible(
            //                         child: Text(
            //                           "${data.itemId}-${data.itemDescription ?? ""}",
            //                           style: textTheme.bodyMedium!.copyWith(
            //                             fontSize: 14,
            //                             color: appTheme.primary,
            //                           ),
            //                         ),
            //                       ),
            //                       ElevatedButton(
            //                         style: ElevatedButton.styleFrom().copyWith(
            //                           padding: const WidgetStatePropertyAll<
            //                               EdgeInsetsGeometry>(
            //                             EdgeInsets.symmetric(
            //                               horizontal: 10,
            //                               vertical: 5,
            //                             ),
            //                           ),
            //                           minimumSize:
            //                               WidgetStateProperty.all<Size>(
            //                             const Size(80, 30),
            //                           ),
            //                           backgroundColor: WidgetStatePropertyAll(
            //                             appTheme.tertiary,
            //                           ),
            //                         ),
            //                         onPressed: () {},
            //                         child: Row(
            //                           children: [
            //                             Text(
            //                               "Print ",
            //                               style: textTheme.bodyMedium!.copyWith(
            //                                 fontSize: 14,
            //                                 color: appTheme.white,
            //                               ),
            //                             ),
            //                             Icon(
            //                               Icons.qr_code,
            //                               color: appTheme.white,
            //                               size: 20,
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       Flexible(
            //                         child: Text(
            //                           data.jobOrderNo ?? "",
            //                           style: textTheme.bodyMedium!.copyWith(
            //                             fontSize: 14,
            //                             color: appTheme.primary,
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ],
            //               ),
            //             );
            //           },
            //           separatorBuilder: (context, index) {
            //             return const SizedBox(
            //               height: 10,
            //             );
            //           },
            //           itemCount: state.grnPOList.length,
            //         );
            //       }
            //       return Container();
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
