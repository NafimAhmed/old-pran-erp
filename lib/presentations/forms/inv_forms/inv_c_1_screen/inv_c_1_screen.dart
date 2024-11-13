import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pran_rfl_erp/app_data/entities/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/read_qr_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/core/utils/healper_functions.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_1_screen/bloc/inter_org_transfer_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_1_screen/inter_org_split_qty_dialog_widget.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/cubit/item_qr_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/cubit/rack_qr_cubit.dart';

class InvC1Screen extends StatelessWidget {
  const InvC1Screen({super.key});
  static const String routeName = "INV-C-1-SCREEN";
  static const String routePath = "/INV-C-1-SCREEN";
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InterOrgTransferBloc(getService()),
        ),
        BlocProvider(
          create: (context) => ItemQrCubit(),
        ),
        BlocProvider(
          create: (context) => RackQrCubit(),
        ),
      ],
      child: const InterOrgTransferBody(),
    );
  }
}

class InterOrgTransferBody extends StatefulWidget {
  const InterOrgTransferBody({super.key});

  @override
  State<InterOrgTransferBody> createState() => _InterOrgTransferBodyState();
}

class _InterOrgTransferBodyState extends State<InterOrgTransferBody> {
  MobileScannerController? controller = MobileScannerController();
  UserBatchQrData? itemQrData;

  List<String> rackQrData = [];
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // BlocListener<TransferBatchBloc, TransferBatchState>(
        //   listener: (context, state) {
        //     if (state is TransferBatchSuccess) {
        //       context.read<ItemQrCubit>().resetItemData();
        //       context.read<RackQrCubit>().resetRackData();

        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(
        //             content: const Text(
        //               "Successfully Added...",
        //             ),
        //             backgroundColor: appTheme.primary),
        //       );
        //       context
        //           .read<TransferedBatchDataBloc>()
        //           .add(TransferBatchDataGet());
        //     }
        //     if (state is TransferBatchError) {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(
        //           content: Text(
        //             state.error.toString(),
        //           ),
        //           backgroundColor: Colors.red,
        //         ),
        //       );
        //     }
        //   },
        // ),

        BlocListener<ItemQrCubit, ItemQrState>(
          listener: (context, state) {
            if (state is ItemQrDataError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Unable to Get Item QR Data",
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<RackQrCubit, RackQrState>(
          listener: (context, state) {
            if (state is RackQrDataError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Unable to Get Rack QR Data",
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: const CommonAppBar(appBartitle: "Inter Org Transfer"),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const UserDetailsWidget(),
              const SizedBox(
                height: 10,
              ),
              ReadQrWidget(
                qrType: "Item QR",
                onPressed: () async {
                  var data = await buildScanner(context, controller);
                  if (context.mounted) {
                    context.read<ItemQrCubit>().setItemData(itemQrData: data);
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<ItemQrCubit, ItemQrState>(
                builder: (context, state) {
                  if (state is ItemQrInitial) {
                    itemQrData = null;
                  }
                  if (state is ItemQrDataLoaded) {
                    itemQrData = state.userBatchQrData;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: appTheme.primary.withOpacity(
                          0.2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itemQrData?.itemname ?? "",
                            style: textTheme.bodyMedium,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                itemQrData?.custname ?? "",
                                style: textTheme.bodyMedium,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Lot: ",
                                      style: textTheme.bodyMedium,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Text(
                                        itemQrData?.lotno ?? "",
                                        style: textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Qty: ",
                                      style: textTheme.bodyMedium,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Text(
                                        itemQrData?.goodQty.toString() ?? "",
                                        textAlign: TextAlign.right,
                                        style: textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
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
              ReadQrWidget(
                qrType: "Rack QR",
                onPressed: () async {
                  var data = await buildScanner(context, controller);
                  if (context.mounted) {
                    context.read<RackQrCubit>().setrackData(rackQrData: data);
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<RackQrCubit, RackQrState>(
                builder: (context, state) {
                  if (state is RackQrInitial) {
                    rackQrData.clear();
                  }
                  if (state is RackQrDataLoaded) {
                    rackQrData = state.rackQRDatalist;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: appTheme.primary.withOpacity(
                          0.2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rack Id",
                                style: textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                rackQrData[0],
                                style: textTheme.bodyMedium,
                              )
                            ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (itemQrData != null && rackQrData.isNotEmpty) {
                        var user = context.read<LoggedUserInfoCubit>().state;
                        _openSplitDialog(
                          context: context,
                          batchId: itemQrData?.batchNo ?? "", //to be removed
                          itemId: itemQrData?.itemname ?? "", // to be removed
                          rackId: rackQrData[0],
                          userid: user!.userId,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please Scan Both Qr Code",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Split Qty",
                      style: textTheme.bodyMedium!.copyWith(
                        color: appTheme.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (itemQrData != null && rackQrData.isNotEmpty) {
                        var user = context.read<LoggedUserInfoCubit>().state;
                        context.read<InterOrgTransferBloc>().add(
                              InterOrgTransfer(
                                  userid: user!.userId,
                                  trackid: rackQrData[0],
                                  rqty: "0",
                                  batchid:
                                      itemQrData?.batchNo ?? "", //to be removed
                                  itemid: itemQrData?.itemname ??
                                      "", // to be removed
                                  split: "0"),
                            );
                      }
                    },
                    child: Text(
                      "Save",
                      style: textTheme.bodyMedium!.copyWith(
                        color: appTheme.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _openSplitDialog({
    required BuildContext context,
    required String batchId,
    required String itemId,
    required String rackId,
    required String userid,
  }) async {
    AppModal.showCustomModal(context,
        content: InterOrgSplitQtyDialog(
          blocContext: context,
          itemId: itemId,
          batchId: batchId,
          rackId: rackId,
          userid: userid,
        ));
  }
}
