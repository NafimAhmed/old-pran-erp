import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/read_qr_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/healper_functions.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/rack_qr_cubit.dart';

class PoC4Screen extends StatelessWidget {
  const PoC4Screen({super.key, required this.fromName});
  static const String routeName = "PO-C-4-SCREEN";
  static const String routePath = "/PO-C-4-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => RackQrCubit())],
      child: POC4ScreenBody(fromName: fromName),
    );
  }
}

class POC4ScreenBody extends StatefulWidget {
  const POC4ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<POC4ScreenBody> createState() => _POC4ScreenBodyState();
}

class _POC4ScreenBodyState extends State<POC4ScreenBody> {
  MobileScannerController controller = MobileScannerController();
  List<String> rackQrData = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: Container(
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
                        // context.read<GrnItemQrCubit>().setItemData(
                        //   grnItemQrData: data,
                        // );
                      }
                    },
                  ),
                ),
              ],
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
          ],
        ),
      ),
    );
  }
}
