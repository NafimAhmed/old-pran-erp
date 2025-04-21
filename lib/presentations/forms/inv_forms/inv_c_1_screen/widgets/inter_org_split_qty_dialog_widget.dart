import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pran_rfl_erp/common_widgets/common_text_field_widget.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';
import 'package:pran_rfl_erp/presentations/forms/inv_forms/inv_c_1_screen/bloc/inter_org_transfer_bloc.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/item_qr_cubit.dart';
import 'package:pran_rfl_erp/global_blocs/cubit/rack_qr_cubit.dart';

class InterOrgSplitQtyDialog extends StatelessWidget {
  InterOrgSplitQtyDialog({
    super.key,
    required this.blocContext,
    required this.batchId,
    required this.itemId,
    required this.rackId,
    required this.userid,
  });
  final BuildContext blocContext;
  final String userid;
  final String batchId;
  final String itemId;
  final String rackId;
  final TextEditingController splitQtyTextController = TextEditingController();
  final FocusNode splitQtyFocusNode = FocusNode();
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<InterOrgTransferBloc>(blocContext),
        ),
        BlocProvider.value(
          value: BlocProvider.of<ItemQrCubit>(blocContext),
        ),
        BlocProvider.value(
          value: BlocProvider.of<RackQrCubit>(blocContext),
        ),
        // BlocProvider.value(
        //   value: BlocProvider.of<TransferedBatchDataBloc>(blocContext),
        // ),
      ],
      child: BlocListener<InterOrgTransferBloc, InterOrgTransferState>(
        listener: (context, state) {
          if (state is InterOrgTransferSuccess) {
            splitQtyTextController.clear();
            context.pop();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Enter Split Quantity",
                style: textTheme.bodyMedium!.copyWith(
                  color: appTheme.primary,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Form(
                key: fromKey,
                child: Row(
                  children: [
                    Expanded(
                      child: CommonTextFieldWidget(
                        focusNode: splitQtyFocusNode,
                        textAlign: TextAlign.center,
                        controller: splitQtyTextController,
                        keyboardType: TextInputType.phone,
                        style: textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: appTheme.primary,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        labelText: "",
                        onChanged: (value) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Split Quantity";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // BlocSelector<InterOrgTransferBloc, InterOrgTransferState, String>(
              //   selector: (state) {
              //     return state is InterOrgTransferLoading
              //         ? state.splitFlag == "1"
              //             ? "Saving.."
              //             : "Save"
              //         : "Save";
              //   },
              //   builder: (context, selectedState) {
              //     return ElevatedButton(
              //       onPressed: () {
              //         // if (fromKey.currentState!.validate()) {
              //         //   blocContext.read<InterOrgTransferBloc>().add(
              //         //       InterOrgTransfer(
              //         //           userid: userid,
              //         //           trackid: rackId,
              //         //           itemid: itemId,
              //         //           rqty: splitQtyTextController.text,
              //         //           batchid: batchId,
              //         //           split: "1"));
              //         // }
              //       },
              //       child: Text(
              //         selectedState,
              //         style: textTheme.bodySmall!.copyWith(
              //           color: Colors.white,
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
