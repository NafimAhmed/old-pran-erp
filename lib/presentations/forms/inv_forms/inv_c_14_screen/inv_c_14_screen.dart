import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/read_qr_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/text_input_formatters.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/item_qr_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/rack_qr_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_11_screen/bloc/grn_on_hand_qty_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_11_screen/bloc/grn_rcv_bloc.dart';

import '../../../../core/utils/healper_functions.dart';

class InvC14Screen extends StatelessWidget {
  const InvC14Screen({super.key, required this.fromName});
  static const String routeName = "INV-C-14-SCREEN";
  static const String routePath = "/INV-C-14-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GrnRcvBloc(getService())),
        BlocProvider(create: (context) => RackQrCubit()),
        BlocProvider(create: (context) => ItemQrCubit()),
      ],
      child: InvC14ScreenBody(fromName: fromName),
    );
  }
}

class InvC14ScreenBody extends StatefulWidget {
  const InvC14ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<InvC14ScreenBody> createState() => _InvC14ScreenBodyState();
}

class _InvC14ScreenBodyState extends State<InvC14ScreenBody> {
  TextEditingController lotNoController = TextEditingController();
  FocusNode lotNoFocusNode = FocusNode();
  UserBatchQrData? grnQr;
  MobileScannerController controller = MobileScannerController();

  List<String> rackQrData = [];
  late UserInfoModel loggedUser;
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;

    super.initState();
  }

  @override
  void dispose() {
    lotNoController.dispose();
    lotNoFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: BlocListener<GrnRcvBloc, GrnRcvState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Receive Successful"),
                backgroundColor: appTheme.primary,
              ),
            );

            lotNoController.clear();
            lotNoFocusNode.unfocus();

            context.read<ItemQrCubit>().resetItemData();
            context.read<RackQrCubit>().resetRackData();
          } else if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Receive Failed: ${state.error.toString()}"),
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
                    grnQr = null;
                  }
                  if (state is ItemQrDataLoaded) {
                    grnQr = state.userBatchQrData;

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
                            "#Lot :${grnQr?.lotno?.toString() ?? ""}",
                            style: textTheme.bodyMedium,
                          ),
                          Text(
                            grnQr?.itemname ?? "",
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
                                        grnQr?.goodQty.toString() ?? "",
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

              BlocBuilder<ItemQrCubit, ItemQrState>(
                builder: (context, state) {
                  if (state is ItemQrInitial) {
                    grnQr = null;
                  }
                  if (state is ItemQrDataLoaded) {
                    grnQr = state.userBatchQrData;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        CommonTextFieldWidget(
                          controller: lotNoController,
                          focusNode: lotNoFocusNode,
                          labelText: "Split Quantity",
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                            NumericalRangeFormatter(
                              min: 1,
                              max: state.userBatchQrData.goodQty ?? 0,
                            ),
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter an quantity";
                            }
                            return null;
                          },
                        ),
                      ],
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
                    child: BlocBuilder<GrnRcvBloc, GrnRcvState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            if (grnQr == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please scan Item QR first"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            if (rackQrData.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please scan Rack QR first"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            if (lotNoController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("On Hand Qty is Zero"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            context.read<GrnRcvBloc>().add(
                              NewRcv(
                                userId: loggedUser.userId.toString(),
                                locId: rackQrData[0],
                                lotNo: grnQr?.lotno ?? "",
                                pQty: lotNoController.text.isEmpty
                                    ? "0"
                                    : lotNoController.text,
                              ),
                            );
                          },
                          child: Text(
                            state.isLoading ? "Receiving..." : "Receive",
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
