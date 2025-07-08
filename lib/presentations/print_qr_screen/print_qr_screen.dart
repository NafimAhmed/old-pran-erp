import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pdfrx/pdfrx.dart' as pdfview;
import 'package:permission_handler/permission_handler.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';

import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/pdf_service.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_2_screen/bloc/user_qr_print_bloc.dart';
import 'package:pran_rfl_erp/presentations/print_qr_screen/bloc/prod_qr_print_status_bloc.dart';

import 'package:pran_rfl_erp/presentations/print_qr_screen/cubit/qr_generate_cubit.dart';
import 'package:printing/printing.dart';

class PrintQrScreen extends StatelessWidget {
  const PrintQrScreen({
    super.key,
    required this.userBatchQrData,
    required this.userQrPrintBlocCtx,
    required this.userOrg,
  });
  static const String routePath = "/printQr-screen";
  static const String routeName = "printQr-screen";
  final UserBatchQrData userBatchQrData;
  final BuildContext userQrPrintBlocCtx;
  final UserOrg userOrg;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => QrGenerateCubit()),
        BlocProvider(create: (context) => ProdQrPrintStatusBloc(getService())),
        BlocProvider.value(
          value: BlocProvider.of<UserQrPrintBloc>(userQrPrintBlocCtx),
        ),
      ],
      child: PrintQrScreenBody(
        userBatchQrData: userBatchQrData,
        userQrPrintBlocCtx: userQrPrintBlocCtx,
        userOrg: userOrg,
      ),
    );
  }
}

class PrintQrScreenBody extends StatefulWidget {
  const PrintQrScreenBody({
    super.key,
    required this.userBatchQrData,
    required this.userQrPrintBlocCtx,
    required this.userOrg,
  });
  final UserBatchQrData userBatchQrData;
  final BuildContext userQrPrintBlocCtx;
  final UserOrg userOrg;
  @override
  State<PrintQrScreenBody> createState() => _PrintQrScreenBodyState();
}

class _PrintQrScreenBodyState extends State<PrintQrScreenBody> {
  late UserInfoModel loggedUser;
  @override
  void initState() {
    context.read<QrGenerateCubit>().generateQr(widget.userBatchQrData);
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
                  // format: PdfPageFormat.standard.copyWith(
                  //   height: 2.5 * PdfPageFormat.inch,
                  //   width: 4.15 * PdfPageFormat.inch,
                  //   marginBottom: 0.05 * PdfPageFormat.cm,
                  //   marginLeft: 0.05 * PdfPageFormat.cm,
                  //   marginRight: 0.05 * PdfPageFormat.cm,
                  //   marginTop: 0.05 * PdfPageFormat.cm,
                  // ),
                  // dynamicLayout: true,
                  // forceCustomPrintPaper: true,
                  // usePrinterSettings: true,
                  onLayout: (format) =>
                      PdfService.createBatchQrPdf(widget.userBatchQrData),
                );
                if (!context.mounted) return;
                if (status) {
                  context.read<ProdQrPrintStatusBloc>().add(
                    ProdQrPrintStatusUpdate(
                      trnlotno: widget.userBatchQrData.lotno!,
                    ),
                  );
                  widget.userQrPrintBlocCtx.read<UserQrPrintBloc>().add(
                    GetUserQrPrintData(
                      userid: loggedUser.userId,
                      orgid: widget.userOrg.organizationId.toString(),
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

  // Future<void> requestPermission() async {
  //   final permission = Permission.bluetooth.status;

  //   if (await permission.isDenied) {

  //     log(statuses.toString());
  //   }
  // }
}
