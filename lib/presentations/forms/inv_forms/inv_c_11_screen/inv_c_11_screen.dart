import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pran_rfl_erp/app_data/models/grn_qr_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/read_qr_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/rack_qr_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_10_screen/cubit/grn_item_qr_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_11_screen/bloc/grn_trans_bloc.dart';

import '../../../../core/utils/healper_functions.dart';

class InvC11Screen extends StatelessWidget {
  const InvC11Screen({super.key, required this.fromName});
  static const String routeName = "INV-C-11-SCREEN";
  static const String routePath = "/INV-C-11-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GrnTranBloc(getService())),
        BlocProvider(create: (context) => RackQrCubit()),
        BlocProvider(create: (context) => GrnItemQrCubit()),
      ],
      child: InvC11ScreenBody(fromName: fromName),
    );
  }
}

class InvC11ScreenBody extends StatefulWidget {
  const InvC11ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<InvC11ScreenBody> createState() => _InvC11ScreenBodyState();
}

class _InvC11ScreenBodyState extends State<InvC11ScreenBody> {
  GrnQr? grnQr;
  MobileScannerController controller = MobileScannerController();
  List<String> rackQrData = [];
  late UserInfoModel loggedUser;
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: BlocListener<GrnTranBloc, GrnTranState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Transfer Successful"),
                backgroundColor: appTheme.primary,
              ),
            );
            context.read<GrnItemQrCubit>().resetItemData();
            context.read<RackQrCubit>().resetRackData();
          } else if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Transfer Failed: ${state.error.toString()}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: ReadQrWidget(
                      qrType: "Item QR",
                      onPressed: () async {
                        var data = await buildScanner(context, controller);
                        if (context.mounted) {
                          context.read<GrnItemQrCubit>().setItemData(
                            grnItemQrData: data,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              BlocBuilder<GrnItemQrCubit, GrnItemQrState>(
                builder: (context, state) {
                  if (state is GrnItemQrInitial) {
                    grnQr = null;
                  }
                  if (state is GrnItemQrDataLoaded) {
                    grnQr = state.grnQr;
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
                            "#Lot :${grnQr?.trnid?.toString() ?? ""}",
                            style: textTheme.bodyMedium,
                          ),
                          Text(
                            grnQr?.itemName ?? "",
                            style: textTheme.bodyMedium,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Qty: ", style: textTheme.bodyMedium),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        grnQr?.qty.toString() ?? "",
                                        textAlign: TextAlign.right,
                                        style: textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Org: ", style: textTheme.bodyMedium),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        grnQr?.orgId.toString() ?? "",
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
                    child: BlocBuilder<GrnTranBloc, GrnTranState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            if (grnQr != null && rackQrData.isNotEmpty) {
                              context.read<GrnTranBloc>().add(
                                GrnTransfer(
                                  userId: loggedUser.userId.toString(),
                                  orgId: grnQr!.orgId!,
                                  itemId: grnQr!.inventoryItemId!,
                                  locId: rackQrData[0],
                                  lotNo: grnQr!.trnid!,
                                ),
                              );
                            }
                          },
                          child: Text(
                            state.isLoading ? "Transfering..." : "Transfer",
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
      ),
      bottomNavigationBar: const UserDetailsWidget(),
    );
  }
}
