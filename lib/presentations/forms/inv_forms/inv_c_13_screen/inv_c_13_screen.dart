import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_dropdown_search.dart';
import 'package:pran_rfl_erp/common_widgets/read_qr_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/healper_functions.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/user_org_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/item_qr_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_10_screen/cubit/grn_item_qr_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_9_screen/bloc/grn_issue_bloc.dart';

class InvC13Screen extends StatelessWidget {
  const InvC13Screen({super.key, required this.fromName});
  static const String routeName = "INV-C-13-SCREEN";
  static const String routePath = "/INV-C-13-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GrnIssueBloc(getService())),
        BlocProvider(create: (context) => ItemQrCubit()),
        BlocProvider(create: (context) => VariableStateHandlerCubit<UserOrg>()),
      ],
      child: InvC13ScreenBody(fromName: fromName),
    );
  }
}

class InvC13ScreenBody extends StatefulWidget {
  const InvC13ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<InvC13ScreenBody> createState() => _InvC13ScreenBodyState();
}

class _InvC13ScreenBodyState extends State<InvC13ScreenBody> {
  UserBatchQrData? grnQr;
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
            context.read<ItemQrCubit>().resetItemData();
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
              BlocBuilder<UserOrgBloc, UserOrgState>(
                builder: (context, state) {
                  return CustomDropdownSearch<UserOrg>(
                    hintText: "Select Org",
                    enabled: state is UserOrgSuccess
                        ? state.userOrg.isNotEmpty
                        : false,

                    items: state is UserOrgSuccess ? state.userOrg : [],
                    onChanged: (value) {
                      if (value != null) {
                        context
                            .read<VariableStateHandlerCubit<UserOrg>>()
                            .update(value);
                      }
                    },
                  );
                },
              ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: BlocBuilder<GrnIssueBloc, GrnIssueState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            var organization = context
                                .read<VariableStateHandlerCubit<UserOrg>>()
                                .state;
                            if (organization?.organizationId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please select organization"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            if (grnQr != null) {
                              context.read<GrnIssueBloc>().add(
                                NewIssue(
                                  userId: loggedUser.userId.toString(),
                                  orgId: organization?.organizationId ?? 0,
                                  lotNo: grnQr!.lotno ?? "",
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please scan item QR"),
                                  backgroundColor: Colors.red,
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
