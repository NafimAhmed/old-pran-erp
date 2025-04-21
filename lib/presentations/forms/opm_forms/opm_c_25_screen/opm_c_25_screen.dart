import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pran_rfl_erp/app_data/models/transfer_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/batch_status_dialog.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/read_qr_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/core/utils/healper_functions.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/check_batch_status_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_25_screen/bloc/prod_rack_transact_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_25_screen/bloc/prod_transfer_batch_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_25_screen/bloc/prod_transfered_batch_data_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/cubit/item_qr_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/cubit/rack_qr_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/widgets/split_qty_dialog_widget.dart';

class OpmC25Screen extends StatelessWidget {
  const OpmC25Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-25-SCREEN";
  static const String routePath = "/OPM-C-25-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ItemQrCubit(),
        ),
        BlocProvider(
          create: (context) => RackQrCubit(),
        ),
        BlocProvider(
          create: (context) => ProdTransferBatchBloc(getService()),
        ),
        BlocProvider(
          create: (context) => ProdTransferedBatchDataBloc(getService()),
        ),
        BlocProvider(
          create: (context) => ProdRackTransactBloc(getService()),
        ),
        BlocProvider(
          create: (context) => CheckBatchStatusBloc(getService()),
        ),
      ],
      child: OpmC25ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class OpmC25ScreenBody extends StatefulWidget {
  const OpmC25ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OpmC25ScreenBody> createState() => _OpmC25ScreenBodyState();
}

MobileScannerController? controller = MobileScannerController();

class _OpmC25ScreenBodyState extends State<OpmC25ScreenBody> {
  UserBatchQrData? itemQrData;

  List<String> rackQrData = [];
  late UserInfoModel loggedUser;
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context.read<ProdTransferedBatchDataBloc>().add(
          ProdTransferBatchDataGet(userId: loggedUser.userId),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProdTransferBatchBloc, ProdTransferBatchState>(
          listener: (context, state) {
            if (state is ProdTransferBatchSuccess) {
              context.read<ItemQrCubit>().resetItemData();
              context.read<RackQrCubit>().resetRackData();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: const Text(
                      "Successfully Added...",
                    ),
                    backgroundColor: appTheme.primary),
              );
              context.read<ProdTransferedBatchDataBloc>().add(
                    ProdTransferBatchDataGet(
                      userId: loggedUser.userId,
                    ),
                  );
            }
            if (state is ProdTransferBatchError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.error.toString(),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<ProdRackTransactBloc, ProdRackTransactState>(
          listener: (context, state) {
            if (state is ProdRackTransactSuccess) {
              context.read<ProdTransferedBatchDataBloc>().add(
                    ProdTransferBatchDataGet(
                      userId: loggedUser.userId,
                    ),
                  );
            }
            if (state is ProdRackTransactError) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.errorSnackber(
                  message: state.error.toString(),
                ),
              );
            }
          },
        ),
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
        BlocListener<CheckBatchStatusBloc, CheckBatchStatusState>(
          listener: (context, state) {
            if (state is CheckBatchStatusSuccess) {
              var data = state.batchStatus;
              AppModal.showCustomModal(
                context,
                content: BatchStatusDialog(data: data),
              );
            }
          },
        )
      ],
      child: Scaffold(
        appBar: CommonAppBar(appBartitle: widget.fromName),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            children: [
              // const UserDetailsWidget(),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  BlocBuilder<ItemQrCubit, ItemQrState>(
                    builder: (context, state) {
                      if (state is ItemQrDataLoaded) {
                        return IconButton.filled(
                          icon: const Icon(
                            Icons.manage_search_rounded,
                          ),
                          onPressed: () {
                            context.read<CheckBatchStatusBloc>().add(
                                  CheckBatchStatus(
                                    lotNo: state.userBatchQrData.lotno ?? "",
                                    userId: loggedUser.userId,
                                  ),
                                );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  Expanded(
                    child: ReadQrWidget(
                      qrType: "Item QR",
                      onPressed: () async {
                        var data = await buildScanner(context, controller);
                        if (context.mounted) {
                          context
                              .read<ItemQrCubit>()
                              .setItemData(itemQrData: data);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
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
                        borderRadius: BorderRadius.circular(8),
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
                                flex: 2,
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
                height: 15,
              ),
              ReadQrWidget(
                qrType: "Rack QR",
                onPressed: () async {
                  try {
                    var data = await buildScanner(context, controller);
                    if (context.mounted) {
                      context.read<RackQrCubit>().setrackData(rackQrData: data);
                    }
                  } catch (e) {
                    log(e.toString());
                  }
                },
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
                        borderRadius: BorderRadius.circular(8),
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
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Flexible(
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       if (itemQrData != null && rackQrData.isNotEmpty) {
                  //         _openSplitDialog(
                  //           context: context,
                  //           pTrnid: itemQrData?.lotno ?? "",
                  //           userid: loggedUser.userId,
                  //           rackId: rackQrData[0],
                  //         );
                  //       } else {
                  //         ScaffoldMessenger.of(context).showSnackBar(
                  //           const SnackBar(
                  //             content: Text(
                  //               "Please Scan Both Qr Code",
                  //             ),
                  //             backgroundColor: Colors.red,
                  //           ),
                  //         );
                  //       }
                  //     },
                  //     child: Text(
                  //       "Split Qty",
                  //       style: textTheme.bodyMedium!.copyWith(
                  //         color: appTheme.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  Flexible(
                    child: BlocSelector<ProdTransferBatchBloc,
                        ProdTransferBatchState, String>(
                      selector: (state) {
                        return state is ProdTransferBatchLoading
                            ? state.splitFlag == "0"
                                ? "Saving.."
                                : "Save"
                            : "Save";
                      },
                      builder: (context, selectorstate) {
                        return ElevatedButton(
                          onPressed: () {
                            if (itemQrData != null && rackQrData.isNotEmpty) {
                              context.read<ProdTransferBatchBloc>().add(
                                    ProdTransferBatch(
                                      pTrnid: itemQrData?.lotno ?? "",
                                      userid: loggedUser.userId,
                                      rackId: rackQrData[0],
                                      rqty: "0",
                                      split: "0",
                                    ),
                                  );
                            }
                          },
                          child: Text(
                            selectorstate,
                            style: textTheme.bodyMedium!.copyWith(
                              color: appTheme.white,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: BlocBuilder<ProdTransferedBatchDataBloc,
                    ProdTransferedBatchDataState>(
                  builder: (context, state) {
                    if (state is ProdTransferedBatchDataLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is ProdTransferedBatchDataSuccess) {
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          TransferBatchData transferBatchData =
                              state.transferBatchDataList[index];
                          return Container(
                            padding: const EdgeInsets.all(
                              5,
                            ),
                            decoration: BoxDecoration(
                              color: appTheme.primary.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton.filled(
                                      style: IconButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 151, 14, 5),
                                      ),
                                      onPressed: () {
                                        context
                                            .read<ProdTransferedBatchDataBloc>()
                                            .add(
                                              ProdTransferBatchDataDelete(
                                                trnsfid: transferBatchData
                                                        .transactId ??
                                                    0,
                                                userId: loggedUser.userId,
                                              ),
                                            );
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: appTheme.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Batch No:",
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Text(
                                              transferBatchData.batchno ?? "",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    BlocBuilder<ProdRackTransactBloc,
                                        ProdRackTransactState>(
                                      builder: (context, state) {
                                        return ElevatedButton(
                                          onPressed: state
                                                  is ProdRackTransactLoading
                                              ? () {}
                                              : () {
                                                  context
                                                      .read<
                                                          ProdRackTransactBloc>()
                                                      .add(
                                                        ProdRackTransact(
                                                          transactId:
                                                              transferBatchData
                                                                      .transactId ??
                                                                  0,
                                                          userId:
                                                              loggedUser.userId,
                                                        ),
                                                      );
                                                },
                                          child: Text(
                                            state is ProdRackTransactLoading
                                                ? state.transactId ==
                                                        transferBatchData
                                                            .transactId
                                                    ? "Transacting..."
                                                    : "Transact"
                                                : "Transact",
                                            style:
                                                textTheme.bodyMedium!.copyWith(
                                              color: appTheme.white,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: appTheme.primary.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: appTheme.primary,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Item Name:",
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                                transferBatchData.itemName ??
                                                    ""),
                                          )
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Item Code:",
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                                transferBatchData.itemCode ??
                                                    ""),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Originar Qty:",
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              transferBatchData.originalQty
                                                  .toString(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Total Qty:",
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              transferBatchData.totalQty
                                                  .toString(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: appTheme.primary.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: appTheme.primary,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Rack Org Name:",
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                                transferBatchData.rackOrgName ??
                                                    ""),
                                          )
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Rack Locator:",
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                                transferBatchData.rackLocator ??
                                                    ""),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemCount: state.transferBatchDataList.length,
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const UserDetailsWidget(),
      ),
    );
  }

  void _openSplitDialog({
    required BuildContext context,
    required String pTrnid,
    required String userid,
    required String rackId,
  }) async {
    AppModal.showCustomModal(context,
        content: SplitQtyDialog(
          blocContext: context,
          pTrnid: pTrnid,
          userid: userid,
          rackId: rackId,
        ));
  }
}
