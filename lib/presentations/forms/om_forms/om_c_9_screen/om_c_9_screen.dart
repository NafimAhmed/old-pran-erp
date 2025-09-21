import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/models/user_info_model.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_dependency/di_container.dart';
import 'package:pran_rfl_erp/common_widgets/common_app_bar_widget.dart';
import 'package:pran_rfl_erp/common_widgets/read_qr_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/core/utils/healper_functions.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/item_qr_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/logged_user_info_cubit.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_1_screen/bloc/lot_trn_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/om_forms/om_c_9_screen/bloc/out_chalan_item_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/opm_forms/opm_c_25_screen/opm_c_25_screen.dart';

class OmC9Screen extends StatelessWidget {
  const OmC9Screen({super.key, required this.fromName});
  static const String routeName = "OM-C-9-SCREEN";
  static const String routePath = "/OM-C-9-SCREEN";
  final String fromName;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ItemQrCubit()),
        BlocProvider(create: (context) => OutChalanItemBloc(getService())),
      ],
      child: OmC9ScreenBody(fromName: fromName),
    );
  }
}

class OmC9ScreenBody extends StatefulWidget {
  const OmC9ScreenBody({super.key, required this.fromName});
  final String fromName;
  @override
  State<OmC9ScreenBody> createState() => _OmC8ScreenBodyState();
}

class _OmC8ScreenBodyState extends State<OmC9ScreenBody> {
  late UserInfoModel loggedUser;
  UserBatchQrData? itemQrData;
  @override
  void initState() {
    loggedUser = context.read<LoggedUserInfoCubit>().state.userInfoModel!;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(appBartitle: widget.fromName),
      body: BlocListener<ItemQrCubit, ItemQrState>(
        listener: (context, state) {
          if (state is ItemQrDataError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Unable to Get Item QR Data"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              BlocConsumer<ItemQrCubit, ItemQrState>(
                listener: (context, state) {
                  if (state is ItemQrInitial) {
                    context.read<LotTrnBloc>().add(RestLotTrnData());
                  }
                },
                builder: (context, state) {
                  if (state is ItemQrInitial) {
                    itemQrData = null;
                  }
                  if (state is ItemQrDataLoaded) {
                    itemQrData = state.userBatchQrData;
                    context.read<LotTrnBloc>().add(
                      GetLotTrnDataNew(
                        userId: loggedUser.userId,
                        racklocator: itemQrData?.lotno ?? "",
                      ),
                    );
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
                            itemQrData?.itemname ?? "",
                            style: textTheme.bodyMedium,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                itemQrData?.custname ?? "",
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Lot: ", style: textTheme.bodyMedium),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        itemQrData?.lotno ?? "",
                                        style: textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Qty: ", style: textTheme.bodyMedium),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        itemQrData?.goodQty.toString() ?? "",
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

              BlocBuilder<ItemQrCubit, ItemQrState>(
                builder: (context, state) {
                  if (state is ItemQrDataLoaded) {
                    itemQrData = state.userBatchQrData;
                    return Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          if (itemQrData != null) {
                            context.read<OutChalanItemBloc>().add(
                              AddChalanItem(
                                userId: loggedUser.userId,
                                item: itemQrData!,
                              ),
                            );
                            context.read<ItemQrCubit>().resetItemData();
                          }
                        },
                        child: Text(
                          "Add",
                          style: textTheme.bodyMedium!.copyWith(
                            color: appTheme.white,
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(height: 15),
              BlocBuilder<OutChalanItemBloc, OutChalanItemState>(
                builder: (context, state) {
                  if (state.chalanItems.isEmpty) {
                    return const Center(child: Text("No items added"));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: state.chalanItems.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final data = state.chalanItems[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    data.itemname ?? "Unknown Item",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "Batch: ${data.batchNo ?? "-"}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Customer & Buyer
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoTile(
                                      "Customer",
                                      data.custname,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoTile(
                                      "Buyer",
                                      data.buyername,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // PO & Lot No
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoTile(
                                      "Cust PO",
                                      data.custpo,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoTile("Lot No", data.lotno),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Good Qty & Exp Date
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoTile(
                                      "Good Qty",
                                      data.goodQty?.toString(),
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoTile(
                                      "Exp Date",
                                      data.expdate,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),
                              // Footer
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Job: ${data.jobno ?? "-"}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "Created: ${data.createdDate ?? "-"}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value ?? "-",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
