import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_lable_wth_textfield.dart';
import 'package:pran_rfl_erp/common_widgets/custom_dropdown_search.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/operation_unit_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/bloc/user_org_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/rack_qr_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/variable_state_handler_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/po_forms/po_c_2_screen/bloc/grn_qr_list_bloc.dart';
import 'package:pran_rfl_erp/presentations/print_grn_qr_screen/print_grn_qr_screen.dart';

class InvC11Screen extends StatelessWidget {
  const InvC11Screen({super.key, required this.fromName});
  static const String routeName = "INV-C-11-SCREEN";
  static const String routePath = "/INV-C-11-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => RackQrCubit())],
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
  final GlobalKey<FormState> _fromKey = GlobalKey();
  late UserInfoModel loggedUser;
  TextEditingController quantityTextController = TextEditingController();
  FocusNode quantityFocusNode = FocusNode();
  TextEditingController goodQtyTextController = TextEditingController();
  FocusNode goodQtyFocusNode = FocusNode();
  TextEditingController badQtyTextController = TextEditingController();
  FocusNode badQtyFocusNode = FocusNode();
  @override
  void initState() {
    context.read<OperationUnitBloc>().add(OperationUnitGet());

    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;

    super.initState();
  }

  @override
  void dispose() {
    quantityTextController.dispose();
    goodQtyTextController.dispose();
    badQtyTextController.dispose();
    quantityFocusNode.dispose();
    goodQtyFocusNode.dispose();
    badQtyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Form(
              key: _fromKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<UserOrgBloc, UserOrgState>(
                          builder: (context, state) {
                            return CustomDropdownSearch<UserOrg>(
                              hintText: "Select Org",
                              enabled: state is UserOrgSuccess
                                  ? state.userOrg.isNotEmpty
                                  : false,

                              items: state is UserOrgSuccess
                                  ? state.userOrg
                                  : [],
                              onChanged: (value) {},
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CommonLableWthTextField(
                    lableName: "Good Qty",
                    focusNode: goodQtyFocusNode,
                    textController: goodQtyTextController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Good Quantity";
                      }
                      if (int.parse(value) <= 0) {
                        return "Can't Be Zero";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      var goodQty = value.isEmpty ? 0 : int.parse(value);
                      badQtyTextController.text = "0";
                      var badQty = badQtyTextController.text.isEmpty
                          ? 0
                          : int.parse(badQtyTextController.text);
                      quantityTextController.text = (goodQty + badQty)
                          .toString();
                    },
                  ),
                  const SizedBox(height: 10),
                  CommonLableWthTextField(
                    lableName: "Bad Qty",
                    focusNode: badQtyFocusNode,
                    textController: badQtyTextController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Bad Quantity";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      var badQty = value.isEmpty ? 0 : int.parse(value);
                      var goodQty = goodQtyTextController.text.isEmpty
                          ? 0
                          : int.parse(goodQtyTextController.text);
                      quantityTextController.text = (goodQty + badQty)
                          .toString();
                    },
                  ),
                  const SizedBox(height: 10),
                  CommonLableWthTextField(
                    lableName: "Quantity",
                    readOnly: true,
                    focusNode: quantityFocusNode,
                    textController: quantityTextController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Quantity";
                      }
                      return null;
                    },
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: BlocBuilder<GrnQrListBloc, GrnQrListState>(
                builder: (context, state) {
                  if (state is GrnQrListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is GrnQrListSuccess) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        var data = state.grnQr[index];
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 209, 222, 245),
                            // color: index % 2 == 0
                            //     ? const Color.fromARGB(255, 115, 134, 240)
                            //     : const Color.fromARGB(255, 136, 152, 247),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Item Name",
                                        style: textTheme.bodyMedium!.copyWith(
                                          fontSize: 15,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                      Text(
                                        data.itemName.toString(),
                                        style: textTheme.bodySmall!.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Item Code",
                                        style: textTheme.bodyMedium!.copyWith(
                                          fontSize: 15,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                      Text(
                                        data.itemCode ?? "",
                                        style: textTheme.bodySmall!.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Lot No",
                                        style: textTheme.bodyMedium!.copyWith(
                                          fontSize: 15,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                      Text(
                                        data.trnid.toString(),
                                        style: textTheme.bodySmall!.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Organization",
                                        style: textTheme.bodyMedium!.copyWith(
                                          fontSize: 15,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                      Text(
                                        "${data.organizationCode}-${data.organizationName}",
                                        style: textTheme.bodySmall!.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Qty",
                                        style: textTheme.bodyMedium!.copyWith(
                                          fontSize: 15,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                      Text(
                                        data.qty.toString() ?? "",
                                        style: textTheme.bodySmall!.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: appTheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom().copyWith(
                                      padding:
                                          const WidgetStatePropertyAll<
                                            EdgeInsetsGeometry
                                          >(
                                            EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                          ),
                                      minimumSize:
                                          WidgetStateProperty.all<Size>(
                                            const Size(80, 30),
                                          ),
                                      backgroundColor: WidgetStatePropertyAll(
                                        appTheme.tertiary,
                                      ),
                                    ),
                                    onPressed: () {
                                      UserOrg userOrg = context
                                          .read<
                                            VariableStateHandlerCubit<UserOrg>
                                          >()
                                          .state!;
                                      context.pushNamed(
                                        PrintGrnQrScreen.routeName,
                                        extra: {
                                          "grnQrData": data,
                                          "grnQrPrintBlocCtx": context,
                                          "userOrg": userOrg,
                                        },
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "Print ",
                                          style: textTheme.bodyMedium!.copyWith(
                                            fontSize: 14,
                                            color: appTheme.white,
                                          ),
                                        ),
                                        Icon(
                                          Icons.qr_code,
                                          color: appTheme.white,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemCount: state.grnQr.length,
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
