import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pran_rfl_erp/app_data/models/lot_trn_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_dialog_header.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/read_qr_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/core/utils/healper_functions.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/check_batch_status_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_1_screen/bloc/iot_trn_data_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_1_screen/bloc/lot_trn_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_1_screen/bloc/inter_org_transfer_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/cubit/item_qr_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/cubit/rack_qr_cubit.dart';

class InvC1Screen extends StatelessWidget {
  const InvC1Screen({super.key, required this.fromName});
  static const String routeName = "INV-C-1-SCREEN";
  static const String routePath = "/INV-C-1-SCREEN";

  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InterOrgTransferBloc(getService()),
        ),
        BlocProvider(
          create: (context) => LotTrnBloc(getService()),
        ),
        BlocProvider(
          create: (context) => IotTrnDataBloc(getService()),
        ),
        BlocProvider(
          create: (context) => CheckBatchStatusBloc(getService()),
        ),
        BlocProvider(
          create: (context) => ItemQrCubit(),
        ),
        BlocProvider(
          create: (context) => RackQrCubit(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<LotTrnData>(),
        ),
      ],
      child: InterOrgTransferBody(
        fromName: fromName,
      ),
    );
  }
}

class InterOrgTransferBody extends StatefulWidget {
  const InterOrgTransferBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<InterOrgTransferBody> createState() => _InterOrgTransferBodyState();
}

class _InterOrgTransferBodyState extends State<InterOrgTransferBody> {
  MobileScannerController? controller = MobileScannerController();
  UserBatchQrData? itemQrData;
  List<String> rackQrData = [];
  late UserInfoModel loggedUser;

  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context.read<IotTrnDataBloc>().add(
          GetIotTrnData(
            userId: loggedUser.userId,
          ),
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<InterOrgTransferBloc, InterOrgTransferState>(
          listener: (context, state) {
            if (state is InterOrgTransferSuccess) {
              context.read<ItemQrCubit>().resetItemData();
              context.read<RackQrCubit>().resetRackData();
              context.read<VariableStateHandlerCubit<LotTrnData>>().reset();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: const Text(
                      "Successfully Added...",
                    ),
                    backgroundColor: appTheme.primary),
              );
              context.read<IotTrnDataBloc>().add(
                    GetIotTrnData(
                      userId: loggedUser.userId,
                    ),
                  );
            }
            if (state is InterOrgTransferError) {
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
              AppModal.showCustomModal(
                context,
                content: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CommonDialogHeader(title: "Batch Status"),
                      Row(
                        children: [
                          const Text("Batch Status"),
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.right,
                              state.batchStatus.batchStatus ?? "",
                              style: textTheme.bodyMedium!.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Batch No"),
                                Expanded(
                                  child: Text(
                                    textAlign: TextAlign.right,
                                    state.batchStatus.batchNo ?? "",
                                    style: textTheme.bodyMedium!.copyWith(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("ORG"),
                                Expanded(
                                  child: Text(
                                    textAlign: TextAlign.right,
                                    state.batchStatus.organizationCode ?? "",
                                    style: textTheme.bodyMedium!.copyWith(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          },
        )
      ],
      child: Scaffold(
        appBar: CommonAppBar(appBartitle: widget.fromName),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
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
                height: 10,
              ),
              BlocConsumer<ItemQrCubit, ItemQrState>(
                listener: (context, state) {
                  if (state is ItemQrInitial) {
                    context.read<LotTrnBloc>().add(
                          RestLotTrnData(),
                        );
                  }
                },
                builder: (context, state) {
                  if (state is ItemQrInitial) {
                    itemQrData = null;
                  }
                  if (state is ItemQrDataLoaded) {
                    itemQrData = state.userBatchQrData;
                    context.read<LotTrnBloc>().add(
                          GetLotTrnData(
                            userId: loggedUser.userId,
                            racklocator: itemQrData?.lotno ?? "",
                          ),
                        );
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
              Expanded(
                child: BlocBuilder<LotTrnBloc, LotTrnState>(
                  builder: (context, state) {
                    if (state is LotTrnLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is LotTrnSuccess) {
                      if (state.lotTrnDataList.isNotEmpty) {
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            var data = state.lotTrnDataList[index];
                            var selectedData = context
                                .watch<VariableStateHandlerCubit<LotTrnData>>()
                                .state;
                            return BlocBuilder<RackQrCubit, RackQrState>(
                              builder: (context, state) {
                                if (state is RackQrDataLoaded) {
                                  rackQrData = state.rackQRDatalist;
                                }
                                // if (state is RackQrInitial) {
                                //   rackQrData = [];
                                // }
                                return IotTrnWidget(
                                  loggedUser: loggedUser,
                                  iotTrnData: data,
                                  selectedRack: selectedData != null
                                      ? selectedData.trnid == data.trnid
                                          ? rackQrData[0]
                                          : null
                                      : null,
                                  onQrPressed: () async {
                                    var qrData =
                                        await buildScanner(context, controller);
                                    if (context.mounted) {
                                      context
                                          .read<RackQrCubit>()
                                          .setrackData(rackQrData: qrData);
                                      context
                                          .read<
                                              VariableStateHandlerCubit<
                                                  LotTrnData>>()
                                          .update(data);
                                    }
                                  },
                                );
                              },
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemCount: state.lotTrnDataList.length,
                        );
                      } else {
                        return Center(
                          child: Text(
                            "No Stock Found",
                            style: textTheme.bodyMedium!.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: const UserDetailsWidget(),
      ),
    );
  }

  // void _openSplitDialog({
  //   required BuildContext context,
  //   required String batchId,
  //   required String itemId,
  //   required String rackId,
  //   required String userid,
  // }) async {
  //   AppModal.showCustomModal(context,
  //       content: InterOrgSplitQtyDialog(
  //         blocContext: context,
  //         itemId: itemId,
  //         batchId: batchId,
  //         rackId: rackId,
  //         userid: userid,
  //       ));
  // }
}

class IotTrnWidget extends StatefulWidget {
  const IotTrnWidget({
    super.key,
    required this.iotTrnData,
    this.selectedRack,
    this.onQrPressed,
    this.onTrnsPressed,
    required this.loggedUser,
  });
  final LotTrnData iotTrnData;
  final String? selectedRack;
  final UserInfoModel loggedUser;
  final void Function()? onQrPressed;
  final void Function()? onTrnsPressed;
  @override
  State<IotTrnWidget> createState() => _IotTrnWidgetState();
}

class _IotTrnWidgetState extends State<IotTrnWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        border: Border(
          bottom: BorderSide(
            color: appTheme.primary,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton.filled(
                onPressed: widget.onQrPressed,
                icon: Icon(
                  Icons.qr_code_scanner_rounded,
                  color: appTheme.white,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.selectedRack ?? "",
                style: textTheme.bodyMedium!.copyWith(
                  color: appTheme.primary,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              BlocBuilder<InterOrgTransferBloc, InterOrgTransferState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      if (widget.selectedRack != null) {
                        context.read<InterOrgTransferBloc>().add(
                              InterOrgTransfer(
                                userid: widget.loggedUser.userId,
                                trnid: widget.iotTrnData.trnid.toString(),
                                itemlotno: widget.iotTrnData.lotno.toString(),
                                torackid: widget.selectedRack!,
                              ),
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar.errorSnackber(
                            message: "Please Select Locator",
                          ),
                        );
                      }
                    },
                    child: Text(
                      state is InterOrgTransferLoading
                          ? "Transfering.."
                          : "Transfer",
                      style: textTheme.bodyMedium!.copyWith(
                        color: appTheme.white,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Text(
            widget.iotTrnData.itemName.toString(),
            style: textTheme.bodyMedium!.copyWith(
              color: appTheme.primary,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Job Order:",
                style: textTheme.bodyMedium!.copyWith(
                  color: appTheme.primary,
                ),
              ),
              Text(
                widget.iotTrnData.joborder.toString(),
                style: textTheme.bodyMedium!.copyWith(
                  color: appTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Batch No:",
                style: textTheme.bodyMedium!.copyWith(
                  color: appTheme.primary,
                ),
              ),
              Text(
                widget.iotTrnData.batchNo.toString(),
                style: textTheme.bodyMedium!.copyWith(
                  color: appTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Locator:",
                style: textTheme.bodyMedium!.copyWith(
                  color: appTheme.primary,
                ),
              ),
              Text(
                widget.iotTrnData.racklocator.toString(),
                style: textTheme.bodyMedium!.copyWith(
                  color: appTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Batch Status:",
                style: textTheme.bodyMedium!.copyWith(
                  color: appTheme.primary,
                ),
              ),
              Text(
                widget.iotTrnData.batchStatus ?? "",
                style: textTheme.bodyMedium!.copyWith(
                  color: appTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
