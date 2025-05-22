import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/print_smpl_qr_screen/print_smpl_qr_screen.dart';
import 'package:pran_rfl_erp/presentations/smpl_qr_list_screen/bloc/smpl_col_qr_list_bloc.dart';

class SmplQrListScreen extends StatelessWidget {
  const SmplQrListScreen({super.key});
  static const String routeName = "Sample-Qr-list-Screen";
  static const String routePath = "/Sample-Qr-list-Screen";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SmplQrListBloc(getService()),
      child: const SmplQrListScreenBody(),
    );
  }
}

class SmplQrListScreenBody extends StatefulWidget {
  const SmplQrListScreenBody({super.key});

  @override
  State<SmplQrListScreenBody> createState() => _SmplQrListScreenBodyState();
}

class _SmplQrListScreenBodyState extends State<SmplQrListScreenBody> {
  late UserInfoModel loggedUser;
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;
    context
        .read<SmplQrListBloc>()
        .add(SmplQrListGet(userId: loggedUser.userId));
    super.initState();
  }

  Color? parseColor(String? colorCode) {
    try {
      if (colorCode == null || colorCode.isEmpty) return null;
      return Color(int.parse("0x$colorCode"));
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CommonAppBar(
        appBartitle: "Sample Qr List",
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<SmplQrListBloc, SmplQrListState>(
                builder: (context, state) {
                  if (state is SmplQrListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is SmplQrListSuccess) {
                    return ListView.separated(
                      itemCount: state.smplQrList.length,
                      itemBuilder: (context, index) {
                        var sample = state.smplQrList[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: appTheme.secondary, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Reciving ID#:${sample.headerId}",
                                      style: textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Qty:${sample.qty}",
                                    style: textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "${sample.itemCode}-${sample.itemName}",
                                      style: textTheme.bodySmall!.copyWith(
                                        color: appTheme.tertiary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      "${sample.customerCode}-${sample.customerName}",
                                      style: textTheme.bodySmall!.copyWith(
                                        color: appTheme.tertiary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 35,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 228, 243, 235),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                      child: Text(
                                        sample.unit ?? "",
                                        style: textTheme.bodySmall!.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  sample.colorCode != null
                                      ? Row(
                                          children: [
                                            Text(
                                              "Color",
                                              style:
                                                  textTheme.bodySmall!.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              height: 20,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: parseColor(
                                                    sample.colorCode),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  sample.picture != null
                                      ? GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) => Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        "Image Preview",
                                                        style: textTheme
                                                            .titleMedium,
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.network(
                                                          "http://swift.prangroup.com:8521/Alphan/UploadedImages/${sample.picture}",
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              const Icon(Icons
                                                                  .broken_image),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                        child:
                                                            const Text("Close"),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 47, 112, 187),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "View Image",
                                                style: textTheme.bodySmall!
                                                    .copyWith(
                                                  color: appTheme.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  GestureDetector(
                                    onTap: () {
                                      context.pushNamed(
                                          PrintSmplQrScreen.routeName,
                                          extra: {
                                            "qrPrintListBlocCtx": context,
                                            "sampleColQr": sample,
                                          });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 47, 112, 187),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                        child: Text(
                                          "Print QR",
                                          style: textTheme.bodySmall!.copyWith(
                                            color: appTheme.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 0,
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
