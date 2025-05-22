import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart' as pdfview;
import 'package:permission_handler/permission_handler.dart';
import 'package:pran_rfl_erp/app_data/models/smpl_qr_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/pdf_service.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/print_qr_screen/bloc/prod_qr_print_status_bloc.dart';
import 'package:pran_rfl_erp/presentations/print_qr_screen/cubit/qr_generate_cubit.dart';
import 'package:pran_rfl_erp/presentations/smpl_qr_list_screen/bloc/smpl_col_qr_list_bloc.dart';
import 'package:printing/printing.dart';

class PrintSmplQrScreen extends StatelessWidget {
  const PrintSmplQrScreen({
    super.key,
    required this.sampleColQr,
    required this.qrPrintListBlocCtx,
  });
  static const String routePath = "/print-smpl-Qr-screen";
  static const String routeName = "print-smpl-Qr-screen";
  final SampleColQr sampleColQr;
  final BuildContext qrPrintListBlocCtx;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => QrGenerateCubit(),
        ),
        BlocProvider(
          create: (context) => ProdQrPrintStatusBloc(getService()),
        ),
        BlocProvider.value(
          value: BlocProvider.of<SmplQrListBloc>(qrPrintListBlocCtx),
        ),
      ],
      child: PrintSmplQrScreenBody(
        sampleColQr: sampleColQr,
        qrPrintListBlocCtx: qrPrintListBlocCtx,
      ),
    );
  }
}

class PrintSmplQrScreenBody extends StatefulWidget {
  const PrintSmplQrScreenBody({
    super.key,
    required this.sampleColQr,
    required this.qrPrintListBlocCtx,
  });
  final SampleColQr sampleColQr;
  final BuildContext qrPrintListBlocCtx;

  @override
  State<PrintSmplQrScreenBody> createState() => _PrintSmplQrScreenBodyState();
}

class _PrintSmplQrScreenBodyState extends State<PrintSmplQrScreenBody> {
  late UserInfoModel loggedUser;
  @override
  void initState() {
    context.read<QrGenerateCubit>().generateSmplQr(widget.sampleColQr);
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
              return Container(
                height: 190,
              );
            },
          ),
          ElevatedButton(
            onPressed: () async {
              // Request permissions
              Map<Permission, PermissionStatus> statuses = await [
                Permission.location,
                Permission.bluetooth,
                Permission.bluetoothConnect,
                Permission.bluetoothScan
              ].request();

              // Use context to select the device after checking mounted state
              if (!context.mounted) return;
              try {
                var status = await Printing.layoutPdf(
                  onLayout: (format) =>
                      PdfService.createSmplQr(widget.sampleColQr),
                );
                if (!context.mounted) return;
                if (status) {
                  context.read<ProdQrPrintStatusBloc>().add(
                        SmplQrPrintStatusUpdate(id: widget.sampleColQr.id ?? 0),
                      );
                  widget.qrPrintListBlocCtx.read<SmplQrListBloc>().add(
                        SmplQrListGet(
                          userId: loggedUser.userId,
                        ),
                      );
                }
              } catch (e) {
                log("Not Printed Due to Exception");
              }
            },
            child: Text(
              "Pritnt Qr",
              style: textTheme.bodyMedium!.copyWith(
                color: appTheme.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
