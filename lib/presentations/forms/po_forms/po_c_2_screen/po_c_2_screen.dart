import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/grn_jo_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/grn_po_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/grn_purchase_req_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/operation_unit_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_lable_wth_textfield.dart';
import 'package:pran_rfl_erp/common_widgets/custom_dropdown_search.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/operation_unit_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/po_forms/po_c_2_screen/bloc/grn_job_order_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/po_forms/po_c_2_screen/bloc/grn_org_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/po_forms/po_c_2_screen/bloc/grn_po_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/po_forms/po_c_2_screen/bloc/grn_purchase_req_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/po_forms/po_c_2_screen/bloc/grn_qr_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/print_grn_qr_screen/print_grn_qr_screen.dart';

class PoC2Screen extends StatelessWidget {
  const PoC2Screen({super.key, required this.fromName});
  static const String routeName = "PO-C-2-SCREEN";
  static const String routePath = "/PO-C-2-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OperationUnitBloc(getService())),
        BlocProvider(create: (context) => GrnOrgListBloc(getService())),
        BlocProvider(create: (context) => GrnPurchaseReqListBloc(getService())),
        BlocProvider(create: (context) => GrnJobOrderListBloc(getService())),
        BlocProvider(create: (context) => GrnPOListBloc(getService())),
        BlocProvider(create: (context) => GrnQrListBloc(getService())),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<OperationUnit>(),
        ),
        BlocProvider(create: (context) => VariableStateHandlerCubit<UserOrg>()),
        BlocProvider(
          create: (context) =>
              VariableStateHandlerCubit<GrnPurchaseReqNumber>(),
        ),
        BlocProvider(create: (context) => VariableStateHandlerCubit<GrnJO>()),
        BlocProvider(create: (context) => VariableStateHandlerCubit<GrnPO>()),
      ],
      child: POC2ScreenBody(fromName: fromName),
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
  final GlobalKey<FormState> _fromKey = GlobalKey();
  late UserInfoModel loggedUser;
  TextEditingController quantityTextController = TextEditingController();
  FocusNode quantityFocusNode = FocusNode();
  TextEditingController goodQtyTextController = TextEditingController();
  FocusNode goodQtyFocusNode = FocusNode();
  TextEditingController badQtyTextController = TextEditingController();
  FocusNode badQtyFocusNode = FocusNode();
  @override
  void initState() {
    context.read<OperationUnitBloc>().add(OperationUnitGet());

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
                        child:
                            BlocBuilder<OperationUnitBloc, OperationUnitState>(
                              builder: (context, state) {
                                return CustomDropdownSearch<OperationUnit>(
                                  hintText: "Select OU",
                                  enabled: state is OperationUnitSuccess
                                      ? true
                                      : false,
                                  value: context
                                      .watch<
                                        VariableStateHandlerCubit<OperationUnit>
                                      >()
                                      .state,
                                  items: state is OperationUnitSuccess
                                      ? state.operationUnit
                                      : [],
                                  onChanged: (value) {
                                    if (value != null) {
                                      context
                                          .read<
                                            VariableStateHandlerCubit<
                                              OperationUnit
                                            >
                                          >()
                                          .update(value);
                                      context
                                          .read<GrnPurchaseReqListBloc>()
                                          .add(
                                            GrnPurchaseReqListGet(
                                              orgId: value.organizationId ?? 0,
                                            ),
                                          );
                                      context.read<GrnOrgListBloc>().add(
                                        GrnOrgListGet(
                                          ouId: value.organizationId ?? 0,
                                        ),
                                      );
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please Select OU";
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: BlocBuilder<GrnOrgListBloc, GrnOrgListState>(
                          builder: (context, state) {
                            return CustomDropdownSearch<UserOrg>(
                              hintText: "Select Org",
                              enabled: state is GrnOrgListSuccess
                                  ? true
                                  : false,
                              value: context
                                  .watch<VariableStateHandlerCubit<UserOrg>>()
                                  .state,
                              items: state is GrnOrgListSuccess
                                  ? state.grnOrg
                                  : [],
                              onChanged: (value) {
                                if (value != null) {
                                  context
                                      .read<
                                        VariableStateHandlerCubit<UserOrg>
                                      >()
                                      .update(value);
                                  context.read<GrnQrListBloc>().add(
                                    GrnQrListGet(userId: loggedUser.userId),
                                  );
                                }
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
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child:
                            BlocBuilder<
                              GrnPurchaseReqListBloc,
                              GrnPurchaseReqListState
                            >(
                              builder: (context, state) {
                                return CustomDropdownSearch<
                                  GrnPurchaseReqNumber
                                >(
                                  hintText: "Select PR",
                                  enabled: state is GrnPurchaseReqListSuccess
                                      ? true
                                      : false,
                                  value: context
                                      .watch<
                                        VariableStateHandlerCubit<
                                          GrnPurchaseReqNumber
                                        >
                                      >()
                                      .state,
                                  items: state is GrnPurchaseReqListSuccess
                                      ? state.purchaseReqNumber
                                      : [],
                                  onChanged: (value) {
                                    if (value != null) {
                                      context
                                          .read<
                                            VariableStateHandlerCubit<
                                              GrnPurchaseReqNumber
                                            >
                                          >()
                                          .update(value);
                                      context.read<GrnJobOrderListBloc>().add(
                                        GrnJobOrderListGet(
                                          reqNo: value.purchaseReqNumber ?? "",
                                        ),
                                      );
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please Select PR";
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child:
                            BlocBuilder<
                              GrnJobOrderListBloc,
                              GrnJobOrderListState
                            >(
                              builder: (context, state) {
                                return CustomDropdownSearch<GrnJO>(
                                  hintText: "Select JO",
                                  enabled: state is GrnJobOrderListSuccess
                                      ? true
                                      : false,
                                  items: state is GrnJobOrderListSuccess
                                      ? state.grnJOList
                                      : [],
                                  value: context
                                      .watch<VariableStateHandlerCubit<GrnJO>>()
                                      .state,
                                  onChanged: (value) {
                                    if (value != null) {
                                      context
                                          .read<
                                            VariableStateHandlerCubit<GrnJO>
                                          >()
                                          .update(value);
                                      context.read<GrnPOListBloc>().add(
                                        GrnPOListGet(
                                          jobOrderNo: value.jobOrderNo ?? "",
                                        ),
                                      );
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please Select JO";
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
                        child: BlocBuilder<GrnPOListBloc, GrnPOListState>(
                          builder: (context, state) {
                            return CustomDropdownSearch<GrnPO>(
                              hintText: "Select PO",
                              enabled: state is GrnPOListSuccess ? true : false,
                              items: state is GrnPOListSuccess
                                  ? state.grnPOList
                                  : [],
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
                              validator: (value) {
                                if (value == null) {
                                  return "Please Select PO";
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
                  const SizedBox(height: 10),
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
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Quantity";
                      }
                      return null;
                    },
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // BlocBuilder<GrnQrSaveBloc, GrnQrSaveState>(
            //   builder: (context, state) {
            //     return ElevatedButton(
            //       onPressed: () {
            //         if (_fromKey.currentState!.validate()) {
            //           var orgId = context
            //                   .read<VariableStateHandlerCubit<UserOrg>>()
            //                   .state!
            //                   .organizationId ??
            //               0;
            //           var itemId = context
            //                   .read<VariableStateHandlerCubit<GrnPO>>()
            //                   .state!
            //                   .itemId ??
            //               0;
            //           var jobOrderNo = context
            //                   .read<VariableStateHandlerCubit<GrnJO>>()
            //                   .state!
            //                   .jobOrderNo ??
            //               "";
            //           var prId = context
            //                   .read<
            //                       VariableStateHandlerCubit<
            //                           GrnPurchaseReqNumber>>()
            //                   .state!
            //                   .purchaseReqNumber ??
            //               "";
            //           context.read<GrnQrSaveBloc>().add(GrnQrSave(
            //               userId: loggedUser.userId,
            //               orgId: orgId,
            //               itemId: itemId,
            //               goodQty: num.parse(goodQtyTextController.text),
            //               qty: num.parse(quantityTextController.text),
            //               badQty: num.parse(badQtyTextController.text),
            //               jobOrderNo: jobOrderNo,
            //               prId: prId));
            //         }
            //       },
            //       child: Text(
            //         state is GrnQrSaveLoading ? "Saving.." : "Save",
            //         style: textTheme.bodyMedium!.copyWith(
            //           color: appTheme.white,
            //         ),
            //       ),
            //     );
            //   },
            // ),
            // Expanded(
            //   child: BlocBuilder<GrnQrListBloc, GrnQrListState>(
            //     builder: (context, state) {
            //       if (state is GrnQrListLoading) {
            //         return const Center(child: CircularProgressIndicator());
            //       }
            //       if (state is GrnQrListSuccess) {
            //         return ListView.separated(
            //           itemBuilder: (context, index) {
            //             var data = state.grnQr[index];
            //             return Container(
            //               padding: const EdgeInsets.all(8),
            //               decoration: BoxDecoration(
            //                 color: const Color.fromARGB(255, 209, 222, 245),
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
            //                       Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             "Item Name",
            //                             style: textTheme.bodyMedium!.copyWith(
            //                               fontSize: 15,
            //                               color: appTheme.primary,
            //                             ),
            //                           ),
            //                           Text(
            //                             data.itemName.toString(),
            //                             style: textTheme.bodySmall!.copyWith(
            //                               fontSize: 10,
            //                               fontWeight: FontWeight.bold,
            //                               color: appTheme.primary,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       const SizedBox(width: 10),
            //                       Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             "Pr No",
            //                             style: textTheme.bodyMedium!.copyWith(
            //                               fontSize: 15,
            //                               color: appTheme.primary,
            //                             ),
            //                           ),
            //                           Text(
            //                             data.jobOrderNo ?? "",
            //                             style: textTheme.bodySmall!.copyWith(
            //                               fontSize: 10,
            //                               fontWeight: FontWeight.bold,
            //                               color: appTheme.primary,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ],
            //                   ),
            //                   Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             "Job Order",
            //                             style: textTheme.bodyMedium!.copyWith(
            //                               fontSize: 15,
            //                               color: appTheme.primary,
            //                             ),
            //                           ),
            //                           Text(
            //                             data.batchId.toString(),
            //                             style: textTheme.bodySmall!.copyWith(
            //                               fontSize: 10,
            //                               fontWeight: FontWeight.bold,
            //                               color: appTheme.primary,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       const SizedBox(width: 10),
            //                       Column(
            //                         crossAxisAlignment: CrossAxisAlignment.end,
            //                         children: [
            //                           Text(
            //                             "Organization",
            //                             style: textTheme.bodyMedium!.copyWith(
            //                               fontSize: 15,
            //                               color: appTheme.primary,
            //                             ),
            //                           ),
            //                           Text(
            //                             "${data.organizationCode}-${data.organizationName}",
            //                             style: textTheme.bodySmall!.copyWith(
            //                               fontSize: 10,
            //                               fontWeight: FontWeight.bold,
            //                               color: appTheme.primary,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ],
            //                   ),
            //                   Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             "Trn Id",
            //                             style: textTheme.bodyMedium!.copyWith(
            //                               fontSize: 15,
            //                               color: appTheme.primary,
            //                             ),
            //                           ),
            //                           Text(
            //                             data.trnId ?? "",
            //                             style: textTheme.bodySmall!.copyWith(
            //                               fontSize: 10,
            //                               fontWeight: FontWeight.bold,
            //                               color: appTheme.primary,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       ElevatedButton(
            //                         style: ElevatedButton.styleFrom().copyWith(
            //                           padding:
            //                               const WidgetStatePropertyAll<
            //                                 EdgeInsetsGeometry
            //                               >(
            //                                 EdgeInsets.symmetric(
            //                                   horizontal: 10,
            //                                   vertical: 5,
            //                                 ),
            //                               ),
            //                           minimumSize:
            //                               WidgetStateProperty.all<Size>(
            //                                 const Size(80, 30),
            //                               ),
            //                           backgroundColor: WidgetStatePropertyAll(
            //                             appTheme.tertiary,
            //                           ),
            //                         ),
            //                         onPressed: () {
            //                           UserOrg userOrg = context
            //                               .read<
            //                                 VariableStateHandlerCubit<UserOrg>
            //                               >()
            //                               .state!;
            //                           context.pushNamed(
            //                             PrintGrnQrScreen.routeName,
            //                             extra: {
            //                               "grnQrData": data,
            //                               "grnQrPrintBlocCtx": context,
            //                               "userOrg": userOrg,
            //                             },
            //                           );
            //                         },
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
            //                 ],
            //               ),
            //             );
            //           },
            //           separatorBuilder: (context, index) {
            //             return const SizedBox(height: 10);
            //           },
            //           itemCount: state.grnQr.length,
            //         );
            //       }
            //       return Container();
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
