import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/entities/machine_list_response.dart';
import 'package:pran_rfl_erp/app_data/entities/user_basic_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/user_org_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';

import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/common_widgets/custom_drop_down_button_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';

import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/presentations/opm_forms/opm_c_2_screen/bloc/user_basic_data_bloc.dart';

import 'package:pran_rfl_erp/global_blocs/bloc/user_org_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/opm_forms/opm_c_2_screen/cubit/selected_org_cubit.dart';

class OpmC2Screen extends StatelessWidget {
  const OpmC2Screen({super.key});
  static const String routeName = "OPM-C-2-SCREEN";
  static const String routePath = "/OPM-C-2-SCREEN";
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBasicDataBloc(getService()),
        ),
        BlocProvider(
          create: (context) => SelectedOrgCubit(),
        ),
      ],
      child: const ProductionScreenBody(),
    );
  }
}

class ProductionScreenBody extends StatefulWidget {
  const ProductionScreenBody({super.key});

  @override
  State<ProductionScreenBody> createState() => _ProductionScreenBodyState();
}

class _ProductionScreenBodyState extends State<ProductionScreenBody> {
  TextEditingController quantityTextController = TextEditingController();
  FocusNode quantityFocusNode = FocusNode();
  TextEditingController goodQtyTextController = TextEditingController();
  FocusNode goodQtyFocusNode = FocusNode();
  TextEditingController badQtyTextController = TextEditingController();
  FocusNode badQtyFocusNode = FocusNode();
  TextEditingController dropDownTextController = TextEditingController();

  List<Machine> lovList = [];
  GlobalKey<FormState> fromkey = GlobalKey();
  @override
  void initState() {
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
      resizeToAvoidBottomInset: false,
      appBar: const CommonAppBar(appBartitle: "D-Production"),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              const UserDetailsWidget(),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<UserOrgBloc, UserOrgState>(
                      builder: (context, state) {
                        return CommonDropdownButton<UserOrg>(
                          hintText: "Select Org",
                          items: state is UserOrgSuccess ? state.userOrg : [],
                          onChanged: (value) {
                            var loggedUser =
                                context.read<LoggedUserInfoCubit>().state;
                            context.read<UserBasicDataBloc>().add(
                                  UserBasicDataGet(
                                    userId: loggedUser!.userId!,
                                    orgid: value!.organizationId!.toString(),
                                  ),
                                );
                            context
                                .read<SelectedOrgCubit>()
                                .setOrg(userOrg: value);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: BlocBuilder<UserBasicDataBloc, UserBasicDataState>(
                      builder: (context, state) {
                        return CommonDropdownButton<UserMachine>(
                          hintText: "Select Machine",
                          items: state is UserBasicDataSuccess
                              ? state.userBasicData.userMachineData
                              : [],
                          onChanged: (value) {},
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<UserBasicDataBloc, UserBasicDataState>(
                builder: (context, state) {
                  return CommonDropdownButton<UserBatch>(
                    hintText: "Select Batch",
                    items: state is UserBasicDataSuccess
                        ? state.userBasicData.userBatchData
                        : [],
                    onChanged: (value) {},
                  );
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Form(
                key: fromkey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: appTheme.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(
                                  20,
                                ),
                                bottomRight: Radius.circular(
                                  20,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Good Qty",
                                style: textTheme.bodyMedium!.copyWith(
                                  color: appTheme.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CommonTextFieldWidget(
                            focusNode: goodQtyFocusNode,
                            textAlign: TextAlign.center,
                            controller: goodQtyTextController,
                            keyboardType: TextInputType.phone,
                            style: textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: appTheme.primary,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            labelText: "",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Good Quantity";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              var goodQty =
                                  value.isEmpty ? 0 : int.parse(value);
                              var badQty = badQtyTextController.text.isEmpty
                                  ? 0
                                  : int.parse(badQtyTextController.text);
                              quantityTextController.text =
                                  (goodQty + badQty).toString();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: appTheme.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(
                                  20,
                                ),
                                bottomRight: Radius.circular(
                                  20,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Bad Qty",
                                style: textTheme.bodyMedium!.copyWith(
                                  color: appTheme.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CommonTextFieldWidget(
                            focusNode: badQtyFocusNode,
                            textAlign: TextAlign.center,
                            controller: badQtyTextController,
                            keyboardType: TextInputType.phone,
                            style: textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: appTheme.primary,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            labelText: "",
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
                              quantityTextController.text =
                                  (goodQty + badQty).toString();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: appTheme.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(
                                  20,
                                ),
                                bottomRight: Radius.circular(
                                  20,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Quantity",
                                style: textTheme.bodyMedium!.copyWith(
                                  color: appTheme.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CommonTextFieldWidget(
                            readOnly: true,
                            focusNode: quantityFocusNode,
                            textAlign: TextAlign.center,
                            controller: quantityTextController,
                            keyboardType: TextInputType.phone,
                            style: textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: appTheme.primary,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            labelText: "",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Quantity";
                              }
                              return null;
                            },
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Save",
                  style: textTheme.bodyMedium!.copyWith(
                    color: appTheme.white,
                  ),
                ),
              ),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: appTheme.secondary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton.filled(
                      onPressed: () {},
                      icon: Icon(
                        Icons.qr_code,
                        color: appTheme.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
