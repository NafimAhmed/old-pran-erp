import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pran_rfl_erp/app_data/entities/machine_list_response.dart';
import 'package:pran_rfl_erp/app_data/entities/user_org_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';

import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';

import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

import 'package:pran_rfl_erp/global_blocs/bloc/user_org_bloc.dart';

class OpmC1Screen extends StatelessWidget {
  const OpmC1Screen({super.key});
  static const String routeName = "OPM-C-1-SCREEN";
  static const String routePath = "/OPM-C-1-SCREEN";
  @override
  Widget build(BuildContext context) {
    return const ProductionScreenBody();
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
      appBar: const CommonAppBar(appBartitle: "Production Copy"),
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
              Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: appTheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Flexible(
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_2,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(child: Text("Miraj Hossain Shawon"))
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            DateTime.now().toFormatedString("dd-MMM-yyy"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
                          onChanged: (value) {},
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CommonDropdownButton(
                      hintText: "Select Machine",
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CommonDropdownButton(
                hintText: "Select Batch",
                onChanged: (value) {},
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

class CommonDropdownButton<T> extends StatelessWidget {
  const CommonDropdownButton({
    super.key,
    required this.hintText,
    this.items,
    this.value,
    required this.onChanged,
    this.validator,
  });
  final String hintText;
  final List<T>? items;
  final T? value;
  final void Function(T? value) onChanged;
  final String? Function(T? value)? validator;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      menuMaxHeight: 250,
      hint: Text(
        hintText,
        style: textTheme.bodyMedium!.copyWith(
          color: appTheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: textTheme.bodyMedium!.copyWith(
        color: appTheme.primary,
        fontWeight: FontWeight.bold,
      ),
      items: items?.map(
        (e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e.toString()),
          );
        },
      ).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
