import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/rcv_inv_org_trn_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/read_qr_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/healper_functions.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_2_screen/bloc/rcv_iot_data_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/item_qr_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/rack_qr_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_3_screen/opm_c_3_screen.dart';

class InvC2Screen extends StatelessWidget {
  const InvC2Screen({super.key, required this.fromName});
  static const String routeName = "INV-C-2-SCREEN";
  static const String routePath = "/INV-C-2-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RcvIotDataBloc(getService()),
        ),
        BlocProvider(
          create: (context) => ItemQrCubit(),
        ),
        BlocProvider(
          create: (context) => RackQrCubit(),
        ),
        BlocProvider(
          create: (context) => VariableStateHandlerCubit<RcvIotData>(),
        ),
      ],
      child: InvC2ScreenBody(
        fromName: fromName,
      ),
    );
  }
}

class InvC2ScreenBody extends StatefulWidget {
  const InvC2ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<InvC2ScreenBody> createState() => _InvC2ScreenBodyState();
}

class _InvC2ScreenBodyState extends State<InvC2ScreenBody> {
  late UserInfoModel loggedUser;
  UserBatchQrData? itemQrData;
  List<String> rackQrData = [];
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state!;
    context.read<RcvIotDataBloc>().add(
          GetRcvIotData(
            userId: loggedUser.userId,
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
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
              height: 15,
            ),
            Expanded(
              child: BlocBuilder<RcvIotDataBloc, RcvIotDataState>(
                builder: (context, state) {
                  if (state is RcvIotDataLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is RcvIotDataSuccess) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        var data = state.rcvIotDataList[index];
                        var selectedData = context
                            .watch<VariableStateHandlerCubit<RcvIotData>>()
                            .state;
                        return BlocBuilder<RackQrCubit, RackQrState>(
                          builder: (context, state) {
                            if (state is RackQrDataLoaded) {
                              rackQrData = state.rackQRDatalist;
                            }
                            return RcvIotWidget(
                              rcvIotData: data,
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
                                              RcvIotData>>()
                                      .update(data);
                                }
                              },
                              onTrnsPressed: () {},
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                      itemCount: state.rcvIotDataList.length,
                    );
                  }
                  return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RcvIotWidget extends StatefulWidget {
  const RcvIotWidget({
    super.key,
    required this.rcvIotData,
    this.selectedRack,
    this.onQrPressed,
    this.onTrnsPressed,
  });
  final RcvIotData rcvIotData;
  final String? selectedRack;
  final void Function()? onQrPressed;
  final void Function()? onTrnsPressed;
  @override
  State<RcvIotWidget> createState() => _RcvIotWidgetState();
}

class _RcvIotWidgetState extends State<RcvIotWidget> {
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
              widget.selectedRack != null
                  ? ElevatedButton(
                      onPressed: widget.onTrnsPressed,
                      child: Text(
                        "Transfer",
                        style: textTheme.bodyMedium!.copyWith(
                          color: appTheme.white,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Text(
            widget.rcvIotData.joborder ?? "",
            style: textTheme.bodyMedium!.copyWith(
              color: appTheme.primary,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.rcvIotData.itemName ?? "",
            style: textTheme.bodyMedium!.copyWith(
              color: appTheme.primary,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.rcvIotData.racklocator ?? "",
            style: textTheme.bodyMedium!.copyWith(
              color: appTheme.primary,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.rcvIotData.trnqty.toString(),
            style: textTheme.bodyMedium!.copyWith(
              color: appTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
