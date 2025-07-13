import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart' as pdfview;
import 'package:permission_handler/permission_handler.dart';
import 'package:pran_rfl_erp/app_data/models/grn_qr_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/pdf_service.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_10_screen/bloc/grn_qr_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/print_qr_screen/bloc/prod_qr_print_status_bloc.dart';
import 'package:pran_rfl_erp/presentations/print_qr_screen/cubit/qr_generate_cubit.dart';

import 'package:printing/printing.dart';

class PrintGrnQrScreen extends StatelessWidget {
  const PrintGrnQrScreen({
    super.key,
    required this.grnQrData,
    required this.grnQrPrintBlocCtx,
  });
  static const String routePath = "/print-grn-qr-screen";
  static const String routeName = "print-grn-qr-screen";
  final GrnQr grnQrData;
  final BuildContext grnQrPrintBlocCtx;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => QrGenerateCubit()),
        BlocProvider(create: (context) => ProdQrPrintStatusBloc(getService())),
        BlocProvider.value(
          value: BlocProvider.of<GrnQrListBloc>(grnQrPrintBlocCtx),
        ),
      ],
      child: PrintQrScreenBody(
        grnQrData: grnQrData,
        grnQrPrintBlocCtx: grnQrPrintBlocCtx,
      ),
    );
  }
}

class PrintQrScreenBody extends StatefulWidget {
  const PrintQrScreenBody({
    super.key,
    required this.grnQrData,
    required this.grnQrPrintBlocCtx,
  });
  final GrnQr grnQrData;
  final BuildContext grnQrPrintBlocCtx;

  @override
  State<PrintQrScreenBody> createState() => _PrintQrScreenBodyState();
}

class _PrintQrScreenBodyState extends State<PrintQrScreenBody> {
  late UserInfoModel loggedUser;
  @override
  void initState() {
    context.read<QrGenerateCubit>().generatGrnQr(widget.grnQrData);
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(appBartitle: "Print Qr Code"),
      body: Column(
        children: [
          BlocBuilder<QrGenerateCubit, Uint8List?>(
            builder: (context, state) {
              if (state != null) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  height: 190,
                  child: pdfview.PdfViewer.data(
                    state,
                    sourceName: "",
                    params: pdfview.PdfViewerParams(
                      backgroundColor: Colors.transparent,
                      margin: 0,
                      maxScale: 20,
                      loadingBannerBuilder:
                          (context, bytesDownloaded, totalBytes) => Center(
                            child: CircularProgressIndicator(
                              value: totalBytes != null
                                  ? bytesDownloaded / totalBytes
                                  : null,
                              backgroundColor: appTheme.primary,
                            ),
                          ),
                    ),
                  ),
                );
              }
              return Container(height: 190);
            },
          ),
          ElevatedButton(
            onPressed: () async {
              // Request permissions
              Map<Permission, PermissionStatus> statuses = await [
                Permission.location,
                Permission.bluetooth,
                Permission.bluetoothConnect,
                Permission.bluetoothScan,
              ].request();

              // Use context to select the device after checking mounted state
              if (!context.mounted) return;
              try {
                var status = await Printing.layoutPdf(
                  onLayout: (format) =>
                      PdfService.createGrnQrPdf(widget.grnQrData),
                );
                if (!context.mounted) return;
                if (status) {
                  context.read<ProdQrPrintStatusBloc>().add(
                    GrnQrPrintStatusUpdate(
                      trnId: widget.grnQrData.lotNumber ?? "",
                    ),
                  );
                  widget.grnQrPrintBlocCtx.read<GrnQrListBloc>().add(
                    GrnQrListGet(
                      userId: loggedUser.userId,
                      qrType: widget.grnQrData.qrType ?? "",
                    ),
                  );
                }
              } catch (e) {
                log(e.toString());
              }
            },
            child: Text(
              "Print Qr",
              style: textTheme.bodyMedium!.copyWith(color: appTheme.white),
            ),
          ),
        ],
      ),
    );
  }
}
