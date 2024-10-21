import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pran_rfl_erp/app_data/entities/lov_response.dart';
import 'package:pran_rfl_erp/app_data/entities/temp_batch_data_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';

import 'package:pran_rfl_erp/core/extentions/extentions.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/presentations/production_screen/bloc/lov_bloc.dart';
import 'package:pran_rfl_erp/presentations/production_screen/bloc/prod_qr_bloc.dart';
import 'package:pran_rfl_erp/presentations/production_screen/bloc/prod_qr_info_bloc.dart';
import 'package:pran_rfl_erp/presentations/production_screen/bloc/temp_batch_data_bloc.dart';
import 'package:pran_rfl_erp/presentations/transfer_screen/transfer_screen.dart';

class ProductionScreen extends StatelessWidget {
  const ProductionScreen({super.key});
  static const String routeName = "prod-supervisor/production-screen";
  static const String routePath = "prod-supervisor/production-screen";
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProdQrBloc(),
        ),
        BlocProvider(
          create: (context) => ProdQrInfoBloc(getService()),
        ),
        BlocProvider(
          create: (context) =>
              TempBatchDataBloc(getService())..add(TempBatchDataGet()),
        ),
        BlocProvider(
          create: (context) => LovBloc(getService())..add(LovGet()),
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

  String _locatorId = "";
  String _itemId = "";
  Lov? selectedLov;
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
      appBar: const CommonAppBar(appBartitle: "Production"),
      body: Container(
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
            BlocListener<ProdQrBloc, ProdQrState>(
              listener: (context, state) {
                if (state is ProdQrError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Unable to get locator Id",
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Row(
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
                          "Scan QR",
                          style: textTheme.bodyMedium!.copyWith(
                            color: appTheme.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  IconButton.filled(
                    iconSize: 30,
                    onPressed: () async {
                      var data = await _buildScanner(context, controller);

                      context.read<ProdQrBloc>().add(
                            ProdQrDataGet(
                              qrData: data,
                            ),
                          );
                    },
                    icon: Icon(
                      Icons.qr_code_scanner_rounded,
                      color: appTheme.white,
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<ProdQrBloc, ProdQrState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                if (state is ProdQrLoaded) {
                  _locatorId = state.batchId;
                  _itemId = state.itemId;
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: appTheme.primary.withOpacity(
                          0.5,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Batch Id",
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              state.batchId,
                              style: textTheme.bodyMedium,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Item Id",
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              state.itemId,
                              style: textTheme.bodyMedium,
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
            const SizedBox(
              height: 10,
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
                            var goodQty = value.isEmpty ? 0 : int.parse(value);
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
                  Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<LovBloc, LovState>(
                          builder: (context, state) {
                            if (state is LovLoaded) {
                              selectedLov = state.selectedLov;
                            }
                            return CommonDropdownButton<Lov>(
                              hintText: "Select Machine",
                              items: state is LovLoaded ? state.lovList : [],
                              value:
                                  state is LovLoaded ? state.selectedLov : null,
                              onChanged: (value) {
                                context
                                    .read<LovBloc>()
                                    .add(LovChanged(selectedLov: value));
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Please Select Machine";
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      BlocConsumer<ProdQrInfoBloc, ProdQrInfoState>(
                        listener: (context, state) {
                          if (state is ProdQrInfoSuccess) {
                            quantityTextController.clear();
                            goodQtyTextController.clear();
                            badQtyTextController.clear();
                            context.read<ProdQrBloc>().add(ProdQrDataReset());
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  "Successfully Added..",
                                ),
                                backgroundColor: appTheme.primary,
                              ),
                            );
                            context
                                .read<TempBatchDataBloc>()
                                .add(TempBatchDataGet());
                          }
                          if (state is ProdQrInfoError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Couldn't save the data",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is ProdQrInfoSuccess) {}
                          return ElevatedButton(
                            onPressed: () {
                              if (fromkey.currentState!.validate()) {
                                if (int.parse(quantityTextController.text) !=
                                    int.parse(goodQtyTextController.text) +
                                        int.parse(badQtyTextController.text)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Quantity Mismatch",
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                if (_itemId.isEmpty || _locatorId.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please Scan QR Code",
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                context.read<ProdQrInfoBloc>().add(
                                      ProdQrInfoSend(
                                        itemId: _itemId,
                                        batchId: _locatorId,
                                        qty: quantityTextController.text,
                                        goodQty: goodQtyTextController.text,
                                        badQty: badQtyTextController.text,
                                        machine: selectedLov?.machineName ?? "",
                                      ),
                                    );
                              }
                            },
                            child: Text(
                              state is ProdQrInfoLoading ? "Saving" : "Save",
                              style: textTheme.bodyMedium!.copyWith(
                                color: appTheme.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: BlocBuilder<TempBatchDataBloc, TempBatchDataState>(
                builder: (context, state) {
                  if (state is TempBatchDataLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is TempBatchDataSuccess) {
                    var groupedList = groupBy(
                      state.tempBatchDataList,
                      (p0) => p0.organizationCode,
                    );
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: appTheme.primary.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: appTheme.primary,
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "ORG No:",
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: appTheme.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      groupedList.keys.elementAt(index) ?? "",
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: appTheme.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(columns: const [
                                  // Set the name of the column
                                  DataColumn(
                                    label: Text('Batch No'),
                                  ),
                                  DataColumn(
                                    label: Text('Item Code'),
                                  ),
                                  DataColumn(
                                    label: Text('Item Name'),
                                  ),
                                  DataColumn(
                                    numeric: true,
                                    label: Text('Original Qty'),
                                  ),
                                  DataColumn(
                                    numeric: true,
                                    label: Text('Total Qty'),
                                  ),
                                ], rows: [
                                  ...List.generate(
                                    groupedList.entries
                                        .elementAt(index)
                                        .value
                                        .length,
                                    (indx) {
                                      TempBatchData tempBatchData = groupedList
                                          .entries
                                          .elementAt(index)
                                          .value[indx];
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(tempBatchData.batchNo ?? ""),
                                          ),
                                          DataCell(
                                            Text(tempBatchData.itemCode ?? ""),
                                          ),
                                          DataCell(
                                            Text(tempBatchData.itemName ?? ""),
                                          ),
                                          DataCell(
                                            Text(
                                              tempBatchData.originalQty
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              tempBatchData.totalQty.toString(),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                ]),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: groupedList.length,
                    );
                  }
                  return Container();
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _buildScanner(
      BuildContext context, MobileScannerController? controller) async {
    // Use a completer to wait for the scanned result
    final completer = Completer<String>();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          alignment: Alignment.center,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              5.0,
            ),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width * 0.45,
            padding: const EdgeInsets.all(10.0),
            child: QrScannerWidget(
              controller: controller,
              onDetect: (barcodes) {
                final String detectedData = barcodes.barcodes.isNotEmpty
                    ? barcodes.barcodes.first.rawValue ?? 'No data found'
                    : 'No data found';

                // Complete the completer with the detected data
                completer.complete(detectedData);

                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );

    // Await the completion of the completer and return the result
    return completer.future;
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
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
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
