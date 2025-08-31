import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/batch_status_dialog.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/read_qr_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/core/utils/healper_functions.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/check_batch_status_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_25_screen/bloc/prod_transfer_batch_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/item_qr_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/rack_qr_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/widgets/split_qty_dialog_widget.dart';

class OpmC29Screen extends StatelessWidget {
  const OpmC29Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-29-SCREEN";
  static const String routePath = "/OPM-C-29-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ItemQrCubit()),
        BlocProvider(create: (context) => RackQrCubit()),
        BlocProvider(create: (context) => ProdTransferBatchBloc(getService())),
        BlocProvider(create: (context) => CheckBatchStatusBloc(getService())),
      ],
      child: OpmC29ScreenBody(fromName: fromName),
    );
  }
}

class OpmC29ScreenBody extends StatefulWidget {
  const OpmC29ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OpmC29ScreenBody> createState() => _OpmC29ScreenBodyState();
}

MobileScannerController? controller = MobileScannerController();

class _OpmC29ScreenBodyState extends State<OpmC29ScreenBody> {
  UserBatchQrData? itemQrData;

  List<String> rackQrData = [];
  late UserInfoModel loggedUser;
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;

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
                  content: const Text("Successfully Added..."),
                  backgroundColor: appTheme.primary,
                ),
              );
            }
            if (state is ProdTransferBatchError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error.toString()),
                  backgroundColor: Colors.red,
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
                  content: Text("Unable to Get Item QR Data"),
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
                  content: Text("Unable to Get Rack QR Data"),
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
        ),
      ],
      child: Scaffold(
        appBar: CommonAppBar(appBartitle: widget.fromName),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              // const UserDetailsWidget(),
              const SizedBox(height: 5),
              Row(
                children: [
                  BlocBuilder<ItemQrCubit, ItemQrState>(
                    builder: (context, state) {
                      if (state is ItemQrDataLoaded) {
                        return IconButton.filled(
                          icon: const Icon(Icons.manage_search_rounded),
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
                          context.read<ItemQrCubit>().setItemData(
                            itemQrData: data,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
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
                        color: appTheme.primary.withOpacity(0.2),
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
                              ),
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
                                    Text("Lot: ", style: textTheme.bodyMedium),
                                    const SizedBox(width: 5),
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
                                    Text("Qty: ", style: textTheme.bodyMedium),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        itemQrData?.goodQty.toString() ?? "",
                                        textAlign: TextAlign.right,
                                        style: textTheme.bodyMedium,
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
              const SizedBox(height: 15),
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
                        color: appTheme.primary.withOpacity(0.2),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Rack Id", style: textTheme.bodyMedium),
                              const SizedBox(width: 10),
                              Text(rackQrData[0], style: textTheme.bodyMedium),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child:
                        BlocBuilder<
                          ProdTransferBatchBloc,
                          ProdTransferBatchState
                        >(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () {
                                if (itemQrData != null &&
                                    rackQrData.isNotEmpty) {
                                  context.read<ProdTransferBatchBloc>().add(
                                    ProdTransferBatchNew(
                                      pTrnid: itemQrData?.lotno ?? "",
                                      userid: loggedUser.userId,
                                      rackId: rackQrData[0],
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                state is ProdTransferBatchLoading
                                    ? "Saving.."
                                    : "Save",
                                style: textTheme.bodyMedium!.copyWith(
                                  color: appTheme.white,
                                ),
                              ),
                            );
                          },
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
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
    AppModal.showCustomModal(
      context,
      content: SplitQtyDialog(
        blocContext: context,
        pTrnid: pTrnid,
        userid: userid,
        rackId: rackId,
      ),
    );
  }
}
