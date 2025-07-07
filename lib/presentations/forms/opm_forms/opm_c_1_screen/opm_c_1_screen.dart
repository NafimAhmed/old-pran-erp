import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/prod_basic_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/user_details_widget.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_1_screen/bloc/user_machine_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_1_screen/bloc/prod_qr_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_1_screen/bloc/prod_qr_info_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_1_screen/bloc/temp_batch_data_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_1_screen/widgets/prod_table_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OpmC1Screen extends StatelessWidget {
  const OpmC1Screen({super.key, required this.fromName});
  static const String routeName = "OPM-C-1-SCREEN";
  static const String routePath = "/OPM-C-1-SCREEN";

  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProdQrBloc()),
        BlocProvider(create: (context) => ProdQrInfoBloc(getService())),
        BlocProvider(create: (context) => TempBatchDataBloc(getService())),
        BlocProvider(create: (context) => UserMachineBloc(getService())),
      ],
      child: ProductionScreenBody(fromName: fromName),
    );
  }
}

class ProductionScreenBody extends StatefulWidget {
  const ProductionScreenBody({super.key, required this.fromName});
  final String fromName;
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

  final String _locatorId = "";
  final String _itemId = "";
  UserInfoModel? loggedUser;
  UserMachine? selectedMachine;
  List<UserMachine> userMachineList = [];
  GlobalKey<FormState> fromkey = GlobalKey();

  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;
    context.read<UserMachineBloc>().add(
      UserMachineGet(userId: loggedUser!.userId),
    );
    context.read<TempBatchDataBloc>().add(
      TempBatchDataGet(userId: loggedUser!.userId),
    );
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
    dropDownTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              // const SizedBox(
              //   height: 5,
              // ),
              // const UserDetailsWidget(),
              const SizedBox(height: 15),
              // BlocListener<ProdQrBloc, ProdQrState>(
              //   listener: (context, state) {
              //     if (state is ProdQrError) {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(
              //           content: Text(
              //             "Unable to get locator Id",
              //           ),
              //           backgroundColor: Colors.red,
              //         ),
              //       );
              //     }
              //   },
              //   child: ReadQrWidget(
              //     qrType: "Scan QR",
              //     onPressed: () async {
              //       var data = await buildScanner(context, controller);
              //       if (context.mounted) {
              //         context.read<ProdQrBloc>().add(
              //               ProdQrDataGet(
              //                 qrData: data,
              //               ),
              //             );
              //       }
              //     },
              //   ),
              // ),
              // BlocBuilder<ProdQrBloc, ProdQrState>(
              //   buildWhen: (previous, current) => previous != current,
              //   builder: (context, state) {
              //     if (state is ProdQrLoaded) {
              //       _locatorId = state.batchId;
              //       _itemId = state.itemId;
              //       return Container(
              //         padding: const EdgeInsets.all(8.0),
              //         decoration: BoxDecoration(
              //             color: appTheme.primary.withOpacity(
              //               0.5,
              //             ),
              //             borderRadius: BorderRadius.circular(5)),
              //         child: Column(
              //           children: [
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   "Batch Id",
              //                   style: textTheme.bodyMedium,
              //                 ),
              //                 const SizedBox(
              //                   width: 10,
              //                 ),
              //                 Text(
              //                   state.batchId,
              //                   style: textTheme.bodyMedium,
              //                 )
              //               ],
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   "Item Id",
              //                   style: textTheme.bodyMedium,
              //                 ),
              //                 const SizedBox(
              //                   width: 10,
              //                 ),
              //                 Text(
              //                   state.itemId,
              //                   style: textTheme.bodyMedium,
              //                 )
              //               ],
              //             ),
              //           ],
              //         ),
              //       );
              //     }
              //     return Container();
              //   },
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Form(
              //   key: fromkey,
              //   child: Column(
              //     children: [
              //       const SizedBox(
              //         height: 10,
              //       ),
              //       CommonLableWthTextField(
              //         lableName: "Good Qty",
              //         focusNode: goodQtyFocusNode,
              //         textController: goodQtyTextController,
              //         keyboardType: TextInputType.phone,
              //         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              //         onChanged: (value) {
              //           var goodQty = value.isEmpty ? 0 : int.parse(value);
              //           badQtyTextController.text = "0";
              //           var badQty = badQtyTextController.text.isEmpty
              //               ? 0
              //               : int.parse(badQtyTextController.text);
              //           quantityTextController.text =
              //               (goodQty + badQty).toString();
              //         },
              //         validator: (value) {
              //           if (value == null || value.isEmpty) {
              //             return "Please Enter Good Quantity";
              //           }
              //           if (int.parse(value) <= 0) {
              //             return "Can't Be Zero";
              //           }
              //           return null;
              //         },
              //       ),
              //       const SizedBox(
              //         height: 10,
              //       ),
              //       CommonLableWthTextField(
              //         lableName: "Bad Qty",
              //         focusNode: badQtyFocusNode,
              //         textController: badQtyTextController,
              //         keyboardType: TextInputType.phone,
              //         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              //         validator: (value) {
              //           if (value == null || value.isEmpty) {
              //             return "Please Enter Bad Quantity";
              //           }

              //           return null;
              //         },
              //         onChanged: (value) {
              //           var badQty = value.isEmpty ? 0 : int.parse(value);
              //           var goodQty = goodQtyTextController.text.isEmpty
              //               ? 0
              //               : int.parse(goodQtyTextController.text);
              //           quantityTextController.text =
              //               (goodQty + badQty).toString();
              //         },
              //       ),
              //       const SizedBox(
              //         height: 20,
              //       ),
              //       CommonLableWthTextField(
              //         lableName: "Quantity",
              //         readOnly: true,
              //         focusNode: quantityFocusNode,
              //         textController: quantityTextController,
              //         keyboardType: TextInputType.phone,
              //         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              //         validator: (value) {
              //           if (value == null || value.isEmpty) {
              //             return "Please Enter Quantity";
              //           }
              //           return null;
              //         },
              //         onChanged: (value) {},
              //       ),
              //       const SizedBox(
              //         height: 10,
              //       ),
              //       Row(
              //         mainAxisSize: MainAxisSize.max,
              //         children: [
              //           Expanded(
              //             child: BlocBuilder<UserMachineBloc, UserMachineState>(
              //               builder: (context, state) {
              //                 if (state is UserMachineLoaded) {
              //                   selectedMachine = state.selectedmachine;
              //                   userMachineList = state.userMachineList;
              //                 }
              //                 return CommonDropDownMenuWidget(
              //                   enabled: userMachineList.isNotEmpty,
              //                   hintText: "Select Machine",
              //                   controller: dropDownTextController,
              //                   dropdownMenuEntries: userMachineList,
              //                   onSelected: (value) {
              // FocusScope.of(context).unfocus();
              //  FocusManager.instance.primaryFocus?.unfocus();
              //                     context
              //                         .read<UserMachineBloc>()
              //                         .add(MachineSelected(selectedLov: value));
              //                     FocusManager.instance.primaryFocus?.unfocus();
              //                   },
              //                 );
              //               },
              //             ),
              //           ),
              //           const SizedBox(
              //             width: 40,
              //           ),
              //           BlocConsumer<ProdQrInfoBloc, ProdQrInfoState>(
              //             listener: (context, state) {
              //               if (state is ProdQrInfoSuccess) {
              //                 quantityTextController.clear();
              //                 goodQtyTextController.clear();
              //                 badQtyTextController.clear();
              //                 context.read<ProdQrBloc>().add(ProdQrDataReset());
              //                 ScaffoldMessenger.of(context).showSnackBar(
              //                   SnackBar(
              //                     content: const Text(
              //                       "Successfully Added..",
              //                     ),
              //                     backgroundColor: appTheme.primary,
              //                   ),
              //                 );
              //                 context.read<TempBatchDataBloc>().add(
              //                       TempBatchDataGet(
              //                         userId: loggedUser!.userId,
              //                       ),
              //                     );
              //               }
              //               if (state is ProdQrInfoError) {
              //                 ScaffoldMessenger.of(context).showSnackBar(
              //                   SnackBar(
              //                     content: Text(
              //                       state.error.toString(),
              //                     ),
              //                     backgroundColor: Colors.red,
              //                   ),
              //                 );
              //               }
              //             },
              //             builder: (context, state) {
              //               if (state is ProdQrInfoSuccess) {}
              //               return ElevatedButton(
              //                 onPressed: () {
              //                   if (fromkey.currentState!.validate()) {
              //                     if (int.parse(quantityTextController.text) !=
              //                         int.parse(goodQtyTextController.text) +
              //                             int.parse(
              //                                 badQtyTextController.text)) {
              //                       ScaffoldMessenger.of(context).showSnackBar(
              //                         const SnackBar(
              //                           content: Text(
              //                             "Quantity Mismatch",
              //                           ),
              //                           backgroundColor: Colors.red,
              //                         ),
              //                       );
              //                       return;
              //                     }
              //                     if (selectedMachine == null) {
              //                       ScaffoldMessenger.of(context).showSnackBar(
              //                         const SnackBar(
              //                           content: Text(
              //                             "Please Select Machine",
              //                           ),
              //                           backgroundColor: Colors.red,
              //                         ),
              //                       );
              //                       return;
              //                     }
              //                     if (_itemId.isEmpty || _locatorId.isEmpty) {
              //                       ScaffoldMessenger.of(context).showSnackBar(
              //                         const SnackBar(
              //                           content: Text(
              //                             "Please Scan QR Code",
              //                           ),
              //                           backgroundColor: Colors.red,
              //                         ),
              //                       );
              //                       return;
              //                     }

              //                     context.read<ProdQrInfoBloc>().add(
              //                           ProdQrInfoSend(
              //                             itemId: _itemId,
              //                             batchId: _locatorId,
              //                             qty: quantityTextController.text,
              //                             goodQty: goodQtyTextController.text,
              //                             badQty: badQtyTextController.text,
              //                             machine:
              //                                 selectedMachine?.machineName ??
              //                                     "",
              //                           ),
              //                         );
              //                   }
              //                 },
              //                 child: Text(
              //                   state is ProdQrInfoLoading ? "Saving" : "Save",
              //                   style: textTheme.bodyMedium!.copyWith(
              //                     color: appTheme.white,
              //                   ),
              //                 ),
              //               );
              //             },
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 10),
              BlocBuilder<TempBatchDataBloc, TempBatchDataState>(
                builder: (context, state) {
                  if (state is TempBatchDataLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is TempBatchDataSuccess) {
                    var tempBatchDataSource = TempBatchDataSource(
                      tempBatchData: state.tempBatchDataList,
                    );
                    tempBatchDataSource.addColumnGroup(
                      ColumnGroup(name: "Organization", sortGroupRows: false),
                    );
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ProdTableWidget(source: tempBatchDataSource),
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomSheet: const UserDetailsWidget(),
    );
  }
}
