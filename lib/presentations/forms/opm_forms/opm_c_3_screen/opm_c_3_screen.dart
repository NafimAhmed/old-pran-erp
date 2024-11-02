import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pran_rfl_erp/app_data/entities/transfer_batch_data_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/read_qr_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/core/utils/healper_functions.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/bloc/rack_transact_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/bloc/transfer_batch_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/bloc/transfered_batch_data_bloc.dart';

import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/cubit/item_qr_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/cubit/rack_qr_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/widgets/split_qty_dialog_widget.dart';

class OpmC3Screen extends StatelessWidget {
  const OpmC3Screen({super.key});
  static const String routeName = "OPM-C-3-SCREEN";
  static const String routePath = "/OPM-C-3-SCREEN";
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
          create: (context) => TransferBatchBloc(getService()),
        ),
        BlocProvider(
          create: (context) => TransferedBatchDataBloc(getService())
            ..add(TransferBatchDataGet()),
        ),
        BlocProvider(
          create: (context) => RackTransactBloc(getService()),
        ),
      ],
      child: const TransferScreenBody(),
    );
  }
}

class TransferScreenBody extends StatefulWidget {
  const TransferScreenBody({super.key});

  @override
  State<TransferScreenBody> createState() => _TransferScreenBodyState();
}

MobileScannerController? controller = MobileScannerController();

class _TransferScreenBodyState extends State<TransferScreenBody> {
  List<String> itemQrData = [];

  List<String> rackQrData = [];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TransferBatchBloc, TransferBatchState>(
          listener: (context, state) {
            if (state is TransferBatchSuccess) {
              context.read<ItemQrCubit>().resetItemData();
              context.read<RackQrCubit>().resetRackData();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: const Text(
                      "Successfully Added...",
                    ),
                    backgroundColor: appTheme.primary),
              );
              context
                  .read<TransferedBatchDataBloc>()
                  .add(TransferBatchDataGet());
            }
            if (state is TransferBatchError) {
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
        BlocListener<RackTransactBloc, RackTransactState>(
          listener: (context, state) {
            if (state is RackTransactSuccess) {
              context
                  .read<TransferedBatchDataBloc>()
                  .add(TransferBatchDataGet());
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
      ],
      child: Scaffold(
        appBar: const CommonAppBar(appBartitle: "Transfer"),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              const UserDetailsWidget(),
              const SizedBox(
                height: 15,
              ),
              ReadOrWidget(
                qrType: "Item QR",
                onPressed: () async {
                  var data = await buildScanner(context, controller);

                  // context.read<QrCodeBloc>().add(
                  //       QrCodeDataGet(
                  //           sourceQrData: data, destinationQrData: ""),
                  //     );
                  if (context.mounted) {
                    context.read<ItemQrCubit>().setItemData(itemQrData: data);
                  }
                },
              ),
              const SizedBox(
                width: 10,
              ),
              BlocBuilder<ItemQrCubit, ItemQrState>(
                builder: (context, state) {
                  if (state is ItemQrInitial) {
                    itemQrData.clear();
                  }
                  if (state is ItemQrDataLoaded) {
                    itemQrData = state.itemQRDatalist;
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
                                "Batch Id",
                                style: textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                itemQrData[0],
                                style: textTheme.bodyMedium,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Item Id",
                                style: textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                itemQrData[1],
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
              ReadOrWidget(
                qrType: "Rack QR",
                onPressed: () async {
                  try {
                    var data = await buildScanner(context, controller);
                    if (context.mounted) {
                      context.read<RackQrCubit>().setrackData(rackQrData: data);
                    }
                  } catch (e) {
                    log('Error');
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (itemQrData.isNotEmpty && rackQrData.isNotEmpty) {
                        _openSplitDialog(
                          context: context,
                          batchId: itemQrData[0],
                          itemId: itemQrData[1],
                          rackId: rackQrData[0],
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
                  BlocSelector<TransferBatchBloc, TransferBatchState, String>(
                    selector: (state) {
                      return state is TransferBatchLoading
                          ? state.splitFlag == "0"
                              ? "Saving.."
                              : "Save"
                          : "Save";
                    },
                    builder: (context, selectorstate) {
                      return ElevatedButton(
                        onPressed: () {
                          if (itemQrData.isNotEmpty && rackQrData.isNotEmpty) {
                            context.read<TransferBatchBloc>().add(
                                  TransferBatch(
                                    batchId: itemQrData[0],
                                    itemId: itemQrData[1],
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
                  )
                  // BlocBuilder<TransferBatchBloc, TransferBatchState>(
                  //   builder: (context, state) {
                  //     return ElevatedButton(
                  //       onPressed: () {
                  //         if (itemQrData.isNotEmpty && rackQrData.isNotEmpty) {
                  //           context.read<TransferBatchBloc>().add(
                  //                 TransferBatch(
                  //                   batchId: itemQrData[0],
                  //                   itemId: itemQrData[1],
                  //                   rackId: rackQrData[0],
                  //                   rqty: "0",
                  //                   split: "0",
                  //                 ),
                  //               );
                  //         }
                  //       },
                  //       child: Text(
                  //         state is TransferBatchLoading ? "Saving..." : "Save",
                  //         style: textTheme.bodyMedium!.copyWith(
                  //           color: appTheme.white,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: BlocBuilder<TransferedBatchDataBloc,
                    TransferedBatchDataState>(
                  builder: (context, state) {
                    if (state is TransferedBatchDataLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is TransferedBatchDataSuccess) {
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
                                            .read<TransferedBatchDataBloc>()
                                            .add(
                                              TransferBatchDataDelete(
                                                trnsfid: transferBatchData
                                                        .transactId ??
                                                    0,
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
                                              transferBatchData.batchNo ?? "",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    BlocBuilder<RackTransactBloc,
                                        RackTransactState>(
                                      builder: (context, state) {
                                        return ElevatedButton(
                                          onPressed: state
                                                  is RackTransactLoading
                                              ? () {}
                                              : () {
                                                  context
                                                      .read<RackTransactBloc>()
                                                      .add(
                                                        RackTransact(
                                                          transactId:
                                                              transferBatchData
                                                                      .transactId ??
                                                                  0,
                                                        ),
                                                      );
                                                },
                                          child: Text(
                                            state is RackTransactLoading
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
      ),
    );
  }

  void _openSplitDialog({
    required BuildContext context,
    required String batchId,
    required String itemId,
    required String rackId,
  }) async {
    AppModal.showCustomModal(context,
        content: SplitQtyDialog(
          blocContext: context,
          itemId: itemId,
          batchId: batchId,
          rackId: rackId,
        ));
  }
}





// class DeleteReviewDialog extends StatelessWidget {
//   const DeleteReviewDialog({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 5),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           GestureDetector(
//             onTap: () {
//               context.pop();
//             },
//             child: const Align(
//               alignment: Alignment.topRight,
//               child: Icon(
//                 Icons.close,
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             "Are you sure you want to delete this review?",
//             textAlign: TextAlign.center,
//             style: textTheme.bodyMedium!.copyWith(
//               fontWeight: FontWeight.bold,
//               color: const Color.fromRGBO(30, 30, 30, 1),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Container(
//             width: 137,
//             padding: const EdgeInsets.symmetric(
//               horizontal: 10,
//               vertical: 10,
//             ),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(
//                 20,
//               ),
//               color: const Color.fromRGBO(196, 66, 23, 1),
//             ),
//             child: Center(
//               child: Text(
//                 "Delete",
//                 style: textTheme.bodyMedium!.copyWith(
//                   color: appTheme.white,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
