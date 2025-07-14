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
import 'package:pran_rfl_erp/core/utils/healper_functions.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_10_screen/cubit/grn_item_qr_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_9_screen/bloc/grn_issue_bloc.dart';

class InvC9Screen extends StatelessWidget {
  const InvC9Screen({super.key, required this.fromName});
  static const String routeName = "INV-C-9-SCREEN";
  static const String routePath = "/INV-C-9-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GrnIssueBloc(getService())),

        BlocProvider(create: (context) => GrnItemQrCubit()),
      ],
      child: InvC9ScreenBody(fromName: fromName),
    );
  }
}

class InvC9ScreenBody extends StatefulWidget {
  const InvC9ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<InvC9ScreenBody> createState() => _InvC9ScreenBodyState();
}

class _InvC9ScreenBodyState extends State<InvC9ScreenBody> {
  GrnQr? grnQr;
  MobileScannerController controller = MobileScannerController();

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
      body: BlocListener<GrnIssueBloc, GrnIssueState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Issue Successful"),
                backgroundColor: appTheme.primary,
              ),
            );
            context.read<GrnItemQrCubit>().resetItemData();
          } else if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Issue Failed: ${state.error.toString()}"),
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
                            "#Lot :${grnQr?.lotNumber?.toString() ?? ""}",
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
                                        grnQr?.organizationId.toString() ?? "",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: BlocBuilder<GrnIssueBloc, GrnIssueState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            if (grnQr != null) {
                              context.read<GrnIssueBloc>().add(
                                GrnIssue(
                                  userId: loggedUser.userId.toString(),
                                  orgId: grnQr!.organizationId ?? 0,
                                  itemId: grnQr!.inventoryItemId ?? 0,
                                  locId: grnQr!.locatorId?.toString() ?? "",
                                  lotNo: grnQr!.lotNumber ?? "",
                                  qty: grnQr!.qty ?? 0,
                                ),
                              );
                            }
                          },
                          child: Text(
                            state.isLoading ? "Issuing..." : "Issue",
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
