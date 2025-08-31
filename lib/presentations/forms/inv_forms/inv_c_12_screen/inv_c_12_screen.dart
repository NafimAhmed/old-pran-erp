import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pran_rfl_erp/app_data/models/lot_trn_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/batch_status_dialog.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_snackBar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/read_qr_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/app_modal.dart';
import 'package:pran_rfl_erp/core/utils/healper_functions.dart';
import 'package:pran_rfl_erp/core/utils/text_input_formatters.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/check_batch_status_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_1_screen/bloc/lot_trn_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/item_qr_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/rack_qr_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_8_screen/bloc/ebs_inter_org_transfer_bloc.dart';

class InvC12Screen extends StatelessWidget {
  const InvC12Screen({super.key, required this.fromName});
  static const String routeName = "INV-C-12-SCREEN";
  static const String routePath = "/INV-C-12-SCREEN";

  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => EbsInterOrgTranBloc(getService())),
        BlocProvider(create: (context) => LotTrnBloc(getService())),
        BlocProvider(create: (context) => CheckBatchStatusBloc(getService())),
        BlocProvider(create: (context) => ItemQrCubit()),
      ],
      child: InvC12ScreenBody(fromName: fromName),
    );
  }
}

class InvC12ScreenBody extends StatefulWidget {
  const InvC12ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<InvC12ScreenBody> createState() => _InvC12ScreenBodyState();
}

class _InvC12ScreenBodyState extends State<InvC12ScreenBody> {
  MobileScannerController? controller = MobileScannerController();
  UserBatchQrData? itemQrData;

  late UserInfoModel loggedUser;

  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;
    context.read<LotTrnBloc>().add(
      GetLotTrnDataNew(
        userId: loggedUser.userId,
        racklocator: itemQrData?.lotno ?? "",
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EbsInterOrgTranBloc, EbsInterOrgTranState>(
          listener: (context, state) {
            if (state is EbsInterOrgTranSuccess) {
              context.read<ItemQrCubit>().resetItemData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Successfully Added..."),
                  backgroundColor: appTheme.primary,
                ),
              );
            }
            if (state is EbsInterOrgTranError) {
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
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
              const SizedBox(height: 10),
              BlocConsumer<ItemQrCubit, ItemQrState>(
                listener: (context, state) {
                  if (state is ItemQrInitial) {
                    context.read<LotTrnBloc>().add(RestLotTrnData());
                  }
                },
                builder: (context, state) {
                  if (state is ItemQrInitial) {
                    itemQrData = null;
                  }
                  if (state is ItemQrDataLoaded) {
                    itemQrData = state.userBatchQrData;
                    context.read<LotTrnBloc>().add(
                      GetLotTrnDataNew(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
              Expanded(
                child: BlocBuilder<LotTrnBloc, LotTrnState>(
                  builder: (context, state) {
                    if (state is LotTrnLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is LotTrnSuccess) {
                      if (state.lotTrnDataList.isNotEmpty) {
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            var data = state.lotTrnDataList[index];

                            return IotTrnWidget(
                              loggedUser: loggedUser,
                              iotTrnData: data,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
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
              ),
            ],
          ),
        ),
        bottomNavigationBar: const UserDetailsWidget(),
      ),
    );
  }
}

class IotTrnWidget extends StatelessWidget {
  const IotTrnWidget({
    super.key,
    required this.iotTrnData,
    required this.loggedUser,
    this.onTrnsPressed,
  });
  final LotTrnData iotTrnData;
  final UserInfoModel loggedUser;
  final void Function()? onTrnsPressed;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => RackQrCubit())],
      child: IotTrnView(
        iotTrnData: iotTrnData,
        loggedUser: loggedUser,
        onTrnsPressed: onTrnsPressed,
      ),
    );
  }
}

class IotTrnView extends StatefulWidget {
  const IotTrnView({
    super.key,
    required this.iotTrnData,
    this.onTrnsPressed,
    required this.loggedUser,
  });
  final LotTrnData iotTrnData;

  final UserInfoModel loggedUser;
  final void Function()? onTrnsPressed;
  @override
  State<IotTrnView> createState() => _IotTrnViewState();
}

class _IotTrnViewState extends State<IotTrnView> {
  MobileScannerController? controller = MobileScannerController();
  List<String> rackQrData = [];
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();
  @override
  void dispose() {
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        border: Border(bottom: BorderSide(color: appTheme.primary, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton.filled(
                onPressed: () async {
                  var qrData = await buildScanner(context, controller);
                  if (context.mounted) {
                    context.read<RackQrCubit>().setrackData(rackQrData: qrData);
                  }
                },
                icon: Icon(
                  Icons.qr_code_scanner_rounded,
                  color: appTheme.white,
                ),
              ),
              const SizedBox(width: 10),
              BlocBuilder<RackQrCubit, RackQrState>(
                builder: (context, state) {
                  if (state is RackQrDataLoaded) {
                    rackQrData = state.rackQRDatalist;
                    return Text(
                      rackQrData[0],
                      style: textTheme.bodyMedium!.copyWith(
                        color: appTheme.primary,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),

              const SizedBox(width: 10),
              BlocBuilder<EbsInterOrgTranBloc, EbsInterOrgTranState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      if (textController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar.errorSnackber(
                            message: "Please Add Quantity",
                          ),
                        );
                        return;
                      }
                      if (rackQrData.isNotEmpty) {
                        context.read<EbsInterOrgTranBloc>().add(
                          EbsInterOrgTran(
                            userid: widget.loggedUser.userId,
                            trnid: widget.iotTrnData.trnid.toString(),
                            itemlotno: widget.iotTrnData.lotno.toString(),
                            torackid: rackQrData[0],
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
                      state is EbsInterOrgTranLoading
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
            style: textTheme.bodyMedium!.copyWith(color: appTheme.primary),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Job Order:",
                style: textTheme.bodyMedium!.copyWith(color: appTheme.primary),
              ),
              Text(
                widget.iotTrnData.joborder.toString(),
                style: textTheme.bodyMedium!.copyWith(color: appTheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Batch No:",
                style: textTheme.bodyMedium!.copyWith(color: appTheme.primary),
              ),
              Text(
                widget.iotTrnData.batchNo.toString(),
                style: textTheme.bodyMedium!.copyWith(color: appTheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Locator:",
                style: textTheme.bodyMedium!.copyWith(color: appTheme.primary),
              ),
              Text(
                widget.iotTrnData.racklocator.toString(),
                style: textTheme.bodyMedium!.copyWith(color: appTheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Batch Status:",
                style: textTheme.bodyMedium!.copyWith(color: appTheme.primary),
              ),
              Text(
                widget.iotTrnData.batchStatus ?? "",
                style: textTheme.bodyMedium!.copyWith(color: appTheme.primary),
              ),
            ],
          ),
          CommonTextFieldWidget(
            focusNode: focusNode,
            controller: textController,
            keyboardType: TextInputType.number,
            labelText: "Quantity",
            hintText: "Enter Quantity",
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              NumericalRangeFormatter(
                min: 1,
                max: widget.iotTrnData.rackQty ?? 1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
